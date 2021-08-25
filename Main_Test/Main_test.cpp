#include <iostream>
#include <stdio.h>
#include <string.h>
#include <sstream>
using namespace std;
uint16_t RC0[31], RC1[31];
int R=10;
int D=6;
unsigned char       key[32];
unsigned char		nonce[16];
unsigned char       msg[15];//MAX_MESSAGE_LENGTH  15
unsigned char		ad[0];// MAX_ASSOCIATED_DATA_LENGTH  0
uint16_t xk[16] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F};
uint16_t xb[16] = {0x0100, 0x0302, 0x0504,0x0706,0x0908,0x0B0A,0x0D0C,0x0F0E,0x0100, 0x0302, 0x0504,0x0706,0x0908,0x0B0A,0x0D0C,0x800E};
int i, j;
void init_buffer(unsigned char *buffer, unsigned long long numbytes)
{
	for (unsigned long long i = 0; i < numbytes; i++)
		{
        buffer[i] = (unsigned char)i;
		cout<<"Buffer ";
		cout<<i;
		cout<<":";
        cout<<to_string(buffer[i])<<endl;
        cout<<"Data ";
		cout<<i;
		cout<<":";
        cout<<to_string(key[i])<<endl;

        }
}
int init_Cryp(const unsigned char *npub, int mlen){
    uint8_t tmp[32];

    memcpy(tmp, npub, 16);//nonce 257 tmp 1 nonce 1 tmp 1
    cout<<"\n";
    cout<<"tmp: ";
    //cout<<to_string(tmp) <<endl;
    if (mlen > 15) {
        cout<<"tiempo: "<<endl;
		return -2;
	}
    //cout<<"tiempo: ";
    //return -2;
    //cout<<"tmp: "<<endl;
    cout<<"\n";
    cout<<"Mlen: ";
    cout<<mlen <<endl;
    //cout<<i;
	//cout<<":";
    //cout<<tmp<<endl;
    if (mlen > 0) {
        cout<<"key: ";
        for (int i=0; i<=31; i++){
            if(i<31){
                cout<<to_string(key[i]);
            }
            else {
                cout<<to_string(key[i])<<endl;
            }
        }
		memcpy(tmp + 16,key, mlen);
		cout<<"tmp_1: ";
		for (int i=0; i<=31; i++){
            if(i<31){
                cout<<to_string(tmp[i]);
            }
            else {
                cout<<tmp[i]<<endl;
            }
        }
        tmp[16 + mlen] = 0x80;
        cout<<"tmp_2: ";
        //cout << hex<<tmp<<endl;
		for (int i=0; i<=31; i++){
            if(i<31){
                cout<<hex<<(tmp[i]);
            }
            else {
                cout<<hex<<tmp[i]<<endl;
            }
        }
        memset(tmp + 16 + mlen + 1, 0x00, 15 - mlen);
        cout<<"tmp_3: ";
		for (int i=0; i<=31; i++){
            if(i<31){
                cout<<hex<<(tmp[i]);
                cout<<",";
            }
            else {
                cout<<hex<<(tmp[i])<<endl;
            }
        }
	}
}

