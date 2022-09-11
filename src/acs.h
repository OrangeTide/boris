#ifndef ACS_H_
#define ACS_H_

/** access control system - holds all data to use acs functions. */
struct acs_info {
	unsigned char level;
	unsigned flags;
};

void acs_init(struct acs_info *ai, unsigned level, unsigned flags);
int acs_testflag(struct acs_info *ai, unsigned flag);
int acs_check(struct acs_info *ai, const char *acsstring);
void acs_test(void);
#endif
