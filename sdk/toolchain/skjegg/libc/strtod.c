#include <stdlib.h>
#include <ctype.h>

/* Parse a decimal floating constant: optional sign, integer and fraction
   digits, and an optional e/E exponent.  The accumulation is plain double
   arithmetic, correct to the digits a double carries (the same bound the
   printf float path documents).  Hex floats, inf, and nan are not recognized;
   *end is set to the first unconsumed character, or to the start when no digit
   was seen. */
double
strtod(const char *s, char **end)
{
    const char *start = s;
    double result = 0.0;
    int neg = 0;
    int any = 0;

    while (isspace((unsigned char)*s))
        s++;
    if (*s == '+' || *s == '-') {
        neg = (*s == '-');
        s++;
    }

    while (*s >= '0' && *s <= '9') {
        result = result * 10.0 + (double)(*s - '0');
        s++;
        any = 1;
    }
    if (*s == '.') {
        double scale = 1.0;
        s++;
        while (*s >= '0' && *s <= '9') {
            scale *= 0.1;
            result += (double)(*s - '0') * scale;
            s++;
            any = 1;
        }
    }

    if (any && (*s == 'e' || *s == 'E')) {
        const char *esave = s;
        int eneg = 0, exp = 0, edig = 0, i;
        s++;
        if (*s == '+' || *s == '-') {
            eneg = (*s == '-');
            s++;
        }
        while (*s >= '0' && *s <= '9') {
            exp = exp * 10 + (*s - '0');
            s++;
            edig = 1;
        }
        if (edig) {
            double p = 1.0;
            for (i = 0; i < exp; i++)
                p *= 10.0;
            if (eneg)
                result /= p;
            else
                result *= p;
        } else {
            s = esave;          /* a lone e with no digits is not consumed */
        }
    }

    if (end)
        *end = (char *)(any ? s : start);
    return neg ? -result : result;
}

double
atof(const char *s)
{
    return strtod(s, NULL);
}
