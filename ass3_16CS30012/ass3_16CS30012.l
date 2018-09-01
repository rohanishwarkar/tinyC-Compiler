/* 
Name:- Ishwarkar Rohan Shankar
Roll No:- 16CS30012
Assignment 3 Compilers Lab
Autumn Semester 2018
*/
%{
	#define COMMENT 1
	#define ESCAPE_SEQUENCE 2
	#define PUNCTUATOR 3
	#define KEYWORD 4
	#define STRING_CON 5
	#define IDENTIFIER 6
	#define INT_CONSTANT 7
	#define FLOAT_CONSTANT 8
	#define ENU_CONSTANT 9
	#define CHAR_CONSTANT 10
%}

/************** Regular Expression Definitions *******************/

KEYWORD             		"auto"|"enum"|"restrict"|"unsigned"|"break"|"extern"|"return"|"void"|"case"|"float"|"short"|"volatile"|"char"|"for"|"signed"|"while"|"const"|"goto"|"sizeof"|"_Bool"|"continue"|"if"|"static"|"_Complex"|"default"|"inline"|"struct"|"_Imaginary"|"do"|"int"|"switch"|"double"|"long"|"typedef"|"else"|"register"|"union"
ALPHABET 			 		[a-zA-Z_]
DIGIT						[0-9]
NON_ZERO_DIGIT				[1-9]
IDENTIFIER 					{ALPHABET}({ALPHABET}|{DIGIT})*
INTEGER_CONSTANT 			{NON_ZERO_DIGIT}{DIGIT}*|0
ENUMERATION_CONSTANT 		{IDENTIFIER}
ESCAPE_SEQUENCE				\\['"?\\abfnrtv]
FRACTIONAL_PART 			(({DIGIT}+)?\.{DIGIT}+)|(({DIGIT}+)\.)
EXPONENT_PART				([Ee][+-]?{DIGIT}+)
FLOATING_CONSTANT 			({FRACTIONAL_PART}{EXPONENT_PART}?)|({DIGIT}+{EXPONENT_PART})
c_char 						[^'\\\n]|{ESCAPE_SEQUENCE}
character_constant 			'({c_char})+'
s_char 						[^"\\\n]|{ESCAPE_SEQUENCE}
string_constant 			\"({s_char}+)\"
backother  					[ \t\v\n\f]
SIGNS						[+-]
PUNCTUATOR					"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
%%

"/*"						{ comment(); return COMMENT;}
"//".*  	   				{ return COMMENT;}
{ESCAPE_SEQUENCE} 			{ return ESCAPE_SEQUENCE;}
{PUNCTUATOR}				{ return PUNCTUATOR;}
{KEYWORD}					{ return KEYWORD;}
{string_constant} 			{ return STRING_CON; }
{IDENTIFIER}				{ return IDENTIFIER; }
{INTEGER_CONSTANT} 			{ return INT_CONSTANT; }
{FLOATING_CONSTANT} 		{ return FLOAT_CONSTANT; }
{ENUMERATION_CONSTANT} 		{ return ENU_CONSTANT; }
{character_constant} 		{ return CHAR_CONSTANT; }
{backother}					{ /* whitespace separates tokens */ }
%%

int column = 0,row=0,temp;
void comment(void) {
	char c, prev = 0;
	while ((c = input()) != 0) {     /* (EOF maps to 0) */
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
	error("Unproper commenting");
}