static void S_box(uint16_t *state)
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
