#ifndef BASE64_H
#define BASE64_H
void base64encode(const unsigned char in[3], unsigned char out[4], int count);
int base64decode(const char in[4], char out[3]);
#endif /* BASE64_H */
