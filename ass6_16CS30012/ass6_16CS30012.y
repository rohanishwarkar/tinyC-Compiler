%{ /* C Declarations and Definitions */
#include <string>
#include <iostream>
#include <fstream>
using namespace std;
extern int yylex();
void yyerror(string s);
//extern int yydebug;
extern int yyparse();


#include "ass6_16CS30012_translator.h"
//#include "myl.h"

Quad_Array Q_arr;
symboltable GT;
symboltable *sym = &GT;
symboltable *curr_sym = &GT;
type_inf *global_type;
int global_width;
vector<string> string_lits;
int literal_count = 0;
%}


%union {
  int intval;
  float floatval;
  char charval;
  string *str;
  exp_attr *expr_attr;
  declaration *decclist;
  init_dec_list *init_dec_list_;
  type_inf *type_;
  func_def *func_def_;
  func_list *func_list_;
}


%token RESTRICT_KEYWORD;
%token UNSIGNED_KEYWORD;
%token AUTO_KEYWORD;
%token ENUM_KEYWORD;
%token BREAK_KEYWORD;
%token EXTERN_KEYWORD;
%token RETURN_KEYWORD;
%token VOID_KEYWORD;
%token CASE_KEYWORD;
%token FLOAT_KEYWORD;
%token SHORT_KEYWORD;
%token VOLATILE_KEYWORD;
%token CHAR_KEYWORD;
%token FOR_KEYWORD;
%token SIGNED_KEYWORD;
%token WHILE_KEYWORD;
%token CONST_KEYWORD;
%token GOTO_KEYWORD;
%token SIZEOF_KEYWORD;
%token BOOL_KEYWORD;
%token CONTINUE_KEYWORD;
%token IF_KEYWORD;
%token STATIC_KEYWORD;
%token COMPLEX_KEYWORD;
%token DEFAULT_KEYWORD;
%token INLINE_KEYWORD;
%token STRUCT_KEYWORD;
%token IMAGINARY_KEYWORD;
%token DO_KEYWORD;
%token INT_KEYWORD;
%token SWITCH_KEYWORD;
%token DOUBLE_KEYWORD;
%token LONG_KEYWORD;
%token TYPEDEF_KEYWORD;
%token ELSE_KEYWORD;
%token REGISTER_KEYWORD;
%token UNION_KEYWORD;

%token <str> IDENTIFIER;

%token  <intval> INT_CONSTANT;
%token  <floatval> FLOAT_CONSTANT;
%token  <charval> CHAR_CONSTANT;

%token <str> STRING_LITERAL;

%token POINTER_OP;
%token INCREMENT_OP;
%token DECREMENT_OP;
%token LEFT_SHIFT;
%token RIGHT_SHIFT;
%token LESS_EQ_OP;
%token GREATER_EQ_OP;
%token EQ_OP;
%token NOT_EQ_OP;
%token AND_OP;
%token OR_OP;
%token ELLIPSIS;
%token MUL_ASSIGNMENT;
%token DIV_ASSIGNMENT;
%token MOD_ASSIGNMENT;
%token ADD_ASSIGNMENT;
%token SUB_ASSIGNMENT;
%token LEFT_ASSIGNMENT;
%token RIGHT_ASSIGNMENT;
%token AND_ASSIGNMENT;
%token XOR_ASSIGNMENT;
%token OR_ASSIGNMENT;

%type<expr_attr> primary_expression
%type<expr_attr> postfix_expression
%type<expr_attr> unary_expression
%type<charval> unary_operator
%type<expr_attr> cast_expression
%type<expr_attr> multiplicative_expression
%type<expr_attr> additive_expression
%type<expr_attr> shift_expression
%type<expr_attr> relational_expression
%type<expr_attr> equality_expression
%type<expr_attr> and_expression
%type<expr_attr> exclusive_or_expression
%type<expr_attr> inclusive_or_expression
%type<expr_attr> logical_and_expression
%type<expr_attr> logical_or_expression
%type<expr_attr> conditional_expression
%type<expr_attr> assignment_expression
%type<expr_attr> assignment_expression_opt
%type<expr_attr> assignment_operator
%type<expr_attr> expression
%type<expr_attr> constant_expression
%type<expr_attr> declaration
%type<type_> declaration_specifiers
%type<init_dec_list_> init_declarator_list
%type<decclist> init_declarator
%type<decclist> direct_declarator
%type<type_> type_specifier
%type<type_> specifier_qualifier_list
%type<decclist> declarator
%type<expr_attr> initializer
%type<decclist> initializer_list
%type<type_> type_name
%type<type_>pointer
%type<func_list_> parameter_list
%type<func_list_> parameter_type_list
%type<func_def_> parameter_declaration
%type<func_list_> parameter_type_list_opt
%type<expr_attr> jump_statement
%type<expr_attr> compound_statement
%type<expr_attr> block_item
%type<expr_attr> block_item_list
%type<expr_attr> selection_statement
%type<expr_attr> iteration_statement
%type<expr_attr> M
%type<expr_attr> N
%type<expr_attr> statement
%type<expr_attr> expression_statement
%type<func_list_> argument_expression_list
%type<expr_attr> expression_opt
%type<decclist> function_definition


%start translation_unit

%%
//Expressions
M
:   
{
    $$ = new exp_attr;
    $$->instr = Q_arr.index;
}
;

N
:   
{
    //$$ = nextlist
    $$ = new exp_attr;
    $$->nextlist = makelist(Q_arr.index);
    Q_arr.emit(GOTO,"","","");
}
;
primary_expression
    : IDENTIFIER	
    {
        $$ = new exp_attr;
        string t = (*($1));     //done
        //cout<<t<<"\n";
        symtab *h = curr_sym->lookup(t);
        $$->loc = t;
        //h -> nested_table = NULL;
        //$$->array = NULL;
    }
    | INT_CONSTANT		        //done
    {
        $$ = new exp_attr;
        type_inf type;
        type.type_name = "int";
        opcodeType op = COPY;
        $$->loc = curr_sym->gentemp(type);
        Q_arr.emit(op,$$->loc, $1);
        init_value *init = new init_value;
        init->int_val = $1;                     
        curr_sym->lookup($$->loc)->init_val = init;
        $$->is_pointer_type = 0;

    }
	| FLOAT_CONSTANT	
    {
        $$ = new exp_attr;
        type_inf type;
        type.type_name = "double";
        opcodeType op = COPY;
        $$->loc = curr_sym->gentemp(type);
        Q_arr.emit(op,$$->loc, $1);
        init_value *init = new init_value;
        init->double_val = $1;
        curr_sym->lookup($$->loc)->init_val = init;
        $$->is_pointer_type = 0;
    }
	| CHAR_CONSTANT	
    {
        $$ = new exp_attr;
        type_inf type;
        type.type_name = "char";
        opcodeType op = COPY;
        $$->loc = curr_sym->gentemp(type);
        Q_arr.emit(op,$$->loc, $1);
        init_value *init = new init_value;
        init->char_val = $1;
        curr_sym->lookup($$->loc)->init_val = init;
        $$->is_pointer_type = 0;
    }
    | STRING_LITERAL	
    {
        $$ = new exp_attr;
        string s = ".LC";
        string temp = to_string(literal_count);
        s = s + temp;
        $$->loc = s;
        literal_count++;
        string_lits.push_back(*$1);
    }
    | '(' expression ')'	
    {
        $$ = $2;
    }
    ;
