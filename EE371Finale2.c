/*
 * main.c
 *
 *  Created on: Feb 28, 2015
 *      Author: Thomas Jeffrey Appleseth
 */

//nios2-download -g <project name>.elf
/* Behold: Tom's glorious macro army */

//data IO module addresses
#define INBUS (volatile unsigned char *) 0x00021040
#define OUTBUS (unsigned char *) 0x00021050

//command IO module addresses
#define INSTAT (volatile unsigned char*) 0x00021030
#define OUTCOM (unsigned char*) 0x00021020

//input wires
#define CHAR_RX (*INSTAT)&0x1
#define CHAR_TX ((*INSTAT)>>1)&0x1

//output wires
#define PARALLEL_OUT(X) *OUTBUS = (((*OUTBUS)&0x0)|X);
#define LOAD(X) *OUTCOM = (((*OUTCOM)&0x2)|(int)X); //preserve 2nd bit, replace 1st
#define TX_EN(X) *OUTCOM = ((((*OUTCOM)&0x1)|(int)X<<1)); //preserve 1st bit, replace 2nd
#define LOAD_EN() *OUTCOM = 0x3;

#define delay(X) for(i=0;i<X;i++);

#include <stdio.h>
#include "sys/alt_stdio.h"

//int main (int, char **, char **);
int main(int argc, char** argv, char** envp){

	//recieve buffer
	//unsigned char RXBUFF[8];
	//unsigned char TXBUFF[8];
	unsigned char TXBUFF = 0;
	unsigned char RXBUFF = 0;

	/*
	 *   - Use ALT versions of stdio routines:
	 *
	 *           Function                  Description
	 *        ===============  =====================================
	 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
	 *        alt_putstr       Smaller overhead than puts with direct drivers
	 *                         Note this function doesn't add a newline.
	 *        alt_putchar      Smaller overhead than putchar with direct drivers
	 *        alt_getchar      Smaller overhead than getchar with direct drivers
	 *
	 */
	*OUTBUS = 0;
	*INBUS = 0;
	*OUTCOM = 0;
	*INSTAT = 0;
	//TX_EN(0);
	//LOAD(0);
	int i = 0;

		TXBUFF = 0xCE;
		*OUTBUS = TXBUFF;
		alt_printf("Sending: %x\n",TXBUFF);
		*OUTCOM = 0x0;
		delay(100);
		*OUTCOM = 0x3;
		*OUTCOM = 0x2;
		while(!CHAR_TX);
		*OUTCOM = 0x0; //tell hardware that transmission is complete
		//wait until response character is received
		while(!CHAR_RX);
		//delay(1500);
		//it is at this point that we shall load the input bus into the 8-bit input buffer (let it be so)
		RXBUFF = *INBUS;
		alt_printf("Received: %x\n",*INBUS);
		*OUTBUS = 0xFF;
		TXBUFF = 0;
		RXBUFF = 0;
		delay(500);

		return 0;
}
