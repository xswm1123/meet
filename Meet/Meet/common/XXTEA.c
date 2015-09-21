#ifndef XXTEA_h
#define XXTEA_h
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "XXTEA.h"
      // 一种32位长的数据类型，因int在32bit和64bit系统中都是32位的，故直接用int
#endif
 xxtea_long *xxtea_to_long_array(unsigned char *data, xxtea_long len, int include_length, xxtea_long *ret_len) {
    xxtea_long i, n, *result;
	n = len >> 2;
    n = (((len & 3) == 0) ? n : n + 1);
    if (include_length) {
        result = (xxtea_long *)malloc((n + 1) << 2);
        result[n] = len;
	    *ret_len = n + 1;
	} else {
        result = (xxtea_long *)malloc(n << 2);
	    *ret_len = n;
    }
	memset(result, 0, n << 2);
	for (i = 0; i < len; i++) {
        result[i >> 2] |= (xxtea_long)data[i] << ((i & 3) << 3);
    }
    return result;
}

 char *xxtea_to_byte_array(xxtea_long *data, xxtea_long len, int include_length, xxtea_long *ret_len) {
    xxtea_long i, n, m;
    char *result;
    n = len << 2;
    if (include_length) {
        m = data[len - 1];
        if ((m < n - 7) || (m > n - 4)){
			return NULL;
		}
        n = m;
    }
	result = (char *)malloc(n + 1);
	for (i = 0; i < n; i++) {
		int temp = (char)((data[i >> 2] >> ((i & 3) << 3)));
		result[i] = temp;
    }
	result[n] = '\0';
	*ret_len = n;
	return result;
}

 char *xxtea_encrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len) {
    char *result;
    xxtea_long *v, *k, v_len, k_len;
    v = xxtea_to_long_array(data, len, 1, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_encrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 0, ret_len);
    free(v);
    free(k);
    return result;
}

char *xxtea_decrypt(unsigned char *data, xxtea_long len, unsigned char *key, xxtea_long *ret_len) {
    char *result;
    xxtea_long *v, *k, v_len, k_len;
    v = xxtea_to_long_array(data, len, 0, &v_len);
    k = xxtea_to_long_array(key, 16, 0, &k_len);
    xxtea_long_decrypt(v, v_len, k);
    result = xxtea_to_byte_array(v, v_len, 1, ret_len);
    free(v);
    free(k);
    return result;
}

char *encryptxxtea(char *data,char *key){
	xxtea_long ret_len;
	char *ret = xxtea_encrypt((unsigned char*)data,strlen(data),(unsigned char*)key,&ret_len);
	if(NULL != ret){
		char *result;
		result = (char*)malloc(ret_len << 1 + 1); 
		for(int i = 0;i < ret_len;i++){
			sprintf(result + i * 2,"%02X",ret[i]&0xff);
		}
		return result;
	}else{
		return NULL;
	}
}

char *decrypt(char *hexStr,char *key){
	char *b_data;
	xxtea_long d_len = strlen(hexStr) >> 1;
	b_data = (char *)malloc(d_len);
	for(int i = 0;i < d_len;i++){
		int value = 0;
		sscanf(hexStr+2*i,"%2x",&value);
		*(b_data+i) = value & 0xff;
	}
	xxtea_long ret_len;
	char *ret = xxtea_decrypt((unsigned char*)b_data,d_len,(unsigned char*)key,&ret_len);
	if(NULL == ret){
		return NULL;
	}else{
		return ret;
	}
}

void xxtea_long_encrypt(xxtea_long *v, xxtea_long len, xxtea_long *k) {
    xxtea_long n = len - 1;
    xxtea_long z = v[n], y = v[0], p, q = 6 + 52 / (n + 1), sum = 0, e;
    if (n < 1) {
        return;
    }
    while (0 < q--) {
        sum += XXTEA_DELTA;
        e = sum >> 2 & 3;
        for (p = 0; p < n; p++) {
            y = v[p + 1];
            z = v[p] += XXTEA_MX;
        }
        y = v[0];
        z = v[n] += XXTEA_MX;
    }
}

void xxtea_long_decrypt(xxtea_long *v, xxtea_long len, xxtea_long *k) {
    xxtea_long n = len - 1;
    xxtea_long z = v[n], y = v[0], p, q = 6 + 52 / (n + 1), sum = q * XXTEA_DELTA, e;
    if (n < 1) {
        return;
    }
    while (sum != 0) {
        e = sum >> 2 & 3;
        for (p = n; p > 0; p--) {
            z = v[p - 1];
            y = v[p] -= XXTEA_MX;
        }
        z = v[n];
        y = v[0] -= XXTEA_MX;
        sum -= XXTEA_DELTA;
    }
}
