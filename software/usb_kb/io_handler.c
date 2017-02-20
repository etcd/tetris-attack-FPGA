//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "alt_types.h"
#include "system.h"

#define otg_hpi_address		(volatile int*) 	OTG_HPI_ADDRESS_BASE
#define otg_hpi_data		(volatile int*)	    OTG_HPI_DATA_BASE
#define otg_hpi_r			(volatile char*)	OTG_HPI_R_BASE
#define otg_hpi_cs			(volatile char*)	OTG_HPI_CS_BASE //FOR SOME REASON CS BASE BEHAVES WEIRDLY MIGHT HAVE TO SET MANUALLY
#define otg_hpi_w			(volatile char*)	OTG_HPI_W_BASE


void IO_init(void)
{
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//


	*otg_hpi_address = Address;		// write the address to access to HPI_ADDR

	*otg_hpi_cs = 0;				// write the chip select
	*otg_hpi_w = 0; 				// enable writing

	*otg_hpi_data = Data;			// write the data in 16-bit little endian words to HPI_DATA

	*otg_hpi_w = 1;					// disable writing
	*otg_hpi_cs = 1;				// reset the chip select

}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//


	*otg_hpi_address = Address;		// write the address to access to HPI_ADDR

	*otg_hpi_cs = 0;				// write the chip select
	*otg_hpi_r = 0; 				// enable reading

	temp = *otg_hpi_data; 			// read in from HPI_DATA

	*otg_hpi_r = 1; 				// disable reading
	*otg_hpi_cs = 1;				// reset the chip select

	//printf("Data: %x\n",temp);
	return temp;

}



