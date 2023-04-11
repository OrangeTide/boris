#include "boris.h"
#include "log.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/resource.h>

/* increase maximum number of open file descriptors */
int
fds_init(void)
{
        struct rlimit rlim;
        int e = getrlimit(RLIMIT_NOFILE, &rlim);
        if (e) {
		perror("getrlimit()");
		return ERR;
	}
        rlim.rlim_cur = rlim.rlim_max;
        e = setrlimit(RLIMIT_NOFILE, &rlim);
        if (e) {
		perror("setrlimit()");
		return ERR;
	}
        LOG_INFO("Max open FDs is %ld\n", (long)rlim.rlim_cur);
        return 0;
}