postfix_expression  //need to do
    : primary_expression	
    {
        $$ = $1;
        //$$->array = NULL;
        //$$->is_array_id = 0;
    }
    | postfix_expression '[' expression ']'	
    {
        type_inf t = curr_sym->lookup($1->loc)->type;
	//cout<<"Hi"<<$1->loc<<endl;
        string s;
        type_inf t1;
        t1.type_name = "int";
	int idx;
	string s1;
	idx = t.idx;
	s = curr_sym->gentemp(t1);
        Q_arr.emit(COPY, s, 0);
        $1 -> inner = new string(s);    //temporary for inner dimension
	s = *($1->inner);
	s1 = to_string(idx);
	/*if($1->dim == 0)
        {
            s = curr_sym->gentemp(t1);
            Q_arr.emit(COPY, s, 0);
            $1 -> inner = new string(s);    //temporary for inner dimensions
	   // s = *($1->inner);
            int factor = t.array_list[$1->dim];
       	   // $1->dim++;
            s1 = to_string(factor);
        }*/
        
        Q_arr.emit(MULT, s, s, s1);
        Q_arr.emit(PLUS, s, s, $3->loc);
        Q_arr.emit(MULT, s, s, string("4"));
        $$ = $1;
    }
    | postfix_expression '(' ')'	{}
    | postfix_expression '(' argument_expression_list ')'	
    {
        string f = $1->loc;
        symboltable *fsym = GT.lookup(f)->nested_table;
        func_list *flist = ($3);
        list<func_def*>::iterator it;
        int c = 0;
        for(it = flist->func_def_list.begin(); it!=flist->func_def_list.end();it++)
        {
            func_def *f = *it;
            c++;
            Q_arr.emit(PARAM, f->param_name,"","");
        }
	//cout<<f<<" "<<c<<"\n";
        string s = to_string(c);
	    //symtab *t1 = fsym->lookup("retVal");
		//if(t1->type.type_name.compare("void")==0)
        	Q_arr.emit(CALL,f,s,"");
		//else
		//	Q_arr.emit(CALL,f,s,t1->type.type_name);
    }
    | postfix_expression '.' IDENTIFIER	{}
    | postfix_expression POINTER_OP IDENTIFIER	{}
    | postfix_expression INCREMENT_OP	
    {
        //check code//
    
        $$ = new exp_attr;

        string s = $1->loc;
        symtab * f = curr_sym->lookup($1->loc);
        $$->loc = curr_sym->gentemp(f->type);
        if(f->type.array_type.compare("array") == 0)
        {
            //emit
            string temp = curr_sym->gentemp(f->type);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            Q_arr.emit(COPY, $$->loc, temp, "");
            Q_arr.emit(PLUS, temp, temp, "1");
            Q_arr.emit(ARRAY_DEREFERENCE, $1->loc, temp, *($1->inner));
        }
        //cout<<$$->loc<<"\n";
        else
        {
            Q_arr.emit(COPY, $$->loc, $1->loc, "");
            Q_arr.emit(PLUS, $1->loc, $1->loc, "1");  
        }   //corrected
    }
    | postfix_expression DECREMENT_OP	
    {
        $$ = new exp_attr;
        symtab * f = curr_sym->lookup($1->loc);
        $$->loc = curr_sym->gentemp(f->type);
        if(f->type.array_type.compare("array") == 0)
        {
            //emit
            string temp = curr_sym->gentemp(f->type);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            Q_arr.emit(COPY, $$->loc, temp, "");
            Q_arr.emit(MINUS, temp, temp, "1");
            Q_arr.emit(ARRAY_DEREFERENCE, $1->loc, temp, *($1->inner));
        }
        else
        {
            Q_arr.emit(COPY, $$->loc, $1->loc, "");
            Q_arr.emit(MINUS, $1->loc, $1->loc, "1");    
        }//corrected
    }
    | '(' type_name ')' '{' initializer_list '}'	{}
    | '(' type_name ')' '{' initializer_list ',' '}'	{}
    ;


argument_expression_list
    : assignment_expression	
    {
        //do this
        func_def *f = new func_def;
        f->param_name = $1->loc;
        $$ = new func_list;
        f->type = &(curr_sym->lookup(f->param_name)->type);
        $$->func_def_list.push_back(f);
    }
    | argument_expression_list ',' assignment_expression	
    {
        //do this
        func_def *f = new func_def;
        f->param_name = $3->loc;
        $$ = new func_list;
        f->type = &(curr_sym->lookup(f->param_name)->type);
	$$ = $1;
        $$->func_def_list.push_back(f);
    }
    ;

unary_expression
    : postfix_expression	{}
    | INCREMENT_OP unary_expression	
    {
        //check code again
        opcodeType op;
        op = PLUS;
        //Q_arr.emit(op, $2->loc, $2->loc, "1");
        $$ = new exp_attr;
        type_inf type;
        type = curr_sym->lookup($2->loc)->type;
        if(type.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type);
            Q_arr.emit(ARRAY_ACCESS, temp, $2->loc, *($2->inner));
            Q_arr.emit(PLUS, temp, temp, "1");
            Q_arr.emit(ARRAY_DEREFERENCE, $2->loc, temp, *($2->inner));
        }
        else
            Q_arr.emit(op, $$->loc, $2->loc, "1");

        type = curr_sym->lookup($2->loc)->type;
        $$->loc = curr_sym->gentemp(type);
        
        op = COPY;
        Q_arr.emit(op, $2->loc, $$->loc, "");
    }
    | DECREMENT_OP unary_expression	
    {
        //check code again
        opcodeType op;
        op = MINUS;
        //Q_arr.emit(op, $2->loc, $2->loc, "1");
        $$ = new exp_attr;
        type_inf type;
        type = curr_sym->lookup($2->loc)->type;
        $$->loc = curr_sym->gentemp(type);
        if(type.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type);
            Q_arr.emit(ARRAY_ACCESS, temp, $2->loc, *($2->inner));
            Q_arr.emit(MINUS, temp, temp, "1");
            Q_arr.emit(ARRAY_DEREFERENCE, $2->loc, temp, *($2->inner));
        }
        else
            Q_arr.emit(op, $$->loc, $2->loc, "1");

        type = curr_sym->lookup($2->loc)->type;
        $$->loc = curr_sym->gentemp(type);
        
        op = COPY;
        Q_arr.emit(op, $2->loc, $$->loc, "");        
    }
    | unary_operator cast_expression	
    {
        $$ = new exp_attr;
        type_inf type;
        type.type_name = string("int");
        if($1 == '-')
        {
            $$ = new exp_attr; 
            $$->loc = curr_sym->gentemp(type);
            Q_arr.emit(UNARY_MINUS,$$->loc,$2->loc,"");
        }
        else if($1 == '&')
        {
            $$ = new exp_attr;
	    type.pointer_type = "ptr";
	    type.pointer_count = 1;
	    type.size = 8;
            $$->loc = curr_sym->gentemp(type);
            Q_arr.emit(REFERENCE,$$->loc,$2->loc,"");
        }
        else if($1 == '*')
        {
            $$ = new exp_attr; 
            $$->loc = curr_sym->gentemp(type);
            Q_arr.emit(DEREFERENCE,$$->loc,$2->loc,"");
        }
        else
        {
            $$ = $2;
        }
        
        //check code
    }
    | SIZEOF_KEYWORD unary_expression	{}
    | SIZEOF_KEYWORD '(' type_name ')'	{}
    ;

unary_operator
    : '&'	
    {
        $$ = '&';
    }
    | '*'	
    {
        $$ = '*';
    }
    | '+'	
    {
        $$ = '+';
    }
    | '-'	
    {
        $$ = '-';
    }
    | '~'	
    {
        $$ = '~';
    }
    | '!'	
    {
        $$ = '!';
    }
    ;

cast_expression
    : unary_expression	{}
    | '(' type_name ')' cast_expression	{}
    ;

