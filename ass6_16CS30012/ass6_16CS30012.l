%{/*C Declarations and Definitions*/
#include "ass6_16CS30012_translator.h"
#include "y.tab.h"

%}
/*Regular Expressions*/

AUTO			"auto"
ENUM			"enum"
RESTRICT		"restrict"
UNSIGNED		"unsigned"
BREAK			"break"
EXTERN			"extern"
RETURN			"return"
VOID			"void"
CASE			"case"
FLOAT			"float"
SHORT			"short"
VOLATILE		"volatile"
CHAR			"char"
FOR				"for"
SIGNED			"signed"
WHILE			"while"
CONST			"const"
GOTO			"goto"
SIZEOF			"sizeof"
_BOOL			"_Bool"
CONTINUE		"continue"
IF				"if"
STATIC			"static"
_COMPLEX		"_Complex"
DEFAULT			"default"
INLINE			"inline"
STRUCT			"struct"
_IMAGINARY		"_Imaginary"
DO				"do"
INT				"int"
SWITCH			"switch"
DOUBLE			"double"
LONG			"long"
TYPEDEF			"typedef"
ELSE			"else"
REGISTER		"register"
UNION			"union"


/*Regular Expressions for Identifier*/
ID ([a-zA-Z_]([a-zA-Z_]|[0-9])*)
/*Regular Expressions for white space*/
WS [ \t\n]

/*Regular Expressions for constants*/

/*Integer constants*/
NONZERODIG [1-9]
DIGIT [0-9]
INT_CONST (({NONZERODIG}({DIGIT}*))|[0]+)

/*Fractional Constants*/
DECIMALPT "."
DIGIT_SEQ {DIGIT}+
FRAC_CONST {DIGIT_SEQ}?{DECIMALPT}{DIGIT_SEQ}|{DIGIT_SEQ}{DECIMALPT}

/*Floating Point Constants*/
SIGN [+-]
EXPONENT ([eE]{SIGN}?{DIGIT_SEQ})
FLOAT_CONST ({FRAC_CONST}{EXPONENT}?|{DIGIT_SEQ}{EXPONENT})

/*Enumeration Constants*/
ENUMERATION_CONST	{ID}

