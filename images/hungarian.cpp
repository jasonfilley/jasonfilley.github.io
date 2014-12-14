/*
c is like "ts" (like in "itsy-bitsy") or like German "z" (like in "Zahn"), it never becomes "k" or "s". 
cs is like in "cheep", "chat", etc. 
dz is "d"+"z" 
dzs is "d"+"z"+"s", like in "jungle", "jive", etc. 
gy is "g"+"y", soft "g", like in "during", "due", etc. 
j is like "y" in English ("youth", "yogurt", etc.) 
ly is "l"+"y", soft "l", almost equal to "j" ("youth", "yogurt", etc.) 
ny is "n"+"y", soft "n", like in "new", etc. 
s is like "sh" in English ("short", "shy", etc.) 
sz is like "s" in English ("spam", "spy", etc.) 
ty is "t"+"y", soft "t", like in English "Tudor", "tube", etc. 
zs is "z"+"s", like in French "Jules", "Jacques", etc. 

Double consonants are really pronounced long; if you see "tt", you should say "t+t". For long consonants, only the first character is doubled in writing: "sz"+"sz" = "ssz", "gy"+"gy" = "ggy". 

Finally, the accent is always on the first syllable when speaking. 
*/


/*

Hungarian metaphone



Unicode characters used in language:

0041    LATIN CAPITAL LETTER A
0042    LATIN CAPITAL LETTER B
0043    LATIN CAPITAL LETTER C
0044    LATIN CAPITAL LETTER D
0045    LATIN CAPITAL LETTER E
0046    LATIN CAPITAL LETTER F
0047    LATIN CAPITAL LETTER G
0048    LATIN CAPITAL LETTER H
0049    LATIN CAPITAL LETTER I
004A    LATIN CAPITAL LETTER J
004B    LATIN CAPITAL LETTER K
004C    LATIN CAPITAL LETTER L
004D    LATIN CAPITAL LETTER M
004E    LATIN CAPITAL LETTER N
004F    LATIN CAPITAL LETTER O
0050    LATIN CAPITAL LETTER P
0051    LATIN CAPITAL LETTER Q
0052    LATIN CAPITAL LETTER R
0053    LATIN CAPITAL LETTER S
0054    LATIN CAPITAL LETTER T
0055    LATIN CAPITAL LETTER U
0056    LATIN CAPITAL LETTER V
0057    LATIN CAPITAL LETTER W
0058    LATIN CAPITAL LETTER X
0059    LATIN CAPITAL LETTER Y
005A    LATIN CAPITAL LETTER Z
0061    LATIN SMALL LETTER A
0062    LATIN SMALL LETTER B
0063    LATIN SMALL LETTER C
0064    LATIN SMALL LETTER D
0065    LATIN SMALL LETTER E
0066    LATIN SMALL LETTER F
0067    LATIN SMALL LETTER G
0068    LATIN SMALL LETTER H
0069    LATIN SMALL LETTER I
006A    LATIN SMALL LETTER J
006B    LATIN SMALL LETTER K
006C    LATIN SMALL LETTER L
006D    LATIN SMALL LETTER M
006E    LATIN SMALL LETTER N
006F    LATIN SMALL LETTER O
0070    LATIN SMALL LETTER P
0071    LATIN SMALL LETTER Q
0072    LATIN SMALL LETTER R
0073    LATIN SMALL LETTER S
0074    LATIN SMALL LETTER T
0075    LATIN SMALL LETTER U
0076    LATIN SMALL LETTER V
0077    LATIN SMALL LETTER W
0078    LATIN SMALL LETTER X
0079    LATIN SMALL LETTER Y
007A    LATIN SMALL LETTER Z
00C0    LATIN CAPITAL LETTER A WITH GRAVE
00C1    LATIN CAPITAL LETTER A WITH ACUTE
00C9    LATIN CAPITAL LETTER E WITH ACUTE
00CD    LATIN CAPITAL LETTER I WITH ACUTE
00D3    LATIN CAPITAL LETTER O WITH ACUTE
00D6    LATIN CAPITAL LETTER O WITH DIAERESIS
00DA    LATIN CAPITAL LETTER U WITH ACUTE
00DC    LATIN CAPITAL LETTER U WITH DIAERESIS
00E0    LATIN SMALL LETTER A WITH GRAVE
00E1    LATIN SMALL LETTER A WITH ACUTE
00E9    LATIN SMALL LETTER E WITH ACUTE
00ED    LATIN SMALL LETTER I WITH ACUTE
00F3    LATIN SMALL LETTER O WITH ACUTE
00F6    LATIN SMALL LETTER O WITH DIAERESIS
00FA    LATIN SMALL LETTER U WITH ACUTE
00FC    LATIN SMALL LETTER U WITH DIAERESIS
0150    LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
0151    LATIN SMALL LETTER O WITH DOUBLE ACUTE
0170    LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
0171    LATIN SMALL LETTER U WITH DOUBLE ACUTE


Pronunciation guide(s):
Berlitz East European Phrase Book, 1995, pg. 95, ISBN 2-8315-1519-X


*/