multiplicative_expression	
    : cast_expression	
    {
        /*symtab *t = curr_sym->lookup($1->loc);
        if(t->type.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(t->type);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        else
            $$ = $1;*/
    }
    | multiplicative_expression '*' cast_expression	
    {
        $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;


        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        int flag = 0;
        if(type1.type_name == type2.type_name)
        {
            type.type_name = type1.type_name;
            flag = 1;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convI2D(e,$3);
            type.type_name = type1.type_name;
            //$3->loc
        }
        else if(type1.type_name.compare("int")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convI2D(e,$1);
            type.type_name = type2.type_name;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2D(e,$3);
            type.type_name = type1.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convC2D(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("int")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$3);
            type.type_name = type1.type_name;
            
        }
        $$->loc = curr_sym->gentemp(type);
        //if(flag == 1)
        //cout<<$$->loc<<"\n";
        Q_arr.emit(MULT, $$->loc, $1->loc, $3->loc);

    }
    | multiplicative_expression '/' cast_expression	
    {

     $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        int flag = 0;
        if(type1.type_name == type2.type_name)
        {
            type.type_name = type1.type_name;
            flag = 1;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convI2D(e,$3);
            type.type_name = type1.type_name;
            //$3->loc
        }
        else if(type1.type_name.compare("int")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convI2D(e,$1);
            type.type_name = type2.type_name;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2D(e,$3);
            type.type_name = type1.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convC2D(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("int")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$3);
            type.type_name = type1.type_name;
            
        }
        $$->loc = curr_sym->gentemp(type);
        //if(flag == 1)
        //cout<<$$->loc<<"\n";
        Q_arr.emit(DIVIDE, $$->loc, $1->loc, $3->loc);


    }
    | multiplicative_expression '%' cast_expression	
    {

        $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        int flag = 0;
        if(type1.type_name == type2.type_name)
        {
            type.type_name = type1.type_name;
            flag = 1;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convI2D(e,$3);
            type.type_name = type1.type_name;
            //$3->loc
        }
        else if(type1.type_name.compare("int")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convI2D(e,$1);
            type.type_name = type2.type_name;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2D(e,$3);
            type.type_name = type1.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convC2D(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("int")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$3);
            type.type_name = type1.type_name;
            
        }
        $$->loc = curr_sym->gentemp(type);
        //if(flag == 1)
        //cout<<$$->loc<<"\n";
        Q_arr.emit(MODULO, $$->loc, $1->loc, $3->loc);

    }
    ;

additive_expression
    : multiplicative_expression	{$$ = $1;}
    | additive_expression '+' multiplicative_expression	
    {

        $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        int flag = 0;
        if(type1.type_name == type2.type_name)
        {
            type.type_name = type1.type_name;
            flag = 1;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convI2D(e,$3);
            type.type_name = type1.type_name;
            //$3->loc
        }
        else if(type1.type_name.compare("int")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convI2D(e,$1);
            type.type_name = type2.type_name;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2D(e,$3);
            type.type_name = type1.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convC2D(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("int")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$3);
            type.type_name = type1.type_name;
            
        }
        $$->loc = curr_sym->gentemp(type);
        //if(flag == 1)
        //cout<<$$->loc<<"\n";
        Q_arr.emit(PLUS, $$->loc, $1->loc, $3->loc);

    }
    | additive_expression '-' multiplicative_expression	
    {

        $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        int flag = 0;
        if(type1.type_name == type2.type_name)
        {
            type.type_name = type1.type_name;
            flag = 1;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convI2D(e,$3);
            type.type_name = type1.type_name;
            //$3->loc
        }
        else if(type1.type_name.compare("int")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convI2D(e,$1);
            type.type_name = type2.type_name;
        }
        if(type1.type_name.compare("double")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2D(e,$3);
            type.type_name = type1.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("double")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type2;
            Q_arr.convC2D(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("char")==0 && type2.type_name.compare("int")==0)
        {   
            string t = curr_sym->gentemp(type2);
            symtab *s = curr_sym->lookup(t, type2.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$1);
            type.type_name = type2.type_name;
            
        }
        if(type1.type_name.compare("int")==0 && type2.type_name.compare("char")==0)
        {   
            string t = curr_sym->gentemp(type1);
            symtab *s = curr_sym->lookup(t, type1.type_name);
            exp_attr *e = new exp_attr;
            e->loc = t;
            e->type = type1;
            Q_arr.convC2I(e,$3);
            type.type_name = type1.type_name;
            
        }
        $$->loc = curr_sym->gentemp(type);
        //if(flag == 1)
        //cout<<$$->loc<<"\n";
        Q_arr.emit(MINUS, $$->loc, $1->loc, $3->loc);

    }
    ;

shift_expression
    : additive_expression	{}
    | shift_expression LEFT_SHIFT additive_expression	
    {
        $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        int flag = 0;
        if(type1.type_name.compare("int") == 0)
        {

        }
        else
        {
            if(type1.type_name.compare("double") == 0)
            {
                type1.type_name = "int";
                string t = curr_sym->gentemp(type1);
                symtab *s = curr_sym->lookup(t, "int");
                exp_attr *e = new exp_attr;
                e->loc = t;
                e->type.type_name = "int";
                Q_arr.convD2I(e,$3);
                //type.type_name = type1.type_name;
            }
            else if(type1.type_name.compare("char") == 0)
            {
                type1.type_name = "int";
                string t = curr_sym->gentemp(type1);
                symtab *s = curr_sym->lookup(t, "int");
                exp_attr *e = new exp_attr;
                e->loc = t;
                e->type.type_name = "int";
                Q_arr.convC2I(e,$3);
                //type.type_name = type1.type_name;
            }
        }
        type1.type_name = "int";
        $$->loc = curr_sym->gentemp(type1);
        Q_arr.emit(SHIFT_LEFT, $$->loc, $1->loc, $3->loc);
    }
    | shift_expression RIGHT_SHIFT additive_expression	
    {
        $$ = new exp_attr;
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        int flag = 0;
        if(type1.type_name.compare("int") == 0)
        {

        }
        else
        {
            if(type1.type_name.compare("double") == 0)
            {
                type1.type_name = "int";
                string t = curr_sym->gentemp(type1);
                symtab *s = curr_sym->lookup(t, "int");
                exp_attr *e = new exp_attr;
                e->loc = t;
                e->type.type_name = "int";
                Q_arr.convD2I(e,$3);
                //type.type_name = type1.type_name;
            }
            else if(type1.type_name.compare("char") == 0)
            {
                type1.type_name = "int";
                string t = curr_sym->gentemp(type1);
                symtab *s = curr_sym->lookup(t, "int");
                exp_attr *e = new exp_attr;
                e->loc = t;
                e->type.type_name = "int";
                Q_arr.convC2I(e,$3);
                //type.type_name = type1.type_name;
            }
        }
        type1.type_name = "int";
        $$->loc = curr_sym->gentemp(type1);
        Q_arr.emit(SHIFT_RIGHT, $$->loc, $1->loc, $3->loc);
    }
    ;
relational_expression
    : shift_expression	{}
    | relational_expression '<' shift_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        $$->type.type_name = "bool";
        $$->loc = curr_sym->gentemp($$->type);
        $$->truelist = makelist(Q_arr.index);
        $$->falselist = makelist(Q_arr.index + 1);
        Q_arr.emit(IF_LESS, "", $1->loc, $3->loc);
        Q_arr.emit(GOTO,"","","");
    }
    | relational_expression '>' shift_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        $$->type.type_name = "bool";
        $$->loc = curr_sym->gentemp($$->type);
        $$->truelist = makelist(Q_arr.index);
        $$->falselist = makelist(Q_arr.index + 1);
        Q_arr.emit(IF_GREATER, "", $1->loc, $3->loc);
        Q_arr.emit(GOTO,"","","");
    }
    | relational_expression LESS_EQ_OP shift_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        $$->type.type_name = "bool";
        $$->loc = curr_sym->gentemp($$->type);
        $$->truelist = makelist(Q_arr.index);
        $$->falselist = makelist(Q_arr.index + 1);
        Q_arr.emit(IF_LESS_EQUAL, "", $1->loc, $3->loc);
        Q_arr.emit(GOTO,"","","");
    }
    | relational_expression GREATER_EQ_OP shift_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        $$->type.type_name = "bool";
        $$->loc = curr_sym->gentemp($$->type);
        $$->truelist = makelist(Q_arr.index);
        $$->falselist = makelist(Q_arr.index + 1);
        Q_arr.emit(IF_GREATER_EQUAL, "", $1->loc, $3->loc);
        Q_arr.emit(GOTO,"","","");
    }
    ;
