typedef unsigned int xxtea_long;
#define XXTEA_MX (z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z)
#define XXTEA_DELTA 0x98e7a9b

//
//void xxtea_long_encrypt(xxtea_long *v, xxtea_long len, xxtea_long *k);
//void xxtea_long_decrypt(xxtea_long *v, xxtea_long len, xxtea_long *k);
//char *xxtea_encrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len);
//char *xxtea_decrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len);
//char *encryptxxtea(char *data,char *key);
//char *decrypt(char *data,char *key);

#if defined XXTEA_H
extern "C" {
#endif
    void xxtea_long_encrypt(xxtea_long *v, xxtea_long len, xxtea_long *k);
    void xxtea_long_decrypt(xxtea_long *v, xxtea_long len, xxtea_long *k);
    char *xxtea_encrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len);
    char *xxtea_decrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len);
    char *encryptxxtea(char *data,char *key);
    char *decrypt(char *data,char *key);
    
#if defined XXTEA_H
};
#endif