void make_rounds()
{
    uint16_t x0, x1;
	int n;

	x0 = x1 = D + (R << 4) + 0xFE00;
	cout<<"llegó"<<endl;
    cout<<x0<<endl;
	for (n = 0; n < R; n ++) {
		int i;

		for (i = 0; i < 16; i ++) {
           // x0=(0x2D & -(x0 >> 15));
			x0 = (x0 << 1) ^ (0x2D & -(x0 >> 15));
            cout<<n;
            cout<<",";
			cout<<i<<endl;
			cout<<"x0: ";
			cout<<hex<<x0<<endl;
			x1 = (x1 << 1) ^ (0x53 & -(x1 >> 15));
			cout<<"x1: ";
			cout<<x1<<endl;
		}
		RC0[n] = x0;
		cout<<"RC0: ";
        cout<<RC0[n]<<endl;
		RC1[n] = x1;
		cout<<"RC1: ";
        cout<<RC1[n]<<endl;
	}
}
static void
S_box(uint16_t *state)
{
	int i;

	for (i = 0; i < 16; i += 8) {
		uint16_t a, b, c, d;

		/* sigma_0 */
		a = state[i + 0];
		b = state[i + 1];
		c = state[i + 2];
		d = state[i + 3];
		a ^= b & c;
		b ^= a | d;
		d ^= b | c;
		c ^= b & d;
		b ^= a | c;
		a ^= b | d;
		state[i + 0] = b;
		state[i + 1] = c;
		state[i + 2] = d;
		state[i + 3] = a;

		/* sigma_1 */
		a = state[i + 4];
		b = state[i + 5];
		c = state[i + 6];
		d = state[i + 7];
		a ^= b & c;
		b ^= a | d;
		d ^= b | c;
		c ^= b & d;
		b ^= a | c;
		a ^= b | d;
		state[i + 4] = d;
		state[i + 5] = b;
		state[i + 6] = a;
		state[i + 7] = c;
	}
}
static void
S_box_inv(uint16_t *state)
{
	int i;

	for (i = 0; i < 16; i += 8) {
		uint16_t a, b, c, d;

		/* inv_sigma_0 */
		b = state[i + 0];
		c = state[i + 1];
		d = state[i + 2];
		a = state[i + 3];
		a ^= b | d;
		b ^= a | c;
		c ^= b & d;
		d ^= b | c;
		b ^= a | d;
		a ^= b & c;
		state[i + 0] = a;
		state[i + 1] = b;
		state[i + 2] = c;
		state[i + 3] = d;

		/* inv_sigma_1 */
		d = state[i + 4];
		b = state[i + 5];
		a = state[i + 6];
		c = state[i + 7];
		a ^= b | d;
		b ^= a | c;
		c ^= b & d;
		d ^= b | c;
		b ^= a | d;
		a ^= b & c;
		state[i + 4] = a;
		state[i + 5] = b;
		state[i + 6] = c;
		state[i + 7] = d;
	}
}
static void
XOR_key(const uint16_t *key, uint16_t *state)
{
	int i;

	for (i = 0; i < 16; i ++) {
        /*cout<<"State[";
		cout<<i;
		cout<<"]";
		cout<<hex<<state[i]<<endl;
        cout<<"KEY[";
		cout<<i;
		cout<<"]";
		cout<<hex<<key[i]<<endl;*/
		state[i] ^= key[i];
		/*cout<<"State[";
		cout<<i;
		cout<<"_B]";
		cout<<hex<<state[i]<<endl;
		cout<<"..."<<endl;*/
	}
}
SR_slice(uint16_t *state)
{
	int i;

	for (i = 0; i < 4; i ++) {
		state[ 4 + i] = ((state[ 4 + i] & 0x7777) << 1)
			| ((state[ 4 + i] & 0x8888) >> 3);

		state[ 8 + i] = ((state[ 8 + i] & 0x3333) << 2)
			| ((state[ 8 + i] & 0xcccc) >> 2);
        cout<<"Xb[";
		cout<<(8+i);
		cout<<"]";
		cout<<hex<<xb[8+i]<<endl;
		state[12 + i] = ((state[12 + i] & 0x1111) << 3)
			| ((state[12 + i] & 0xeeee) >> 1);
        cout<<"Xb[";
		cout<<(12+i);
		cout<<"]";
		cout<<hex<<xb[12+i]<<endl;
	}
}
static void
SR_slice_inv(uint16_t *state)
{
	int i;

	for (i = 0; i < 4; i ++) {
        cout<<"INv"<<endl;
		state[ 4 + i] = ((state[ 4 + i] & 0x1111) << 3)
			| ((state[ 4 + i] & 0xeeee) >> 1);
        cout<<"Xb[";
		cout<<(4+i);
		cout<<"]";
		cout<<hex<<xb[4+i]<<endl;
		state[ 8 + i] = ((state[ 8 + i] & 0x3333) << 2)
			| ((state[ 8 + i] & 0xcccc) >> 2);
		cout<<"Xb[";
		cout<<(8+i);
		cout<<"]";
		cout<<hex<<xb[8+i]<<endl;
		state[12 + i] = ((state[12 + i] & 0x7777) << 1)
			| ((state[12 + i] & 0x8888) >> 3);
        cout<<"Xb[";
		cout<<(12+i);
		cout<<"]";
		cout<<hex<<xb[12+i]<<endl;
	}
}
static void
XOR_key_rotated(const uint16_t *key, uint16_t *state)
{
	int i;

	for (i = 0; i < 16; i ++) {
		state[i] ^= (key[i] << 11) | (key[i] >> 5);
	}
}

