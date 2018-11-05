/*
Name:- Ishwarkar Rohan Shankar
Roll No:- 16CS30012
Compilers Assignment 5
*/

#ifndef TRANSLATOR_H
#define TRANSLATOR_H
 
#include <cstdio>
#include <iostream>
#include <cstdlib>
#include <cstring>
#include <string>
#include <stack>
#define NSYM 100

extern FILE* yyin;
extern FILE* yyout;
extern int yylex();
extern int yyparse();
extern char* yytext;

using namespace std;

typedef enum{        
	PLUS=1,
	SUB,	
	DIV,
	MULT,
	UMINUS,
	COPY,
	PLUSPLUS,
	MINUSMINUS,
	NEG,
	NT,
	REM,
	LEFTSHIFT,
	RIGHTSHIFT,
	LESSTHAN,
	GREATERTHAN,
	LESSTHANEQUAL,
	GREATERTHANEQUAL,
	ISEQUAL,
	NOTEQUAL,
	XOR,
	BITOR,
	BITAND,
	QUESTIONMARK,
	COLN,
	ASSIGNMENT,
	LOGICALOR,
	LOGICALAND,
	_GOTO,
	FUNC,
	PARAM,
	_RETURN,
	ARRAY,
}OpcodeType;

struct SymTab;
struct SymNode;
struct list;

typedef struct Value{			// flag=1 => int
	int ival;					// flag=2 => double
	double dval;				// flag=3 => char					
	string str;					// flag=4 => function	
	void* ptr;			   		//flag=0 =>void			
	int flag;				  	//flag=5 => void*
}Value; 					    					

typedef struct SymNode{ 			// structure to store one entry of a symbol table.
	string name;					// name stores name of the variable 
	string type;					// type stores type of the variable 
	Value value; 					// value stores value of the variable 
	int size,offset;		
	struct SymTab *next;			// next stores pointer to the symbol table in case of functions 
	struct list* truelist,*falselist,*arglist; 		// arglist stores the list of array indices in array type with pointer level (no os zeroes)at the beginning of the list
}SymNode;

typedef struct SymTab{ 				// Structure of 1 symbol table 
	int count;						// count stores the number of entries so far in the table 
	SymNode symbol[NSYM];
}SymTab;

typedef struct list{
	int index;
	struct list* next;
}List;

typedef struct quad{
	OpcodeType op;
	string arg1,arg2,result;
}quad;

typedef struct IdList{ 			// IdList structure is list of pointer to a single entry in symbol table
	SymNode* id;
	struct IdList* next;
}IdList;

typedef struct ParamList{      // ParamList is list of types and names of parameters to a function
	string type;
	string name;
	struct ParamList* next;
}ParamList;

extern quad qArray[256];       
extern int noTemp;				// noTemp= number of temporaries generated so far
extern int nextinstr; 			// Index of nextinstruction or number of quads generated so far
extern SymTab* currentTab;      
extern SymTab* globalTab;		// globaltable to store the functions and global variables decalred

SymTab* newTable();
SymNode* lookup(SymTab*,string);
SymNode* gentemp(SymTab*);
void update(SymTab*,SymNode*,string);
void printSymTab(SymTab);
void emit(string,OpcodeType,string c="",string s="");
void printquad(quad);
List* makelist(int);
List* merge(List*,List*);
void backpatch(List*,int);
void typecheck(SymNode*,SymNode*);
SymNode* convert(string,SymNode*);
IdList* makelist(SymNode*);
IdList* merge(IdList*,IdList*);
ParamList* makelist(string,string);
ParamList* merge(ParamList*,ParamList*);
void convInt2Bool(SymNode*);
#endif
