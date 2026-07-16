#!/bin/sh
# kanban-sync.sh -- sync kanban/ card status to GitLab work items
#
# For each kanban/*.md card:
#   - has gitlab-sync ref  -> sync status and title by issue id (a card with a
#                             ref can be renamed; the id is the stable key)
#   - has gitlab-sync:     -> re-link to an existing issue by title, else create,
#                             then write the ref back into the card
#   - has gitlab-sync: none -> skip
#
# Requires: GITLAB_TOKEN (CI_JOB_TOKEN works in CI), CI_PROJECT_ID
#
# PUBLIC DOMAIN (CC0-1.0)

set -eu

: "${GITLAB_TOKEN:?GITLAB_TOKEN required}"
: "${CI_PROJECT_ID:?CI_PROJECT_ID required}"

API="https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}"
AUTH_HEADER="PRIVATE-TOKEN: ${GITLAB_TOKEN}"
CARDS_CHANGED=0

parse_frontmatter() {
    # extract a YAML frontmatter field value from a card
    # strips optional surrounding quotes from the value
    sed -n '/^---$/,/^---$/{ /^'"$1"':/{ s/^'"$1"': *//; s/^"//; s/"$//; p; q; } }' "$2"
}

json_escape() {
    # escape a string for embedding in JSON
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g' | \
        awk '{ if (NR > 1) printf "\\n"; printf "%s", $0 }'
}

card_status_to_gitlab() {
    case "$1" in
        done)    echo "close" ;;
        active)  echo "reopen" ;;
        backlog) echo "reopen" ;;
        *)       echo "reopen" ;;
    esac
}

url_encode() {
    # percent-encode a string for use in a query parameter
    printf '%s' "$1" | awk '
        BEGIN { for (i = 0; i < 256; i++) ord[sprintf("%c", i)] = i }
        {
            n = length($0); s = ""
            for (i = 1; i <= n; i++) {
                c = substr($0, i, 1)
                if (c ~ /[A-Za-z0-9._~-]/) s = s c
                else s = s sprintf("%%%02X", ord[c])
            }
            printf "%s", s
        }'
}

find_issue_by_title() {
    # echo the LOWEST iid of an existing issue whose title exactly matches $1,
    # searching both open and closed issues. Empty output if none found.
    #
    # This is the idempotency guard: a card whose gitlab-sync ref was lost
    # (e.g. a force-push rewound the CI ref-writeback commit) is re-linked to
    # its existing issue instead of spawning a duplicate.
    _q="$(url_encode "$1")"
    curl -sf "${API}/issues?in=title&state=all&per_page=100&search=${_q}" \
        -H "${AUTH_HEADER}" 2>/dev/null \
    | awk -v want="$1" '
        # Minimal JSON scanner: capture "iid" and "title" only at the top level
        # of each issue object (object depth 1, array depth 1), so nested
        # objects (author, milestone, references) and arrays (labels) are
        # ignored. Track the lowest matching iid.
        { data = data $0 "\n" }
        END {
            n = length(data); od = 0; ad = 0
            instr = 0; esc = 0; buf = ""; laststr = ""
            curkey = ""; numbuf = ""; best = ""
            cur_iid = ""; cur_title = ""
            for (i = 1; i <= n; i++) {
                c = substr(data, i, 1)
                if (instr) {
                    if (esc)        { buf = buf c; esc = 0; continue }
                    if (c == "\\")  { esc = 1; continue }
                    if (c == "\"") {
                        instr = 0
                        if (od == 1 && ad == 1 && curkey != "") {
                            if (curkey == "title") cur_title = buf
                            curkey = ""
                        } else {
                            laststr = buf
                        }
                        continue
                    }
                    buf = buf c
                    continue
                }
                if (c == "\"") { instr = 1; buf = ""; continue }
                if (c == "{") {
                    od++
                    if (od == 1 && ad == 1) { cur_iid=""; cur_title=""; curkey="" }
                    continue
                }
                if (c == "}") {
                    if (od == 1 && ad == 1 && cur_title == want && cur_iid != "") {
                        if (best == "" || cur_iid+0 < best+0) best = cur_iid
                    }
                    od--
                    if (od == 1) curkey = ""
                    continue
                }
                if (c == "[") { ad++; continue }
                if (c == "]") { ad--; continue }
                if (c == ":") { if (od == 1 && ad == 1) curkey = laststr; continue }
                if (c == ",") {
                    if (od == 1 && ad == 1) {
                        if (curkey == "iid" && numbuf != "") cur_iid = numbuf
                        curkey = ""; numbuf = ""
                    }
                    continue
                }
                if (od == 1 && ad == 1 && curkey == "iid" && c ~ /[0-9]/)
                    numbuf = numbuf c
            }
            if (best != "") print best
        }'
}