static void
MDS(uint16_t *state)
{
	uint16_t x0, x1, x2, x3, x4, x5, x6, x7;
	uint16_t x8, x9, xa, xb, xc, xd, xe, xf;

	x0 = state[0x0];
	x1 = state[0x1];
	x2 = state[0x2];
	x3 = state[0x3];
	x4 = state[0x4];
	x5 = state[0x5];
	x6 = state[0x6];
	x7 = state[0x7];
	x8 = state[0x8];
	x9 = state[0x9];
	xa = state[0xa];
	xb = state[0xb];
	xc = state[0xc];
	xd = state[0xd];
	xe = state[0xe];
	xf = state[0xf];

#define MUL(t0, t1, t2, t3)   do { \
		uint16_t mul_tmp = (t0); \
		(t0) = (t1); \
		(t1) = (t2); \
		(t2) = (t3); \
		(t3) = mul_tmp ^ (t0); \
	} while (0)

	x8 ^= xc; x9 ^= xd; xa ^= xe; xb ^= xf; /* C ^= D */
	x0 ^= x4; x1 ^= x5; x2 ^= x6; x3 ^= x7; /* A ^= B */
	MUL(x4, x5, x6, x7);                    /* B = MUL(B) */
	MUL(xc, xd, xe, xf);                  /* D = MUL(D) */
	x4 ^= x8; x5 ^= x9; x6 ^= xa; x7 ^= xb; /* B ^= C */
	xc ^= x0; xd ^= x1; xe ^= x2; xf ^= x3; /* D ^= A */
	MUL(x0, x1, x2, x3);                    /* A = MUL(A) */
	MUL(x0, x1, x2, x3);                    /* A = MUL(A) */
	MUL(x8, x9, xa, xb);                    /* C = MUL(C) */
	MUL(x8, x9, xa, xb);                    /* C = MUL(C) */
/*	cout<<"x0:";
	cout<<hex<<x0<<endl;
	cout<<"x1:";
	cout<<hex<<x1<<endl;
	cout<<"x2:";
	cout<<hex<<x2<<endl;
	cout<<"x3:";
	cout<<hex<<x3<<endl;
	cout<<"x4:";
	cout<<hex<<x4<<endl;
	cout<<"x5:";
	cout<<hex<<x5<<endl;
	cout<<"x6:";
	cout<<hex<<x6<<endl;
	cout<<"x7:";
	cout<<hex<<x7<<endl;
	cout<<"x8:";
	cout<<hex<<x8<<endl;
	cout<<"x9:";
	cout<<hex<<x9<<endl;
	cout<<"xa:";
	cout<<hex<<xa<<endl;
	cout<<"xb:";
	cout<<hex<<xb<<endl;
	cout<<"xc:";
	cout<<hex<<xc<<endl;
	cout<<"xd:";
	cout<<hex<<xd<<endl;
	cout<<"xe:";
	cout<<hex<<xe<<endl;
	cout<<"xf:";
	cout<<hex<<xf<<endl;*/
	x8 ^= xc; x9 ^= xd; xa ^= xe; xb ^= xf; /* C ^= D */
	x0 ^= x4; x1 ^= x5; x2 ^= x6; x3 ^= x7; /* A ^= B */
	x4 ^= x8; x5 ^= x9; x6 ^= xa; x7 ^= xb; /* B ^= C */
	xc ^= x0; xd ^= x1; xe ^= x2; xf ^= x3; /* D ^= A */

#undef MUL

	state[0x0] = x0;
	state[0x1] = x1;
	state[0x2] = x2;
	state[0x3] = x3;
	state[0x4] = x4;
	state[0x5] = x5;
	state[0x6] = x6;
	state[0x7] = x7;
	state[0x8] = x8;
	state[0x9] = x9;
	state[0xa] = xa;
	state[0xb] = xb;
	state[0xc] = xc;
	state[0xd] = xd;
	state[0xe] = xe;
	state[0xf] = xf;
}

static void
SR_sheet(uint16_t *state)
{
	int i;

	for (i = 0; i < 4; i ++) {
		state[ 4 + i] = ((state[ 4 + i] <<  4) | (state[ 4 + i] >> 12));
		state[ 8 + i] = ((state[ 8 + i] <<  8) | (state[ 8 + i] >>  8));
		state[12 + i] = ((state[12 + i] << 12) | (state[12 + i] >>  4));
	}
}

/*
 * Apply the inverse of the SR_sheet permutation.
 */
static void
SR_sheet_inv(uint16_t *state)
{
	int i;

	for (i = 0; i < 4; i ++) {
		state[ 4 + i] = ((state[ 4 + i] << 12) | (state[ 4 + i] >>  4));
		state[ 8 + i] = ((state[ 8 + i] <<  8) | (state[ 8 + i] >>  8));
		state[12 + i] = ((state[12 + i] <<  4) | (state[12 + i] >> 12));
	}
}