equality_expression
    : relational_expression	{}
    | equality_expression EQ_OP relational_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        $$->type.type_name = "bool";
        $$->loc = curr_sym->gentemp($$->type);
        $$->truelist = makelist(Q_arr.index);
        $$->falselist = makelist(Q_arr.index + 1);
        Q_arr.emit(IF_IS_EQUAL,"",$1->loc, $3->loc);
        Q_arr.emit(GOTO,"","","");
    }
    | equality_expression NOT_EQ_OP relational_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        $$->type.type_name = "bool";
        $$->loc = curr_sym->gentemp($$->type);
        $$->truelist = makelist(Q_arr.index);
        $$->falselist = makelist(Q_arr.index + 1);
        Q_arr.emit(IF_NOT_EQUAL,"",$1->loc, $3->loc);
        Q_arr.emit(GOTO,"","","");
    }
    ;

and_expression
    : equality_expression	{}
    | and_expression '&' equality_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        symtab *f = curr_sym->lookup($1->loc);//check
        type_inf t;
        t = f->type;
        $$->loc = curr_sym->gentemp(t);
        Q_arr.emit(LOGICAL_AND, $$->loc, $1->loc, $3->loc);
    }
    ;

exclusive_or_expression
    : and_expression	
    {
        //printf("exclusive_or_expression -> and_expression\n");
    }
    | exclusive_or_expression '^' and_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        symtab *f = curr_sym->lookup($1->loc);//check
        type_inf t;
        t = f->type;
        $$->loc = curr_sym->gentemp(t);
        Q_arr.emit(XOR, $$->loc, $1->loc, $3->loc);
        //printf("exclusive_or_expression -> exclusive_or_expression ^ and_expression\n");
    }
    ;
inclusive_or_expression
    : exclusive_or_expression	
    {
        //printf("inclusive_or_expression -> exclusive_or_expression\n");
    }
    | inclusive_or_expression '|' exclusive_or_expression	
    {
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        symtab *f = curr_sym->lookup($1->loc);//check
        type_inf t;
        t = f->type;
        $$->loc = curr_sym->gentemp(t);
        Q_arr.emit(OR, $$->loc, $1->loc, $3->loc);
        //printf("inclusive_or_expression -> inclusive_or_expression | exclusive_or_expression\n");
    }
    ;
logical_and_expression
    : inclusive_or_expression	{}
    | logical_and_expression N AND_OP M inclusive_or_expression	N
    {
        type_inf type1, type2;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($5->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $5->loc, *($5->inner));
            $5->loc = temp;
            $5->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        type_inf type;
        type.type_name = "bool";
        $$ = new exp_attr;
        $$->type = type;

        //N requred to prevent fall-through
        //backpatch required to convert $1 to bool
        Q_arr.backpatch($2->nextlist, Q_arr.index);
        Q_arr.convInt2Bool($1);

        //N requred to prevent fall-through
        //backpatch required to convert $5 to bool
        Q_arr.backpatch($6->nextlist, Q_arr.index);
        Q_arr.convInt2Bool($5);

        //now normal boolean TAC is followed
        Q_arr.backpatch($1->truelist, $4->instr);
        $$->truelist = $5->truelist;
        $$->falselist = merge($1->falselist, $5->falselist);
        //printf("logical_or_expression -> logical_or_expression && inclusive_or_expression\n");
    }
    ;
logical_or_expression
    : logical_and_expression	{//printf("logical_or_expression -> logical_and_expression\n");
    }
    | logical_or_expression N OR_OP M logical_and_expression N	
    {
        type_inf type1, type2;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($5->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $5->loc, *($5->inner));
            $5->loc = temp;
            $5->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $1->loc, *($1->inner));
            $1->loc = temp;
            $1->type.array_type = ""; //check
        }
        
        type_inf type;
        type.type_name = "bool";
        $$ = new exp_attr;
        $$->type = type;
        
        //N requred to prevent fall-through
        //backpatch required to convert $1 to bool
        Q_arr.backpatch($2->nextlist, Q_arr.index);
        Q_arr.convInt2Bool($1);

        //N requred to prevent fall-through
        //backpatch required to convert $5 to bool
        Q_arr.backpatch($6->nextlist, Q_arr.index);
        Q_arr.convInt2Bool($5);

        //now normal boolean TAC is followed
        Q_arr.backpatch($1->falselist, $4->instr);
        $$->truelist = merge($1->truelist, $5->truelist);
        $$->falselist = $5->falselist;
        
        //printf("logical_or_expression -> logical_or_expression || logical_and_expression\n");
    }
    ;
conditional_expression
    : logical_or_expression	
    {
        //printf("conditional_expression -> logical_or_expression\n");
    }
    | logical_or_expression N '?' M expression N ':' M conditional_expression	
    {
        type_inf type1, type2;
        type1 = curr_sym->lookup($5->loc)->type;
        type2 = curr_sym->lookup($9->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $9->loc, *($9->inner));
            $9->loc = temp;
            $9->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type1);
            Q_arr.emit(ARRAY_ACCESS, temp, $5->loc, *($5->inner));
            $9->loc = temp;
            $9->type.array_type = ""; //check
        }
        
        $$ = new exp_attr;
        list<int> I;
        type_inf type;
        type = curr_sym->lookup($5->loc)->type;
        $$->loc = curr_sym->gentemp(type);
        Q_arr.emit(COPY, $$->loc, $9->loc,"");
        I = makelist(Q_arr.index);
        Q_arr.emit(GOTO,"","","");
        Q_arr.backpatch($6->nextlist, Q_arr.index);
        Q_arr.emit(COPY, $$->loc, $5->loc, "");
        I = merge(I, makelist(Q_arr.index));
        Q_arr.emit(GOTO,"", "", "");
        Q_arr.backpatch($2->nextlist, Q_arr.index);
        Q_arr.convInt2Bool($1);
        Q_arr.backpatch($1->truelist, $4->instr);
        Q_arr.backpatch($1->falselist, $8->instr);
        Q_arr.backpatch(I, Q_arr.index);
        //printf("conditional_expression -> logical_or_expression ? expression : conditional_expression\n");
    }
    ;
assignment_expression
    : conditional_expression	
    {
        //printf("assignment_expression -> conditional_expression\n");
    }
    | unary_expression assignment_operator assignment_expression	
    {
        //printf("assignment_expression -> unary_expression assignment_operator assignment_expression\n");
        //check this
        type_inf type1, type2, type;
        type1 = curr_sym->lookup($1->loc)->type;
        type2 = curr_sym->lookup($3->loc)->type;

        if(type2.array_type.compare("array") == 0)
        {
            string temp = curr_sym->gentemp(type2);
            Q_arr.emit(ARRAY_ACCESS, temp, $3->loc, *($3->inner));
            $3->loc = temp;
            $3->type.array_type = ""; //check
        }
        
        if(type1.array_type.compare("array") == 0)
        {
            Q_arr.emit(ARRAY_DEREFERENCE, $1->loc, $3->loc, *($1->inner));
        }
        else
            Q_arr.emit(COPY, $1->loc, $3->loc, "");
        $$ = $1;
	//cout<<"Hi"<<$1->loc<<"\n";
    }
    ;

assignment_operator
    : '='	
    {
        //printf("assignment_operator -> '='\n");
    }
    | MUL_ASSIGNMENT	{//printf("assignment_operator -> '*='\n");
    }
    | DIV_ASSIGNMENT	{//printf("assignment_operator -> '/='\n");
    }
    | MOD_ASSIGNMENT	{//printf("assignment_operator -> '%='\n");
    }
    | ADD_ASSIGNMENT	{//printf("assignment_operator -> '+='\n");
}
    | SUB_ASSIGNMENT	{//printf("assignment_operator -> '-='\n");
}
    | LEFT_ASSIGNMENT	{//printf("assignment_operator -> <<=\n");
}
    | RIGHT_ASSIGNMENT	{//printf("assignment_operator -> >>=\n");
}
    | AND_ASSIGNMENT	{//printf("assignment_operator -> &=\n");
}
    | XOR_ASSIGNMENT	{//printf("assignment_operator -> ^=\n");
}
    | OR_ASSIGNMENT	{//printf("assignment_expression -> '|='\n");
}
    ;
