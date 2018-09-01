/* 
Name:- Ishwarkar Rohan Shankar
Roll No:- 16CS30012
Assignment 3 Compilers Lab
Autumn Semester 2018
*/

// Header files
#include <stdio.h>

extern char* yytext;

// Main function
int main() {

  int token;
  while (token = yylex()) {

    switch (token) {

    	// Case for escape characters /t,/n ...
    	case ESCAPE_SEQUENCE:
    		printf("<ESCAPE CHARACTER, %d, %s>\n",token, yytext);
  			break;

  		// Case for all the keywords
  		case KEYWORD:
  			printf("<KEYWORD, %d, %s>\n",token, yytext);
  			break;

    	// Case for identifier
		case IDENTIFIER: 
			printf("<IDENTIFIER, %d, %s>\n",token, yytext); 
			break;

		// Case for integer constant
		case INT_CONSTANT: 
			printf("<INTEGER CONSTANT, %d, %s>\n",token, yytext); 
			break;

		// Case for float constant
		case FLOAT_CONSTANT: 
			printf("<FLOAT CONSTANT, %d, %s>\n",token, yytext); 
			break;

		// Case for enumeration constant
		case ENU_CONSTANT: 
			printf("<ENUMERATION CONSTANT, %d, %s>\n",token, yytext); 
			break;

		// Case for character constant
		case CHAR_CONSTANT: 
			printf("<CHARACTER CONSTANT, %d, %s>\n",token, yytext); 
			break;

		// Case for string
		case STRING_CON: 
			printf("<STRING LITERAL, %d, %s>\n",token, yytext); 
			break;

		// Case for all punctuators
		case PUNCTUATOR: 
			printf("<PUNCTUATOR, %d, %s>\n",token, yytext); 
			break;

		// Case for comment
		case COMMENT: 
			printf("<COMMENT, %d>\n",token); 
			break;

		// Here default case is set to punctuators. So all others will be treated as punctuators
		default: 
			printf("<PUNCTUATOR, %d, %s>\n",token, yytext); 
			break;
    }
  }
}