int main () {
    cout<<"Hola Mundo"<< endl;
        make_rounds();
        XOR_key(xk,xb);

   for (i = 0; i < 10; i ++) {
        S_box(xb);
        cout<<"S_Box:";
        cout<<i<<endl;
        for (j = 0; j < 16; j ++) {
            cout<<"Xb[";
            cout<<j;
            cout<<"]";
            cout<<hex<<xb[j]<<endl;
        }
        MDS(xb);
        cout<<"MDS:";
        cout<<i<<endl;
        for (j = 0; j < 16; j ++) {
            cout<<"Xb[";
            cout<<j;
            cout<<"]";
            cout<<hex<<xb[j]<<endl;
        }
        S_box(xb);
        cout<<"S_Box_2:";
        cout<<i<<endl;
        for (j = 0; j < 16; j ++) {
            cout<<"Xb[";
            cout<<j;
            cout<<"]";
            cout<<hex<<xb[j]<<endl;
        }
        if ((i & 1) == 0) {
			/*
			 * Round r = 1 mod 4.
			 */
			cout<<"Round1:";
            cout<<i<<endl;
            cout<<"]";
			SR_slice(xb);
			cout<<"SR_Slice:"<<endl;
            for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			MDS(xb);
			cout<<"MDS_SRS:"<<endl;
            for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			SR_slice_inv(xb);
			cout<<"SR_Slice_INV:"<<endl;
            for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			xb[0] ^= RC0[i];
			xb[8] ^= RC1[i];
			cout<<"Make_Rounds:"<<endl;
			for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
        }
			XOR_key_rotated(xk, xb);
		} else {
			/*
			 * Round r = 3 mod 4.
			 */
            cout<<"Round2:";
            cout<<i<<endl;
			SR_sheet(xb);
			cout<<"SR_Sheet:"<<endl;
            for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			MDS(xb);
			cout<<"MDS_SRSH:"<<endl;
            for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			SR_sheet_inv(xb);
			cout<<"SR_Sheet_INV:"<<endl;
            for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			xb[0] ^= RC0[i];
			xb[8] ^= RC1[i];
			cout<<"Make_Rounds:"<<endl;
			for (j = 0; j < 16; j ++) {
                cout<<"Xb[";
                cout<<j;
                cout<<"]";
                cout<<hex<<xb[j]<<endl;
            }
			XOR_key(xk, xb);

        }
   for (j = 0; j < 16; j ++) {
            cout<<"Xb[";
            cout<<j;
            cout<<"]";
            cout<<hex<<xb[j]<<endl;
        }
}
}
/*



    int i;
    for (i = 0; i < 16; i ++) {
        cout<<"Xb[";
		cout<<i;
		cout<<"]";
		cout<<hex<<xb[i]<<endl;
    }
    cout<<"After"<<endl;
    cout<<"RC0: ";
    cout<<RC0[0]<<endl;
    xb[0] ^= RC0[0];
    xb[8] ^= RC1[0];
    for (i = 0; i < 16; i ++) {
        cout<<"Xb[";
		cout<<i;
		cout<<"]";
		cout<<hex<<xb[i]<<endl;
    }
    //}
}*/
/*
init_buffer(key, sizeof(key));
init_buffer(nonce, sizeof(nonce));

for (int mlen=0; mlen<=15;mlen++){
    int value= init_Cryp(key, mlen);
    cout<<"Value: ";
    cout<<hex<<value<<endl;

}
for (int i = 0; i < 16; i ++) {
		xk[i] = key[i << 1] + ((uint16_t)key[(i << 1) + 1] << 8);
		cout<<"xk[";
		cout<<i;
		cout<<"]: ";
		cout<<hex<<xk[i]<<endl;
		//xb[i] = buf[i << 1] + ((uint16_t)buf[(i << 1) + 1] << 8);
	}



make_rounds();
xk[1]=0xB2;
cout<<"xk_1:";
cout<<hex<<xk[1]<< endl;
xb[1]=0x79;
cout<<"xb_1:";
cout<<hex<<(xb[1])<< endl;
xk[1]^=xb[1];
cout<<"xk_1:";
cout<<hex<<xk[1]<< endl;



cout<<"Key:"<< endl;
init_buffer(key, sizeof(key));
cout<<"Nonce:"<< endl;
init_buffer(nonce, sizeof(nonce));
cout <<"Nonce:";
cout<<(to_string(nonce[15]))<< endl;
cout<<"Fin"<< endl;
cout<<"Msg:"<< endl;
init_buffer(msg, sizeof(msg));
cout<<"ad:"<< endl;
init_buffer(ad, sizeof(ad));

for (int mlen=0; mlen<=15;mlen++){
    int value= init_Cryp(key, mlen);
    cout<<"Value: ";
    cout<<value<<endl;

}
cout<<"Segunda Linea"<<endl;

}
*/
