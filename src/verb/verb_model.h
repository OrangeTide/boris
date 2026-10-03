/* verb_model.h : command-verb resolution over the object scope */

#ifndef VERB_MODEL_H_
#define VERB_MODEL_H_

#include "obj.h"                /* OBJ_PATH_MAX */
#include "verb_spec.h"          /* VERB_SPEC_BUF_MAX */

/* Longest command word a verb property name can carry. */
#define VERB_WORD_MAX 64

/* A resolved verb: the object it was found on, the program to run, and the
 * argument spec to match the rest of the command against. */
struct verb_def {
	char holder[OBJ_PATH_MAX];      /* object the verb.<word> was found on */
	char prog[OBJ_PATH_MAX];        /* program id passed to dispatch */
	char spec[VERB_SPEC_BUF_MAX];   /* argument pattern for verb_spec */
};

/*
 * Resolve a command word in the actor's scope. The scope is searched in order:
 * the actor, the actor's location, the actor's held (direct-contents) items,
 * then the room contents; each object through a prototype walk (%parent). The
 * first object that defines verb.<word> wins.
 *
 * The property value is packed as "<prog_id>\t<argspec>"; a value with no tab
 * is taken as a program id with an empty spec.
 *
 * On a match fills `out` and returns 1. Returns 0 when no object in scope
 * defines the verb, and -1 on a bad argument.
 */
int verb_resolve(const char *actor_id, const char *word, struct verb_def *out);

#endif /* VERB_MODEL_H_ */
