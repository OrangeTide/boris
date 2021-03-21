/*
 * unlimited fgets (dynamically allocates)
 * 
 * Jon Mayo 19971228
 */

#include "toolkit.h"
#include <stdlib.h>
#include <ctype.h>

/* YETI: use of limit */
char *lfgets(FILE *stream, int stripnl, int limit)
{
   int curr=0;
   int bufsize=2;
   char *Ret=calloc(1,bufsize);
   char *X;
   do
     {
	if (!(Ret=realloc(Ret,bufsize)))
	  break;
	X=fgets(Ret+curr,bufsize-curr,stream);
	curr+=strlen(Ret+curr);
	if(curr>0)
	  {
	     if (Ret[curr-1] == '\n')
	       {
		  if(stripnl)
		    Ret[curr-1]=0;
		  break;
	       }
	  }
	else
	  break;
	bufsize*=2;
     }
   while(X);
   return curr ? Ret : NULL;
}


#if !defined(__USE_BSD) 
/* I've optimized these as best as I could, 
 * that's why they look a little weird */
int strcasecmp(const char *s1, const char *s2)
{
   int i;
   for(i=0; ( (tolower(s1[i]) == tolower(s2[i])) && s1[i]);i++) ;
   return !(s1[i]==0 && s2[i]==0);
}

int strncasecmp(const char *s1, const char *s2, size_t n)
{
   size_t i;
   int q;
   for(i=0; ( (q=(tolower(s1[i]) == tolower(s2[i]))) && s1[i] && ((i+1)<n));i++) ;
   return !q;
}

#if 0
char *strdup(const char *s)
{
   char *Ret;
   int length;
   Ret=malloc((length=strlen(s)) + 1);
   Ret[length]=0;
   memcpy(Ret,s,length);
   return Ret;
}
#endif
#endif
