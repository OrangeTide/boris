#ifndef BORIS_CHARACTER_H_
#define BORIS_CHARACTER_H_

struct character;

int character_initialize(void);
void character_shutdown(void);
/**
 * find a character by id and return it.
 * increases reference count on a character.
 */
struct character *character_get(unsigned character_id);
/** reduce reference count on a character */
void character_put(struct character *ch);
/**
 * create a new character with next available id.
 * increases reference count on a character.
 */
struct character *character_new(void);
/**
 * set an attribute on a character.
 */
int character_attr_set(struct character *ch, const char *name, const char *value);
/**
 * get an attribute on a character.
 * value is temporary and may disappear if the character is flushed,
 * changed or attr_get() is called again.
 */
const char *character_attr_get(struct character *ch, const char *name);
/**
 * save a character to disk (only if it is dirty).
 */
int character_save(struct character *ch);

#endif