expression
    : assignment_expression	
    {
        //printf("expression -> assignment_expression\n");

        $$ = $1;
    }
    | expression ',' assignment_expression	
    {
        //printf("expression -> expression , assignment_expression\n");
    }
    ;
constant_expression
    : conditional_expression	
    {
        //printf("constant_expression -> conditional_expression\n");
    }
    ;


// Declarations

declaration
    : declaration_specifiers ';'	
    {
        //printf("declaration -> declaration_specifiers\n");
    }
    | declaration_specifiers init_declarator_list ';'	
    {
        //printf("declaration -> declaration_specifiers init_declarator_list\n");
        init_dec_list *new_dec = new init_dec_list;
        new_dec = $2;
        int size = 0;
        type_inf *type = $1;
        if(type->type_name.compare("int")==0) size = 4;
        if(type->type_name.compare("double")==0) size = 8;
        if(type->type_name.compare("char")==0) size = 1;

        list<declaration*>::iterator it;
        for(it = $2->dec_list.begin(); it != $2->dec_list.end(); it++)
        {
            declaration *new_dec = *it;
            //check this
            //cout<<new_dec->dec_name<<"\n";
		    if(new_dec->type!=NULL){
            if(new_dec->type->type_name.compare("function")==0)
            {
                string name = new_dec->dec_name;
                //cout<<name<<"\n";
                curr_sym = &GT;
                Q_arr.emit(_FUNCTION_END,name,"","");
                //write an emit
            }
            
            symtab *ret, *f;
            symboltable *nest;
            if(new_dec->type->type_name.compare("function")==0)
            {
                f = curr_sym->lookup(new_dec->dec_name, type->type_name);
                //f->nested_table = new symboltable;
                //cout<<new_dec->dec_name<<"\n";
                nest = f->nested_table;
                ret = nest->lookup("retVal", type->type_name, new_dec->pointer_count);
                f->offset = curr_sym->offset;
                f->size = size;
                //curr_sym = nest;
                f->init_val = NULL;
                continue;
            }
            }
            //cout<<type->type_name;
            //cout<<curr_sym->sym_table[0].id<<"\n";
            
            //cout<<(sym)->sym_table[0].id<<"\n";
            
            symtab *f1 = curr_sym->lookup(new_dec->dec_name, type->type_name);

            //cout<<curr_sym->sym_table[2].id<<"\n";
            //cout<<new_dec->dec_name<<"\n";
            f1->nested_table = NULL;
                /*f = curr_sym->lookup(new_dec->dec_name, type->type_name);
                //f->nested_table = new symboltable;
                //symboltable *nest = f->nested_table;
                //curr_sym = nest;
                ret = nest->lookup("retVal", type->type_name, new_dec->pc);
                f->offset = curr_sym->offset;
                f->size = size;
                curr_sym = nest;*/
                
            //condition for id
            if(new_dec->alist == vector<int>() && new_dec->pointer_count == 0)
            {
                f1->offset = curr_sym->offset;
                //f1->offset = f1->offset + size;
                f1->type = *type;
                f1 = curr_sym->lookup(new_dec->dec_name, type->type_name);
                //cout<<type->type_name<<"\n";
                //cout<<curr_sym->sym_table[0].id<<"\n";
            
                if(new_dec->init != NULL)
                {
                    //cout<<curr_sym->sym_table[0].id<<"\n";
            
                    string x = new_dec->init->loc;
                    Q_arr.emit(COPY, new_dec->dec_name, x, "");
                    f1->init_val = curr_sym->lookup(x,f1->type.type_name)->init_val;
                }
                else
                    new_dec->init = NULL;
            }

            else if(new_dec -> pointer_count > 0)
            {
                //cout<<new_dec->dec_name<<"\n";
                /*f1->offset = curr_sym->offset;
                f1->pointer_count = new_dec->pointer_count;
                //type->type_name = type->type_name + ' ';
                f1->type = *type;
                f1->type.pointer_type = "ptr";
                //f1 = curr_sym->lookup(new_dec->dec_name, type->type_name, new_dec->pointer_count);
                curr_sym->offset = curr_sym->offset + 4;
                f1->size = 4; */
                symtab *sp;
                for(sp = curr_sym->sym_table; sp < &curr_sym->sym_table[curr_sym->no_of_entries]; sp++)
                {
                    //cout<<s<<"\n";
                    //cout<<"loop\n";
                    if(!sp->id.empty() && !sp->id.compare(new_dec->dec_name))
                    {
                        sp->offset = curr_sym->offset-4;
                        sp->pointer_count = new_dec->pointer_count;
                        sp->type = *type;
                        sp->type.pointer_type = "ptr";
                        //curr_sym->offset = curr_sym->offset + 4;
                        sp->size = 4;
                    }
                }
                
                //cout<<f1->pointer_count<<"\n";
                //f1 = curr_sym->lookup(new_dec->dec_name, type->type_name, new_dec->pointer_count);
            }

            else if(new_dec->alist!=vector<int>())
            {
                symtab *sp;
		//cout<<"Hi";
		//cout<<"array type: "<<new_dec->dec_name<<" "<<type->type_name<<"\n";
                for(sp = curr_sym->sym_table; sp < &curr_sym->sym_table[curr_sym->no_of_entries]; sp++)
                {
                    //cout<<s<<"\n";
                    //cout<<"loop\n";
                    if(!sp->id.empty() && !sp->id.compare(new_dec->dec_name))
                    {
                        int temp_size = size;
                        sp->offset = curr_sym->offset-4;
                        //sp->pointer_count = new_dec->pointer_count;
                        sp->type = *type;
			sp->type.type_name = type->type_name;
                        sp->type.array_type = "array";
                        sp->type.pointer_type = "";
			//cout<<"HI "<<new_dec->alist[0]<<"\n";
                        for(int i = 0; i < new_dec->alist.size(); i++)
                        {
                            sp->type.array_list.push_back(new_dec->alist[i]);
                        }
                        //sp->type.array_list = new_dec->alist;
                        //curr_sym->offset = curr_sym->offset + 4;
                        for (int i = 0; i < sp->type.array_list.size(); ++i)
                        {
                            temp_size = temp_size * sp->type.array_list[i];
                        }
                        sp->size = temp_size;
                        curr_sym->offset = curr_sym->offset + temp_size;
                    }
                }
                
            }

            
        }
        //imcomplete
    }
    ;

declaration_specifiers
    : storage_class_specifier	
    {
        //printf("declaration_specifiers -> storage_class_specifier\n");
    }
    | storage_class_specifier declaration_specifiers	
    {
        //printf("declaration_specifiers -> storage_class_specifier declaration_specifiers\n");
    }
    | type_specifier	
    {
        $$ = $1;
        //printf("declaration_specifiers -> type_specifier\n");
    }
    | type_specifier declaration_specifiers	
    {
        //printf("declaration_specifiers -> type_specifier declaration_specifiers\n");
    }
    | type_qualifier	
    {
        //printf("declaration_specifiers -> type_qualifier\n");
    }
    | type_qualifier declaration_specifiers	
    {
        //printf("declaration_specifiers -> type_qualifier declaration_specifiers\n");
    }
    | function_specifier	
    {
        //printf("declaration_specifiers -> function_specifier\n");
    }
    | function_specifier declaration_specifiers	
    {
        //printf("declaration_specifiers -> function_specifier declaration_specifiers\n");
    }
    ;


init_declarator_list
    : init_declarator	
    {  // printf("init_declarator_list -> init_declarator\n");
        $$ = new init_dec_list;
        $$->dec_list.push_back($1);
        //$$->push_back($1);
    }
    | init_declarator_list ',' init_declarator	
    {
        //printf("init_declarator_list -> init_declarator_list , init_declarator\n");
        $1->dec_list.push_back($3);
        $$ = $1;
    }
    ;


init_declarator
    : declarator	
    {
        //printf("init_declarator -> declarator\n");
        $$ = $1;
        //cout<<$$->dec_name<<":"<<$$->type->type_name<<"\n";
        $$->init = NULL;
    }
    | declarator '=' initializer	
    {
        //printf("init_declarator -> declarator = initializer\n");
        $$ = $1;
        $$->init = $3;
    }
    ;