sync_card() {
    card="$1"
    slug="$(basename "$card" .md)"
    title="$(parse_frontmatter title "$card")"
    status="$(parse_frontmatter status "$card")"
    sync_ref="$(parse_frontmatter gitlab-sync "$card")"

    # explicit opt-out
    if [ "$sync_ref" = "none" ]; then
        echo "skip: ${slug} (opted out)"
        return
    fi

    if [ -n "$sync_ref" ]; then
        # existing issue -- the ref is the stable key, so sync status AND title.
        # This is what makes a card rename safe: once the front matter carries an
        # issue id we address the issue by number, never by title, so a retitled
        # card updates its existing issue instead of spawning a new one.
        iid="$(echo "$sync_ref" | sed 's/.*#//')"
        state_event="$(card_status_to_gitlab "$status")"
        esc_title="$(json_escape "$title")"
        echo "sync: ${slug} -> #${iid} (${state_event}, title)"
        curl -sf -X PUT "${API}/issues/${iid}" \
            -H "${AUTH_HEADER}" \
            -H "Content-Type: application/json" \
            -d "{\"state_event\": \"${state_event}\", \"title\": \"${esc_title}\"}" \
            >/dev/null
    else
        # no ref yet -- re-link to an existing issue if one matches by title,
        # otherwise create a new one. The title lookup keeps this idempotent:
        # a lost ref (e.g. after a force-push) links back instead of duplicating.
        iid="$(find_issue_by_title "$title")"
        if [ -n "$iid" ]; then
            echo "relink: ${slug} -> #${iid} (existing issue found by title)"
        else
            description="$(sed '1,/^---$/d; /^---$/,$ { /^---$/d; }' "$card" | sed '/^$/d')"
            echo "create: ${slug} -> new issue"
            esc_title="$(json_escape "$title")"
            esc_desc="$(json_escape "$description")"
            response="$(curl -sf -X POST "${API}/issues" \
                -H "${AUTH_HEADER}" \
                -H "Content-Type: application/json" \
                -d "{\"title\": \"${esc_title}\", \"description\": \"${esc_desc}\"}")"
            iid="$(echo "$response" | sed -n 's/.*"iid" *: *\([0-9]*\).*/\1/p' | head -1)"
            if [ -z "$iid" ]; then
                echo "error: failed to create issue for ${slug}"
                return 1
            fi
            echo "created: ${slug} -> #${iid}"
        fi
        # extract project path from CI or default
        project_path="${CI_PROJECT_PATH:-OrangeTide/boris}"
        ref="${project_path}#${iid}"
        # write ref back into card -- use | delimiter to avoid / in path
        sed -i "s|^gitlab-sync:$|gitlab-sync: ${ref}|" "$card"
        CARDS_CHANGED=1
        # bring the (possibly reused) issue's state in line with the card
        state_event="$(card_status_to_gitlab "$status")"
        curl -sf -X PUT "${API}/issues/${iid}" \
            -H "${AUTH_HEADER}" \
            -H "Content-Type: application/json" \
            -d "{\"state_event\": \"${state_event}\"}" \
            >/dev/null
        echo "linked: ${slug} -> ${ref} (${state_event})"
    fi
}

for card in kanban/*.md; do
    [ -f "$card" ] || continue
    sync_card "$card"
done

if [ "$CARDS_CHANGED" -eq 1 ]; then
    echo "committing new gitlab-sync refs..."
    git config user.email "${GITLAB_USER_EMAIL:-ci@boris}"
    git config user.name "${GITLAB_USER_NAME:-kanban-sync}"
    git add kanban/*.md
    if ! git commit -m "kanban: populate gitlab-sync refs [skip ci]"; then
        echo "FATAL: failed to commit gitlab-sync refs." >&2
        exit 1
    fi
    if git push "https://oauth2:${GITLAB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git" \
            "HEAD:${CI_COMMIT_REF_NAME}"; then
        echo "pushed gitlab-sync refs to ${CI_COMMIT_REF_NAME}"
    else
        # The kanban-sync job runs with Developer rights, which cannot push to a
        # protected branch. Warn but do not fail: the refs are not persisted this
        # run, yet the title-lookup guard re-links the existing issues next run
        # instead of creating duplicates. To persist refs, allow this job's
        # identity to push to '${CI_COMMIT_REF_NAME}'.
        echo "WARNING: gitlab-sync refs were committed but the push to" \
             "'${CI_COMMIT_REF_NAME}' failed." >&2
        echo "         The GitLab issues exist, but their refs are NOT persisted" \
             "in the repo this run (commonly: the CI user cannot push to the" >&2
        echo "         protected branch). Not failing the job -- the title-lookup" \
             "guard re-links the existing issues on the next run rather than" >&2
        echo "         creating duplicates." >&2
    fi
fi
