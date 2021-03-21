/* base64_main.c : a small base64 encoder/decoder example utility */
#include "base64.h"
#include <stdio.h>
#include <ctype.h>

int main(int argc, char **argv)
{
    char encoded[4];
    char decoded[3];
    int count;
    int encoder_mode=0;

    encoder_mode=(argc==2 && (argv[1][0]=='-' && argv[1][1]=='e'));
    if(encoder_mode) {
        /* encoder */
        int c;
        int i;
        int count;
        do {
            for(count=0;count<3;count++) { /* read in some data */
                c=fgetc(stdin);
                if(c==EOF) break;
                decoded[count]=c;
            }
            if(count) {
                for(i=count;i<3;i++) { /* clear out remainder */
                    decoded[i]=0;
                }
                base64encode(decoded,encoded,count);
                for(i=0;i<4;i++) {
                    fputc(encoded[i],stdout);
                }
            }
        } while(c!=EOF);
    } else {
        /* decoder */
        int c;
        int i;
        do {
            for(i=0;i<4;i++) {
                do {
                    c=fgetc(stdin);
                } while(c!=EOF && isspace(c));
                if(c==EOF) break;
                encoded[i]=c;
            }
            if(c!=EOF) {
                count=base64decode(encoded,decoded);
                for(i=0;i<count;i++) {
                    fputc(decoded[i],stdout);
                }
            }
        } while(c!=EOF);
    }

    return 0;
}