/*Character Constants*/
/*a '\' being common in all escape sequences is taken out*/
ESCAPE_SEQ ([\\][\'\"\?\\abfnrtv])
C_CHAR [^\'\\\n]|{ESCAPE_SEQ}
C_CHAR_SEQ {C_CHAR}+
C_CHAR_CONST (\'{C_CHAR_SEQ}\')

/*Constants*/
CONSTANT {INT_CONST}|{FLOAT_CONST}|{ENUMERATION_CONST}|{C_CHAR_CONST}


/*Regular Expressions for String Literals*/
S_CHAR [^\"\\\n]|{ESCAPE_SEQ}
S_CHAR_SEQ {S_CHAR}+
STRING_LITERAL (\"{S_CHAR_SEQ}*\")

/*Regular Expressions for Comments*/
SINGLE_LINE_COMMENT [/][/].*
MULTI_COMMENT_START [/][\*]+
MULTI_COMMENT_END	[\*]+[/]
MULTI_LINE_COMMENT ({MULTI_COMMENT_START}(([^\*])|((\*)+[^/\*]))*{MULTI_COMMENT_END})
COMMENT {SINGLE_LINE_COMMENT}|{MULTI_LINE_COMMENT}

/*Actions(FSMs)*/
%%

{AUTO}			{return AUTO_KEYWORD;}
{ENUM}			{return ENUM_KEYWORD;}
{RESTRICT}		{return RESTRICT_KEYWORD;}
{UNSIGNED}		{return UNSIGNED_KEYWORD;}
{BREAK}			{return BREAK_KEYWORD;}
{EXTERN}		{return EXTERN_KEYWORD;}
{RETURN}		{return RETURN_KEYWORD;}
{VOID}			{return VOID_KEYWORD;}
{CASE}			{return CASE_KEYWORD;}
{FLOAT}			{return FLOAT_KEYWORD;}
{SHORT}			{return SHORT_KEYWORD;}
{VOLATILE}		{return VOLATILE_KEYWORD;}
{CHAR}			{return CHAR_KEYWORD;}
{FOR}			{return FOR_KEYWORD;}
{SIGNED}		{return SIGNED_KEYWORD;}
{WHILE}			{return WHILE_KEYWORD;}
{CONST}			{return CONST_KEYWORD;}
{GOTO}			{return GOTO_KEYWORD;}
{SIZEOF}		{return SIZEOF_KEYWORD;}
{_BOOL}			{return BOOL_KEYWORD;}
{CONTINUE}		{return CONTINUE_KEYWORD;}
{IF}			{return IF_KEYWORD;}
{STATIC}		{return STATIC_KEYWORD;}
{_COMPLEX}		{return COMPLEX_KEYWORD;}
{DEFAULT}		{return DEFAULT_KEYWORD;}
{INLINE}		{return INLINE_KEYWORD;}
{STRUCT}		{return STRUCT_KEYWORD;}
{_IMAGINARY}		{return IMAGINARY_KEYWORD;}
{DO}			{return DO_KEYWORD;}
{INT}			{return INT_KEYWORD;}
{SWITCH}		{return SWITCH_KEYWORD;}
{DOUBLE}		{return DOUBLE_KEYWORD;}
{LONG}			{return LONG_KEYWORD;}
{TYPEDEF}		{return TYPEDEF_KEYWORD;}
{ELSE}			{return ELSE_KEYWORD;}
{REGISTER}		{return REGISTER_KEYWORD;}
{UNION}			{return UNION_KEYWORD;}

"..."                   { return ELLIPSIS; }
">>="                   { return RIGHT_ASSIGNMENT; }
"<<="                   { return LEFT_ASSIGNMENT; }
"+="                    { return ADD_ASSIGNMENT; }
"-="                    { return SUB_ASSIGNMENT; }
"*="                    { return MUL_ASSIGNMENT; }
"/="                    { return DIV_ASSIGNMENT; }
"%="                    { return MOD_ASSIGNMENT; }
"&="                    { return AND_ASSIGNMENT; }
"^="                    { return XOR_ASSIGNMENT; }
"|="                    { return OR_ASSIGNMENT; }
">>"                    { return RIGHT_SHIFT; }
"<<"                    { return LEFT_SHIFT; }
"++"                    { return INCREMENT_OP; }
"--"                    { return DECREMENT_OP; }
"->"                    { return POINTER_OP; }
"&&"                    { return AND_OP; }
"||"                    { return OR_OP; }
"<="                    { return LESS_EQ_OP; }
">="                    { return GREATER_EQ_OP; }
"=="                    { return EQ_OP; }
"!="                    { return NOT_EQ_OP; }
";"                     { return ';'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
","                     { return ','; }
":"                     { return ':'; }
"="                     { return '='; }
"("                     { return '('; }
")"                     { return ')'; }
"["                     { return '['; }
"]"                     { return ']'; }
"."                     { return '.'; }
"&"                     { return '&'; }
"!"                     { return '!'; }
"~"                     { return '~'; }
"-"                     { return '-'; }
"+"                     { return '+'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"%"                     { return '%'; }
"<"                     { return '<'; }
">"                     { return '>'; }
"^"                     { return '^'; }
"|"                     { return '|'; }
"?"                     { return '?'; }
"#"                     { return '#'; }


{SINGLE_LINE_COMMENT}			{;}
{MULTI_LINE_COMMENT}			{;}

{ID}                    { yylval.str = new string(yytext); return IDENTIFIER;}
{INT_CONST}             { yylval.intval = atoi(yytext); return INT_CONSTANT;}
{FLOAT_CONST}           { yylval.floatval = atof(yytext); return FLOAT_CONSTANT;}
{C_CHAR_CONST}          { yylval.charval = yytext[1]; return CHAR_CONSTANT;}
{STRING_LITERAL}        { yylval.str = new string(yytext); return STRING_LITERAL;}

{WS}        		{}							/*Ignore white spaces, so do nothing*/

%%

