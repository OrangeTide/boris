#!/bin/sh
# kanban-sync.sh -- sync kanban/ card status to GitLab work items
#
# For each kanban/*.md card:
#   - has gitlab-sync ref  -> sync status (done=close, active/backlog=reopen)
#   - has gitlab-sync:     -> create new issue, write ref back into card
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
        # existing issue -- sync status
        iid="$(echo "$sync_ref" | sed 's/.*#//')"
        state_event="$(card_status_to_gitlab "$status")"
        echo "sync: ${slug} -> #${iid} (${state_event})"
        curl -sf -X PUT "${API}/issues/${iid}" \
            -H "${AUTH_HEADER}" \
            -H "Content-Type: application/json" \
            -d "{\"state_event\": \"${state_event}\"}" \
            >/dev/null
    else
        # no issue -- create one
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
        # extract project path from CI or default
        project_path="${CI_PROJECT_PATH:-OrangeTide/boris}"
        ref="${project_path}#${iid}"
        # write ref back into card -- use | delimiter to avoid / in path
        sed -i "s|^gitlab-sync:$|gitlab-sync: ${ref}|" "$card"
        CARDS_CHANGED=1
        echo "created: ${slug} -> ${ref}"
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
    git commit -m "kanban: populate gitlab-sync refs [skip ci]"
    git push "https://oauth2:${GITLAB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git" \
        "HEAD:${CI_COMMIT_REF_NAME}"
fi
