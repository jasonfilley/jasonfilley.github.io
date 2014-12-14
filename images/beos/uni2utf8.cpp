// uni2utf8.cpp -- Prints Unicode values (U+0000 - U+FFFF) and corresponding
// UTF-8 values.  Jason Filley; Jan 9, 2000; absolute@relative.net .
//
// Published under the Ignostic License, which is something I just made up.
// Theists believe in a supreme deity; atheists don't believe in a supreme 
// deity; agnostics believe there's no way of knowing if there's a supreme 
// deity; and ignostics just don't care whether or not there's a supreme deity.
// Hence Ignostic License.  Who cares if these 30 lines are licensed?  The
// bitshifting routines are from Roman Czyborra's site at http://czyborra.com/utf/

#include <stdio.h>

int main() 

{

unsigned short int unicodeValue = 0x0000;

	// Loop through Unicode values U+0000 to U+FFFF
	for(unicodeValue; unicodeValue<0xffff; unicodeValue++)

	{
		// These are 7-bit ASCII and aren't translated.
		if (unicodeValue < 0x80)
		{
			printf("U+%04X  0x%x\n", unicodeValue, unicodeValue);
		}
	
		// Two-byte encoding follows pattern 110xxxxx 10xxxxxx
		else if (unicodeValue < 0x800)
		{
			unsigned short int firstUTF8byte = 0xC0 | unicodeValue>>6;
			unsigned short int secondUTF8byte = 0x80 | unicodeValue & 0x3F;
			printf("U+%04X  0x%x%x\n", unicodeValue, firstUTF8byte, secondUTF8byte);
		}
		
		// Three-byte encoding follows pattern 1110xxxx 10xxxxxx 10xxxxxx
		else if (unicodeValue < 0x10000)
		{
			unsigned short int firstUTF8byte = 0xE0 | unicodeValue>>12 ;
			unsigned short int secondUTF8byte = 0x80 | unicodeValue>>6 & 0x3F;
			unsigned short int thirdUTF8byte = 0x80 | unicodeValue & 0x3F;
			printf("U+%04X  0x%x%x%x\n", unicodeValue, firstUTF8byte, secondUTF8byte, thirdUTF8byte);
		}
	}
return(0);
}