storage_class_specifier
    : EXTERN_KEYWORD	{printf("storage_class_specifier -> extern\n");}
    | STATIC_KEYWORD	{printf("storage_class_specifier -> static\n");}
    | AUTO_KEYWORD	{printf("storage_class_specifier -> auto\n");}
    | REGISTER_KEYWORD	{printf("storage_class_specifier -> register\n");}
    ;

type_specifier              //done
    : VOID_KEYWORD	
		{
            $$ = new type_inf;
			$$->type_name = string("void"); 
		}
    | CHAR_KEYWORD	
		{
            $$ = new type_inf;
			$$->type_name = string("char");
			$$->next = NULL;
			//printf("type_specifier -> char\n");
		}
    | SHORT_KEYWORD	{//printf("type_specifier -> short\n");
        }
    | INT_KEYWORD	
		{
            $$ = new type_inf;
			$$->type_name = string("int");
			$$->next = NULL;
			
			//printf("type_specifier -> int\n");
		}
    | LONG_KEYWORD	{//printf("type_specifier -> long\n");
        }
    | FLOAT_KEYWORD	{//printf("type_specifier -> float\n");
        }
    | DOUBLE_KEYWORD	
	{
        $$ = new type_inf;
		$$->type_name = string("double");
		$$->next = NULL;
			//printf("type_specifier -> double\n");
	}
    | SIGNED_KEYWORD	{//printf("type_specifier -> signed\n");
    }
    | UNSIGNED_KEYWORD	{//printf("type_specifier -> unsigned\n");
    }
    | BOOL_KEYWORD	{//printf("type_specifier -> _Bool\n");
    }
    | COMPLEX_KEYWORD	{//printf("type_specifier -> _Complex\n");
    }
    | IMAGINARY_KEYWORD	{//printf("type_specifier -> _Imaginary\n");
    }
    | enum_specifier
    ;

specifier_qualifier_list
    : type_specifier 	
		{
			$$ = $1;
			//printf("specifier_qualifier_list -> type_specifier\n");
		}
    | type_specifier specifier_qualifier_list	
    {//printf("specifier_qualifier_list -> type_specifier specifier_qualifier_list\n");
    }
    | type_qualifier	{//printf("specifier_qualifier_list -> type_qualifier\n");
                        }
    | type_qualifier specifier_qualifier_list	{//printf("specifier_qualifier_list -> type_qualifier specifier_qualifier_list\n");
                        }
    ;
enum_specifier
    : ENUM_KEYWORD '{' enumerator_list '}'	{printf("enum_specifier -> enum {enumerator_list}\n");}
    | ENUM_KEYWORD IDENTIFIER '{' enumerator_list '}'	{printf("enum_specifier -> enum IDENTIFIER {enumerator_list} \n");}
    | ENUM_KEYWORD '{' enumerator_list ',' '}'	{printf("enum_specifier -> enum {enumerator_list, }\n");}
    | ENUM_KEYWORD IDENTIFIER '{' enumerator_list ',' '}'	{printf("enum_specifier -> enum IDENTIFIER {enumerator_list ,}\n");}
    | ENUM_KEYWORD IDENTIFIER	{printf("enum_specifier->enum IDENTIFIER\n");}
    ;
enumerator_list
    : enumerator	{printf("enumerator_list -> enumerator\n");}
    | enumerator_list ',' enumerator	{printf("enumerator_list -> enumerator_list , enumerator\n");}
    ;
enumerator
    : enumeration_constant	{printf("enumerator -> enumeration_constant\n");}
    | enumeration_constant '=' constant_expression	{printf("enumerator -> enumeration_constant = constant_expression\n");}
    ;
enumeration_constant
    : IDENTIFIER	{printf("enumeration_constant -> IDENTIFIER\n");}
    ;
type_qualifier
    : CONST_KEYWORD	{printf("type_qualifier -> const\n");}
    | RESTRICT_KEYWORD	{printf("type_qualifier -> restrict\n");}
    | VOLATILE_KEYWORD	{printf("type_qualifier -> volatile\n");}
    ;
function_specifier
    : INLINE_KEYWORD	{printf("function_specifier -> inline\n");}
declarator
    : pointer direct_declarator	
    {
        $$ = $2;
        $$->pointer_count = $1->pointer_count;
        //printf("declarator -> pointer direct_declarator\n");
    }
    | direct_declarator	
	{

		$$ = $1;
        $$->pointer_count = 0;
			//printf("declarator -> direct_declarator\n");
	}
    ;


direct_declarator 
    : IDENTIFIER	
    {//printf("direct_declarator -> IDENTIFIER\n");
        $$ = new declaration; 
        $$->dec_name = *($1);
    }
    | '(' declarator ')'	
    {
        $$ = $2;
        //printf("direct_declarator -> (declarator)\n");
    }
    | direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']'	
    {
	
        $$ = $1;
	//$$ = new declaration;
	//symtab *t = curr_sym->lookup($1->dec_name);
	//t->type.array_type = "array";
	//t->type.idx = 0;
	//$1->type->array_type = "array";
	/*for(int i=0; i<curr_sym->no_of_entries; i++)
	{
		if(curr_sym->sym_table[i].id.compare($4->loc)==0)
		{
			curr_sym->sym_table[i].type.array_type = "array";
			$1->type->array_type = "array";
			 
		}
	}*/
        int idx = curr_sym->lookup($4->loc)->init_val->int_val;
	/*$$->type->array_type = "array";
	$$->type->idx = idx;*/
	//$$ = $1;
	//t->type.idx = idx;
        $$->alist.push_back(idx);
	//$$->type->array_type = "array";
	//$$->type->idx = idx; 

        //printf("direct_declarator -> direct_declarator[type_qualifier_list_opt assignment_expression_opt]\n");
    }
    | direct_declarator '[' STATIC_KEYWORD type_qualifier_list_opt assignment_expression ']'	
    {
        //printf("direct_declarator ->direct_declarator [static type_qualifier_list assignment_expression]\n");
    }
    | direct_declarator '[' type_qualifier_list STATIC_KEYWORD assignment_expression ']'	
    {
        //printf("direct_declarator -> direct_declarator[type_qualifier_list static assignment_expression]\n");
    }
    | direct_declarator '[' type_qualifier_list_opt '*' ']'	
    {
        //printf("direct_declarator -> direct_declarator[type_qualifier_list_opt *]\n");
    }
    | direct_declarator '(' parameter_type_list_opt')'	
    {
        //name of func is available
        list<func_def*> l = $3->func_def_list;
        
        symboltable *new_sym = new symboltable;
        $$ = $1;
        string name = $$->dec_name;
        //cout<<name<<"\n";
        $$->type = new type_inf;
        $$->type->type_name = string("function");
        $$->type->no_of_params = l.size();
        symtab *func_lookup = sym->lookup($$->dec_name, $$->type->type_name);
		for(int i=0; i < sym->no_of_entries; i++)
       		{
	    	if(sym->sym_table[i].id.compare($$->dec_name)==0)
	    	{
				sym->sym_table[i].type.type_name = "function";
				sym->sym_table[i].type.no_of_params = l.size();
	    	}
        }
        /*symtab *sp1;
        for(sp1 = sym->sym_table; sp1 < &sym->sym_table[sym->no_of_entries]; sp1++)
        {
            //cout<<s<<"\n";
            //cout<<"loop\n";
            if(!sp1->id.empty() && !sp1->id.compare($$->dec_name))
            {
                sp1->type = *($$->type);
            }
        }*/
        
        //cout<<"direct_dec "<<$$->dec_name<<"\n";
        func_lookup -> nested_table = new_sym;

        list<func_def*>::iterator it;
        for(it = l.begin(); it != l.end(); it++)
        {
            func_def *temp = *it;
            //cout<<temp->param_name<<"\n";
            //cout<<temp->param_name<<"\n";
            new_sym -> lookup(temp->param_name, temp->type->type_name);
	    for(int i = 0; i<new_sym->no_of_entries; i++)
	    {
		if(new_sym->sym_table[i].id.compare(temp->param_name)==0)
		{
			if(temp->type->array_type.compare("array")==0){
				new_sym->sym_table[i].type.array_type = "array";
				new_sym->sym_table[i].type.idx = temp->type->idx;
				}
		}
	    }

            //func_lookup->nested_table -> lookup(temp->param_name, temp->type->type_name);
        }

        symtab *sp;
        for(sp = sym->sym_table; sp < &sym->sym_table[sym->no_of_entries]; sp++)
        {
            //cout<<s<<"\n";
            //cout<<"loop\n";
            if(!sp->id.empty() && !sp->id.compare($$->dec_name))
            {
                sp->nested_table = new_sym;
            }
        }
        curr_sym = new_sym;
        //cout<<curr_sym->sym_table[0].id<<"\n";
        //printf("direct_declarator -> direct_declarator (parameter_type_list)\n");
        Q_arr.emit(_FUNCTION_START, name,"","");
    }
    | direct_declarator '(' identifier_list')'	
    {
        //printf("direct_declarator -> direct_declarator (identifier_list_opt)\n");

    }
    ;
