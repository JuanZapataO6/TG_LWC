	FILE                *fp;
	char                fileName[MAX_FILE_NAME]; //MAX_FILE_NAME      256
	unsigned char       key[CRYPTO_KEYBYTES];// CRYPTO_KEYBYTES       32 (api.h)
	unsigned char		nonce[CRYPTO_NPUBBYTES];//CRYPTO_NPUBBYTES    16
	unsigned char       msg[MAX_MESSAGE_LENGTH];//MAX_MESSAGE_LENGTH  15
	unsigned char       msg2[MAX_MESSAGE_LENGTH];//MAX_MESSAGE_LENGTH 15
	unsigned char		ad[MAX_ASSOCIATED_DATA_LENGTH];// MAX_ASSOCIATED_DATA_LENGTH  0
	unsigned char		ct[MAX_MESSAGE_LENGTH + CRYPTO_ABYTES];//MAX_MESSAGE_LENGTH 15 + CRYPTO_ABYTES 32 (api.h) = 47
	unsigned long long  clen, mlen2;
	int                 count = 1;
	int                 func_ret, ret_val = KAT_SUCCESS; //KAT_SUCCESS 0
void main (){
    init_buffer(key, sizeof(key));
	init_buffer(nonce, sizeof(nonce));
	init_buffer(msg, sizeof(msg));
	init_buffer(ad, sizeof(ad));
}

void init_buffer(unsigned char *buffer, unsigned long long numbytes)
{
	for (unsigned long long i = 0; i < numbytes; i++)
		{
        buffer[i] = (unsigned char)i;
		cout<<"Buffer ";
		cout<<i;
		cout<<":";
        cout<<to_string(buffer[i])<<endl;
        cout<<"key ";
		cout<<i;
		cout<<":";
        cout<<to_string(key[i])<<endl;

        }
}
