#ifndef GOST_GOST2015_H
#define GOST_GOST2015_H

#include <openssl/evp.h>

#define MAGMA_MAC_MAX_SIZE 8
#define KUZNYECHIK_MAC_MAX_SIZE 16
#define OID_GOST_CMS_MAC "1.2.643.7.1.0.6.1.1"

int gost2015_final_call(EVP_CIPHER_CTX *ctx, EVP_MD_CTX *omac_ctx, size_t mac_size,
			unsigned char *encrypted_mac,
			int (*do_cipher) (EVP_CIPHER_CTX *ctx,
				unsigned char *out,
				const unsigned char *in,
				size_t inl));

/* IV is expected to be 16 bytes*/
int gost2015_get_asn1_params(const ASN1_TYPE *params, size_t ukm_size,
	unsigned char *iv, size_t ukm_offset, unsigned char *kdf_seed);

int gost2015_set_asn1_params(ASN1_TYPE *params,
	const unsigned char *iv, size_t iv_size, const unsigned char *kdf_seed);
#endif