//identifier_list_opt
  //  : identifier_list	
    //{
       // printf("identifier_list_opt -> identifier_list\n");
    //}
    //|
    //;
assignment_expression_opt
   : assignment_expression	
   {
    //printf("assignment_expression_opt -> assignment_expression\n");
   }
   |
   ;
type_qualifier_list_opt
    : type_qualifier_list	
    {
        //printf("type_qualifier_list_opt -> type_qualifier_list\n");
    }
    |
    ;

pointer
    : '*'	
    {
        //printf("pointer -> '*'\n");
        $$ = new type_inf;
        $$->type_name = string("ptr");
        $$->next = NULL;
        $$->pointer_type = string("ptr");
        $$->pointer_count = 1;
    }
    | '*' type_qualifier_list	
    {
    //    printf("pointer -> *type_qualifier_list\n");
    }
    | '*' pointer	
    {
        //printf("pointer -> *pointer\n");
        $$ = new type_inf;
        $$->type_name = string("ptr");
        $$->next = NULL;
        $$->pointer_type = string("ptr");
        
        $$->pointer_count = $2->pointer_count + 1;
        
    }
    | '*' type_qualifier_list pointer	
    {
        //printf("pointer -> *type_qualifier_list pointer\n");
    }
    ;
type_qualifier_list
    : type_qualifier	
    {
        //printf("type_qualifier_list -> type_qualifier\n");
    }
    | type_qualifier_list type_qualifier	
    {
        //printf("type_qualifier_list -> type_qualifier_list type_qualifier\n");
    }
    ;
parameter_type_list_opt
    :parameter_type_list
    |   
    {
        $$ = new func_list;
    }
    ;
parameter_type_list
    : parameter_list	
    {
        $$ = new func_list;
        $$ = $1;
        //printf("parameter_type_list -> parameter_list\n");
    }
    | parameter_list ',' ELLIPSIS	
    {
        //printf("parameter_type_list -> parameter_list, ELLIPSIS\n");
    }
    ;
parameter_list
    : parameter_declaration	
    {
        //create a new list
        $$ = new func_list;
        $$->func_def_list.push_back($1);

        //printf("parameter_list -> parameter_declaration\n");
    }
    | parameter_list ',' parameter_declaration	
    {
        //make use of old list

        $1->func_def_list.push_back($3);
        $$ = $1;
        //printf("parameter_list -> parameter_list, parameter_declaration\n");
    }
    ;
parameter_declaration
    : declaration_specifiers declarator	
    {
        $$ = new func_def;
        $$->type = $1;
	if($2->alist.size()>0)
		{$$->type->array_type = "array";$$->type->idx = $2->alist[0];$$->type->type_name = $1->type_name;
	}
	for(int i=0; i<curr_sym->no_of_entries; i++)
	{
		if(curr_sym->sym_table[i].id.compare($2->dec_name)==0)
		{
			if($2->type->array_type.compare("array")==0 || curr_sym->sym_table[i].type.array_type.compare("array")==0)
			{
				curr_sym->sym_table[i].type.array_type = "array";
				$$->type->array_type = "array";
			}
		}
	}
	$$->param_name = $2->dec_name;

        //printf("parameter_declaration -> declaration_specifiers declarator\n");
    }
    | declaration_specifiers	
    {
        //printf("parameter_declaration -> declaration_specifiers\n");
    }
    ;

identifier_list
    : IDENTIFIER	
    {
        //printf("identifier_list -> IDENTIFIER\n");
    }
    | identifier_list ',' IDENTIFIER	
    {
        //printf("identifier_list -> identifier_list, IDENTIFIER\n");
    }
    ;

type_name
    : specifier_qualifier_list	
    {
        $$ = $1;
        //printf("type_name -> specifier_qualifier_list\n");
    }
    ;

initializer
    : assignment_expression	
    {//printf("initializer -> assignment_expression\n");
        $$ = $1;
    }
    | '{' initializer_list '}'	
    {
        //printf("initializer -> {initializer_list}\n");
    }
    | '{' initializer_list ',' '}'	
    {
        //printf("initializer -> {initializer_list, }\n");
    }
    ;

initializer_list
    : initializer	
    {
        //printf("initializer_list -> initializer\n");
    }
    | designation initializer	
    {
        //printf("initializer_list -> designation initializer\n");
    }
    | initializer_list ',' initializer	
    {//printf("initializer_list -> initializer_list, initializer\n");
    }
    | initializer_list ',' designation initializer	
    {
        //printf("initializer_list -> initializer_list, designation initializer\n");
    }
    ;

designation
    : designator_list '='	
    {
        //printf("designation -> designator_list -\n");
    }
    ;

designator_list
    : designator	
    {
        //printf("designator_list -> designator\n");
    }
    | designator_list designator	
    {
        //printf("designator_list -> designator_list designator\n");
    }
    ;
designator
    : '[' constant_expression ']'	
    {
        //printf("designator -> [constant_expression]\n");
    }
    | '.' IDENTIFIER	
    {
        //printf("designator -> IDENTIFIER\n");
    }
    ;


// Statements

statement
    : labeled_statement	
    {
        //printf("statement -> labeled_statement\n");
    }
    | compound_statement	
    {
        //printf("statement -> compound_statement\n");
    }
    | expression_statement	
    {
        //printf("statement -> expression_statement\n");
    }
    | selection_statement	
    {
        //printf("statement -> selection_statement\n");
    }
    | iteration_statement	
    {
        //printf("statement -> iteration_statement\n");
    }
    | jump_statement	
    {
        //printf("statement -> jump_statement\n");
    }
    ;
labeled_statement
    : IDENTIFIER ':' statement	
    {
        //printf("labeled_statement -> IDENTIFIER : statement\n");
    }
    | CASE_KEYWORD constant_expression ':' statement	
    {
        //printf("labeled_statement -> case constant_expression : statement\n");
    }
    | DEFAULT_KEYWORD ':' statement	
    {
        //printf("labeled_statement -> default : statement\n");
    }
    ;

compound_statement
	:'{' '}'	
    {
        //printf("compound_statement -> {}\n");
    }
	|'{' block_item_list '}'	
    {
        $$ = $2;
        //printf("compound_statement -> {block_item_list}\n");
    }
    ;

block_item_list
    : block_item	
    {
        $$ = $1;
        Q_arr.backpatch($1->nextlist, Q_arr.index);
        //printf("block_item_list -> block_item\n");
    }
    | block_item_list M block_item	
    {
        Q_arr.backpatch($1->nextlist, $2->instr);
        $$ = new exp_attr;
        $$->nextlist = $3->nextlist;
        //printf("block_item_list -> block_item_list block_item\n");
    }
    ;
block_item
    : declaration	
    {
        $$ = new exp_attr;
        //printf("block_item -> declaration\n");
    }
    | statement	
    {
        //printf("block_item -> statement\n");
    }
    ;