/* 	Function IsVowel defines vowels for this language.
	IsVowel will return true if the Ucase'd character is one of:
	0041, 0045, 0049, 004A, 004F, 0055, 0057, 0059, 00C0, 00C1, 00C9, 00CD, 00D3, 00DA, 00DC, 0170.

	00D6 AND 0150 are vowels with a faint R sound, so are listed as consanants.
*/

{

/* 	Any vowel sound or vowel combination gets marked as "-"
	So "boy" becomes "P-"
	"mother" becomes "M-0-R"  (that's zero, as in theta)
	"beautiful" becomes "P-T-F-L"
	"pitiful" "P-T-F-L" sounds closer to "beautiful" than does
	"pitfall" "P-TF-L", or
	"batfly" "P-TFL-" which in standard DM has the same code "PTFL" as "beautiful"

	Different languages' pronunciation on vowels may differ.
	Compare the "LE" in English "waffle" (-F-L) to "witless" (-TL-S)	*/

if (IsVowel(GetAt(current)) == true) 
{
	if (IsVowel(GetAt(current -1)) == false)
	{
		MetaphAdd("-");
	}
}
else
{

/* Consanants	*/

	switch(GetAt(current))

		case L"x0042":	//    LATIN CAPITAL LETTER B
			if GetAt(current -1) != L"x0042"
			{
				MetaphAdd("P");
				current +=1;
			}
			break;

		case L"x0043":	//    LATIN CAPITAL LETTER C
			if GetAt(current +1) == L("x0053")  // "CS"
				{
					MetaphAdd("X");
					current +=2;
					break;
				}
			else
				{
					if GetAt(current -1) != L"x0043" // "CC"
					{
						MetaphAdd("TS");
					}
					current +=1;
					break;
				}

		case L"x0044":	//    LATIN CAPITAL LETTER D

			// dzs is "d"+"z"+"s", like in "jungle", "jive", etc. 
			if StringAt(current + 3) == L"x0044005A0053"
			{
				MetaphAdd("J");
				current +=3;
				break;
			}
			else
			{
				if (GetAt(current - 1)) != L"x0044"
				{
					MetaphAdd("T");
				}
			}
			current +=1;

		case L"x0046":	//    LATIN CAPITAL LETTER F
			MetphAdd("F");
			current +=1;
			break;

		case L"x0047":	//    LATIN CAPITAL LETTER G
			if GetAt(current +1) == L("0059") // "GY"
				MetaphAdd("T");
			else
				MetaphAdd("K");
			current +=1;
			break;

		case L"x0048":	//    LATIN CAPITAL LETTER H
			MetaphAdd("H");
			current +=1;
			break;

		case L"x004B":	//    LATIN CAPITAL LETTER K
			MetaphAdd("K");
			current +=1;
			break;

		case L"x004C":	//    LATIN CAPITAL LETTER L
			if GetAt(current +1) != L"x0059"
				MetaphAdd("L");
			current +=1;
			break;

		case L"x004D":	//    LATIN CAPITAL LETTER M
			MetaphAdd("M");
			current +=1;
			break;

		case L"x004E":	//   LATIN CAPITAL LETTER N
			MetaphAdd("N");
			current +=1;
			break;

		case L"x0050":	//    LATIN CAPITAL LETTER P
			MetaphAdd("P");
			current +=1;
			break;

		case L"x0051":	//    LATIN CAPITAL LETTER Q -- should only be in loan words
			MetaphAdd("K");
			current +=1;
			break;

		case L"x0052":	//    LATIN CAPITAL LETTER R
			MetaphAdd("R");
			current +=1;
			break;

		case L"x0053":	//    LATIN CAPITAL LETTER S
			if GetAt(current +1) != L"x005A" // "SZ"
			{
				MetaphAdd("X");
			}
			
			current +=1;
			break;

		case L"x0054":	//    LATIN CAPITAL LETTER T
			if (GetAt(current -1)) != L"x0054" // "TT"
			{
				MetaphAdd("T");
			}
			current +=1;
			break;

		case L"x0056":	//    LATIN CAPITAL LETTER V
			MetaphAdd("F");
			current +=1;
			break;

		case L"x0058":	//    LATIN CAPITAL LETTER X
			MetaphAdd("KS");
			current +=1;
			break;

		case L"x005A":	//    LATIN CAPITAL LETTER Z
			MetaphAdd("S");

			if GetAt(current +1) == L"x0053"
			{
				current += 2;
			}
			else
			{
				current +=1;
			}
			break;

		case L"x00D6":	//    LATIN CAPITAL LETTER O WITH DIAERESIS -- vowel with a faint "R" sound
			if IsVowel(GetAt(current -1)) == false
			{
				MetaphAdd("-");
			}

			MetaphAdd("R");
			current +=1;
			break;

		case L"x0150":	//    LATIN CAPITAL LETTER O WITH DOUBLE ACUTE  -- vowel with a faint "R" sound
			if IsVowel(GetAt(current -1)) == false
			{
				MetaphAdd("-");
			}

			MetaphAdd("R");
			current +=1;
			break;


		default:  // Unrecognized characters
			current +=1;
}

