expression_statement
    : ';'	
    {
        $$ = new exp_attr;
        //printf("expression_statement -> ;\n");
    }
    | expression ';'	
    {
        //$$ = $1;
        //printf("expression_statement -> expression ;\n");
    }
    ;
selection_statement
    : IF_KEYWORD '(' expression N')' M statement N	
    {
        $$ = new exp_attr;
        //if($3->type.type_name.compare("bool"))
        Q_arr.backpatch($4->nextlist, Q_arr.index);

        //cout<<$3->type.type_name<<"\n";
        Q_arr.convInt2Bool($3);
        
        Q_arr.backpatch($3->truelist, $6->instr);
        //$$->nextlist

        $$->nextlist = merge($8->nextlist, $7->nextlist);
        $$->nextlist = merge($$->nextlist, $3->falselist);
        //printf("selection_statement -> if (expression) statement\n");
    }
    | IF_KEYWORD '(' expression N')' M statement N ELSE_KEYWORD M statement	N
    {
        $$ = new exp_attr;

        Q_arr.backpatch($4->nextlist , Q_arr.index);

        Q_arr.convInt2Bool($3);

        $$->nextlist = merge($7->nextlist, $8->nextlist);

        Q_arr.backpatch($3->truelist, $6->instr);
        Q_arr.backpatch($3->falselist, $10->instr);

        $$->nextlist = merge($$->nextlist, $12->nextlist);
        $$->nextlist = merge($$->nextlist, $11->nextlist);
        //printf("selection_statement -> if(expression) statement else statement\n");
    }
    | SWITCH_KEYWORD '(' expression ')' statement	
    {
        //printf("selection_statement -> switch(expression) statement\n");
    }
    ;
iteration_statement
    : WHILE_KEYWORD M '(' expression N ')' M statement	
    {
        Q_arr.emit(GOTO,"","","");
        Q_arr.backpatch(makelist(Q_arr.index-1),$2->instr);    

        Q_arr.backpatch($5->nextlist,Q_arr.index);
        Q_arr.convInt2Bool($4);

        $$ = new exp_attr;
        Q_arr.backpatch($8->nextlist, $2->instr);
        Q_arr.backpatch($4->truelist, $7->instr);
        $$->nextlist = $4->falselist;
        //printf("iteration_statement -> while(expression) statement\n");
    }
    | DO_KEYWORD M statement M WHILE_KEYWORD '(' expression ')' ';'	
    {
        $$ = new exp_attr;
        Q_arr.convInt2Bool($7);
        Q_arr.backpatch($3->nextlist, $4->instr);
        Q_arr.backpatch($7->truelist, $2->instr);
        $$->nextlist = $7->falselist;
        //printf("iteration_statement -> do statement while(expression);\n");
    }
    | FOR_KEYWORD '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement	
    {
        $$ = new exp_attr;
    
        Q_arr.emit(GOTO,"","","");
        Q_arr.backpatch(makelist(Q_arr.index-1),$9->instr);    
        Q_arr.backpatch($7->nextlist, Q_arr.index);
        Q_arr.convInt2Bool($6);

        Q_arr.backpatch($11->nextlist,$5->instr);
        Q_arr.backpatch($6->truelist,$13->instr);
        Q_arr.backpatch($14->nextlist,$9->instr);
    
        $$->nextlist = $6->falselist;

        //printf("iteration_statement -> for(expression_opt expression_opt expression_opt) statement\n");
    }
    | FOR_KEYWORD '(' declaration expression_opt ';' expression_opt ')' statement	
    {
        //printf("iteration_statement -> for (declaration expression_opt expression_opt) statement\n");
    }
    ;
expression_opt
	:expression	
    {
        //printf("expression_opt -> expression\n");
    }
	|
	;
jump_statement
    : GOTO_KEYWORD IDENTIFIER ';'	
    {
        //printf("jump_statement -> goto IDENTIFIER :\n");
    }
    | CONTINUE_KEYWORD ';'	
    {
        //printf("jump_statement -> continue ;\n");
    }
    | BREAK_KEYWORD ';'	
    {
        //printf("jump_statement -> break;\n");
    }
    | RETURN_KEYWORD ';'	
    {
        $$ = new exp_attr;

        if(curr_sym->lookup("retVal")->type.type_name.compare("void")==0)
        {
            Q_arr.emit(RETURN_VOID,"","","");
        }
        
        //printf("jump_statement -> return;\n");
    }
    | RETURN_KEYWORD expression ';'	
    {
        $$ = new exp_attr;
        type_inf type1, type2, type3;
        type1 = curr_sym->lookup("retVal")->type;
        type2 = curr_sym->lookup($2->loc)->type;
        for(int i=0; i<sym->no_of_entries;i++)
	{
		if(sym->sym_table[i].id.compare($2->loc)==0)
			type3 = sym->sym_table[i].type;
	}
	if(type3.type_name.compare("function")==0)
	{	
		string t = curr_sym->gentemp(type1);
		Q_arr.emit(COPY, t, $2->loc, "");
		Q_arr.emit(RETURN,t,"","");
	}
	else if(type1.type_name == type2.type_name)
        {
            Q_arr.emit(RETURN, $2->loc, "", "");
        }
	
        //printf("jump_statement -> return expression;\n");

    }
    ;


// External Definitions

translation_unit
    : external_declaration	
    {
        //printf("translation_unit -> external_declaration\n");
    }
    | translation_unit external_declaration	
    {
        //printf("translation_unit -> translation_unit external_declaration\n");
    }
    ;

external_declaration
    : function_definition	
    {
        //printf("external_declaration -> function_definition\n");
    }
    | declaration	
    {
        //printf("external_declaration -> declaration\n");
    }
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement	
    {
        //printf("function_definition -> declaration_specifiers declarator declaration_list compound_statement\n");
    }
    | declaration_specifiers declarator compound_statement	
    {
        //sym->nested_table = NULL;
        //curr_sym->nested_table = NULL;
        
        declaration *new_dec = $2;
        int size = 0;
        type_inf *type = $1;
        if(type->type_name.compare("int")==0) size = 4;
        if(type->type_name.compare("double")==0) size = 8;
        if(type->type_name.compare("char")==0) size = 1;
        if(type->type_name.compare("void")==0) size = 0;
        //cout<<$2->type->type_name;
        symboltable *gt = &GT;
        Q_arr.emit(_FUNCTION_END,new_dec->dec_name,"","");
        symtab *func = gt->lookup($2->dec_name);
        //cout<<"func_def "<<$2->dec_name<<"\n";
        //func->nested_table = new symboltable;
        if(func->nested_table != NULL)
        {
            //cout<<"nested\n";
            //cout<<new_dec->dec_name<<" "<<new_dec->pointer_count<<type->type_name<<"\n";
            if($2->pointer_count>0)
                type->pointer_type = "ptr";
            symtab *ret = func->nested_table->lookup("retVal", type->type_name, $2->pointer_count);
            /*symtab *sp;
            for(sp = func->nested_table->sym_table; sp < &func->nested_table->sym_table[func->nested_table->no_of_entries]; sp++)
            {
                //cout<<s<<"\n";
                //cout<<"loop\n";
                if(!sp->id.empty() && !sp->id.compare($$->dec_name))
                {

                    sp->type = *type;
                    sp->pointer_count = $2->pointer_count;
                }
            }*/
        
            if($2->pointer_count>0)
            {
                ret->pointer_count = $2->pointer_count;
                ret->type.pointer_type = "ptr";
            }
            ret->offset = curr_sym->offset;
            ret->size = size;
            ret->init_val = NULL;
        }
        //curr_sym = func->nested_table;
        curr_sym = gt;
        $$ = $2;
        //printf("function_definition -> declaration_specifiers declarator compound_statement\n");
    }

    ;
declaration_list
    :declaration	
    {
        //printf("declaration_list -> declaration\n");
    }
    |declaration_list declaration	
    {
        //printf("declaration_list -> declaration_list declaration\n");
    }
    ;



%%
void yyerror(string s) 
{
	cout << s << endl;
}


