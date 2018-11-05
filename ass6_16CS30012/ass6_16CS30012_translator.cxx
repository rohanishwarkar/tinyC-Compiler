// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6

#include "ass6_16CS30012_translator.h"
void Quad :: print()
{
	if(op >= PLUS && op <=GREATER_EQUAL)
	{
		if(result.compare("")==1)
			cout<<result<<" = "<<arg_1;
		else 
			cout<<arg_1;
		switch(op)
		{
            case PLUS: 
				cout<<"+"; 
				break;
            case MINUS: 
				cout<<"-"; 
				break;
            case MULT: 
				cout<<"*"; 
				break;
            case DIVIDE: 
				cout<<"/"; 
				break;
			case AND: 
				cout<<"&"; 
				break;
            case MODULO: 
				cout<<"%"; 
				break;
            case SHIFT_LEFT: 
				cout<<"<<"; 
				break;
            case SHIFT_RIGHT: 
				cout<<">>"; 
				break;
            case XOR: 
				cout<<"^"; 
				break;
            case OR: 
				cout<<"|"; 
				break;
            case LOGICAL_AND: 
				cout<<"&&"; 
				break;
            case LOGICAL_OR: 
				cout<<"||"; 
				break;
            case LESS: 
				cout<<"<"; 
				break;
            case GREATER: 
				cout<<">"; 
				break;
            case IS_EQUAL: 
				cout<<"=="; 
				break;
            case NOT_EQUAL: 
				cout<<"!="; 
				break;
            case LESS_EQUAL: 
				cout<<"<="; 
				break;
            case GREATER_EQUAL: 
				cout<<">="; 
				break;
		}
		cout<<arg_2<<"\n";
	}
	else if(op >= UNARY_PLUS && op <=NOT)
	{
		cout<<result<<" = ";
		switch(op)
		{
			case UNARY_PLUS:
				cout<<"+";
				break;
			case UNARY_MINUS:
				cout<<"-";
				break;
			case COMPLEMENT:
				cout<<"~";
				break;
			case NOT:
				cout<<"!";
				break; 
		}
		cout<<arg_1<<"\n";
	}
	else if(op >= IF_LESS && op <= IF_NOT_EXPRESSION)
	{
		cout<<"if "<<arg_1<<" ";
		switch(op)
		{
			case IF_LESS:
				cout<<"<";
				break;

			case IF_GREATER:
				cout<<">";
				break;
			case IF_LESS_EQUAL:
				cout<<"<=";
				break;
			case IF_GREATER_EQUAL:
				cout<<">=";
				break;
			case IF_IS_EQUAL:
				cout<<"==";
				break;
			case IF_NOT_EQUAL:
				cout<<"!=";
				break;
			case IF_EXPRESSION:
				cout<<"!= 0";
				break;
			case IF_NOT_EXPRESSION:
				cout<<"== 0";
				break;
		}
		cout<<arg_2<<" goto "<<result<<"\n";
	}
	else if(op == GOTO)
	{
		cout<<"goto "<<result<<"\n";
	}
	else if (op == COPY)
	{
		cout<<result<<" = "<<arg_1<<"\n";
	}
	else if (op == ARRAY_ACCESS)
	{
		cout<<result<<" = "<<arg_1<<"["<<arg_2<<"]\n";
	}
	else if (op == ARRAY_DEREFERENCE)
	{
		cout<<result<<"["<<arg_2<<"] = "<<arg_1<<"\n";
	}
	else if (op == REFERENCE)
	{
		cout<<result<<"= &"<<arg_1<<"\n";
	}
	else if (op == DEREFERENCE)
	{
		cout<<result<<"= *"<<arg_1<<"\n";
	}
	else if(op == CALL)
	{
		cout<<"call "<<result<<" "<<arg_1<<"\n";
	}
	else if (op == PARAM)
	{
		cout<<"param "<<result<<"\n";
	}
	else if (op == RETURN)
	{
		cout<<"return "<<result<<"\n";
	}
	else if (op == RETURN_VOID)
	{
		cout<<"return\n";
	}
	else if (op >= C2I && op <= D2I)
	{
		cout<<result<<" = ";
		switch(op)
		{
			case C2I : 
				cout<<" Char2Int(" <<arg_1<<")" <<endl; 
				break;
            case C2D : 
            	cout<<" Char2Double(" <<arg_1<<")" <<endl; 
            	break;
            case I2C : 
            	cout<<" Int2Char("<<arg_1<<")"<<endl; 
            	break;
            case D2C : 
            	cout<<" Double2Char("<<arg_1<<")"<<endl; 
            	break;
            case I2D : 
            	cout<<" Int2Double("<<arg_1<<")"<<endl; 
            	break;
            case D2I : 
            	cout<<" Double2Int("<<arg_1<<")"<<endl; 
            	break;
		}
	}
	else if (op == _FUNCTION_START)
	{
		cout<<"function "<<result<<" start\n";
	}
	else if (op == _FUNCTION_END)
	{
		cout<<"function "<<result<<" end\n";
	}
}

void Quad_Array :: emit(opcodeType op, string result, string arg_1, string arg_2)
{
	Quad q;
	//copy the opcodes, result, argument1 and argument 2 to the quad q
	q.op = op;
	q.result = result;
	q.arg_1 = arg_1;	//check these
	q.arg_2 = arg_2;
	//pushback the quad q to the array of quads
	arr.push_back(q);
	//after emit gets completed, increment global quad_array index pointer
	index++;
}

void Quad_Array :: emit(opcodeType op, string result, int num)
{
	Quad q;
	q.op = op;
	q.result = result;
	string s = to_string(num);
	q.arg_1 = s;
	arr.push_back(q);
	index++;
}

void Quad_Array :: emit(opcodeType op, string result, double double_num)
{
	Quad q;
	q.op = op;
	q.result = result;
	string s = to_string(double_num);
	q.arg_1 = s;
	arr.push_back(q);
	index++;
}

void Quad_Array :: emit(opcodeType op, string result, char char_const)
{
	Quad q;
	q.op = op;
	q.result = result;
	string s = "";
	s = s + char_const;
	q.arg_1 = s;
	arr.push_back(q);
	index++;
}

void Quad_Array :: backpatch(list<int> bp_list, int i)
{
	string s = to_string(i);
	list<int>::iterator it;
	for(it = bp_list.begin(); it != bp_list.end(); it++)
	{
		arr[*it].result = s; 
	}
}

//type conversions
void Quad_Array :: convD2I(exp_attr * e1, exp_attr *e2)
{
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	if(e2->type.type_name.compare("int")==0)
		return;
	else
	{
		e1 = e2;
		e1->type.type_name = "int";
		emit(D2I, e1->loc, e2->loc, "");
	}
}

void Quad_Array :: convD2C(exp_attr * e1, exp_attr *e2)
{
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	if(e2->type.type_name.compare("char")==0)
		return;
	else
	{
		e1 = e2;
		e1->type.type_name = "char";
		emit(D2C, e1->loc, e2->loc, "");
	}
}

void Quad_Array :: convI2D(exp_attr * e1, exp_attr *e2)
{
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	if(e2->type.type_name.compare("double")==0)
		return;
	else
	{
		e1 = e2;
		e1->type.type_name = "double";
		emit(I2D, e1->loc, e2->loc, "");
	}
}

void Quad_Array :: convI2C(exp_attr * e1, exp_attr *e2)
{
	if(e2->type.type_name.compare("char")==0)
		return;
	else
	{
		e1 = e2;
		e1->type.type_name = "char";
		emit(I2C, e1->loc, e2->loc, "");
	}
}

void Quad_Array :: convC2D(exp_attr * e1, exp_attr *e2)
{
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	if(e2->type.type_name.compare("double")==0)
		return;
	else
	{
		e1 = e2;
		e1->type.type_name = "double";
		emit(C2D, e1->loc, e2->loc, "");
	}
}

void Quad_Array :: convC2I(exp_attr * e1, exp_attr *e2)
{
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	if(e2->type.type_name.compare("int")==0)
		return;
	else
	{
		e1 = e2;
		e1->type.type_name = "int";
		emit(C2I, e1->loc, e2->loc, "");
	}
}


void Quad_Array :: convInt2Bool(exp_attr *exp)
{
	long long int pxx,qxxx;
	type_inf bool_type;
	bool_type.type_name = "bool";
	if(exp->type.type_name.compare("bool")==0)
		return;
	else
	{
		backpatch(exp->truelist, index);
		backpatch(exp->falselist,index);
		exp->falselist = makelist(index);
		emit(IF_NOT_EXPRESSION,"",exp->loc,"");
		//emit(COPY, exp->loc, "~1","");
		exp->truelist = makelist(index);
		emit(GOTO,"","","");
	}
	exp->type.type_name = "bool";

}


symtab* symboltable :: lookup(string s, string type, int pc)
{
	symtab *sp;
	for(sp = sym_table; sp < &sym_table[MAX]; sp++)
	{
		//cout<<s<<"\n";
		if(!sp->id.empty() && !sp->id.compare(s))
		{
			return sp;
		}
		if(sp->id.empty())
		{
			sp = new symtab;
			sp->id = s;
			//include type
			type_inf t;
			
			t.type_name = type;
			int t_size = 0;
			if(pc == 0)
			{
				if(type.compare("int") == 0)
					t_size = 4;
				else if(type.compare("double") == 0)
					t_size = 8;
				else if(type.compare("char") == 0)
					t_size = 1;
				else if(type.compare("function")==0 || type.compare("void")==0)
					t_size = 0;
				t.size = t_size;
				sp->type = t;
				sp->size = t_size;
				sp->offset = offset;
				sp->init_val = NULL;
				offset = offset + t_size;
				
				sym_table[no_of_entries] = *sp;
				no_of_entries++;
				break;
			}
			else if(pc>0)
			{
				sp->size = 8;
				sp->type.type_name = type;
				cout<<type<<"\n";
				sp->pointer_count = pc;
				sp->offset = offset;
				sp->init_val = NULL;
				
				offset = offset + 8;
				sym_table[no_of_entries] = *sp;
				no_of_entries++;
				break;
			}
			int countss=100;
			for(int posss=1;posss<=10;posss++)
				countss--;			
		}
	}
	return sp;
}

string symboltable :: gentemp(type_inf type)
{
	//maintain counts generated
	static int temporary_count = 0;
	string s = "t";
	s = s + to_string(temporary_count);
	temporary_count++;
	//id
	//lookup(s, type.type_name);
	sym_table[no_of_entries].id = s;
	//type
	sym_table[no_of_entries].type = type;
	//size
	int t_size = 0;
	if(type.type_name.compare("int") == 0)
		t_size = 4;
	else if(type.type_name.compare("double") == 0)
		t_size = 8;
	else if(type.type_name.compare("char") == 0)
		t_size = 1;
	else if(type.type_name.compare("function")==0 || type.type_name.compare("void")==0)
		t_size = 0;
	if(type.pointer_type.compare("ptr")==0)
	{
		t_size = 8;
	}
	sym_table[no_of_entries].size = t_size;
	//initial value
	sym_table[no_of_entries].init_val = NULL;
	//offset
	sym_table[no_of_entries].offset = offset;
	sym_table[no_of_entries].nested_table = NULL;
	offset = offset + t_size;
	
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	no_of_entries++;
	return s;
}

void symboltable:: print()
{
	int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
	int i;
	cout<<"Name\tType\tSize\tOffset\tInitVal\n";
	cout<<"---------------------------------------\n";
	for(i=0;i<no_of_entries;i++)
	{
		int flag = 0;
		cout<<sym_table[i].id<<"\t";
		if(sym_table[i].pointer_count == 0 && sym_table[i].type.array_type.compare("array")!=0)
		{
			if(sym_table[i].type.type_name.compare("int")==0)
				cout<<"int\t";
			else if(sym_table[i].type.type_name.compare("char")==0)
				cout<<"char\t";
			else if(sym_table[i].type.type_name.compare("double")==0)
				cout<<"double\t";
			else if(sym_table[i].type.type_name.compare("void")==0)
				cout<<"void\t";
			else if(sym_table[i].type.type_name.compare("function")==0)
				{cout<<"function\t";cout<<sym_table[i].type.no_of_params<<"\t";}
		}
		else if(sym_table[i].type.pointer_type.compare("ptr")==0)
		{
			sym_table[i].size = 8;
			//cout<<sym_table[i].type.type_name<<" ";
			for (int j = 0; j < sym_table[i].pointer_count; ++j)
			{
				cout<<"*";
			}
			cout<<"\t";
		}
		
		else if(sym_table[i].type.array_type.compare("array")==0)
		{
			cout<<sym_table[i].type.type_name;
			//cout<<"array:";cout<<sym_table[i].type.type_name<<" ";
			if(sym_table[i].type.idx!=0 && sym_table[i].type.type_name!="")
				{cout<<" ["<<sym_table[i].type.idx<<"]";flag = 1;}
			else
				for (int j = 0; j < sym_table[i].type.array_list.size(); ++j)
				{
					cout<<"["<<sym_table[i].type.array_list[j]<<"]";
				}
			cout<<"\t";
		}
		if(flag==1) 
			{cout<<"\t"<<sym_table[i].size*sym_table[i].type.idx<<"\t";sym_table[i].size = sym_table[i].size*sym_table[i].type.idx;}
		if(flag==0)
			cout<<"\t"<<sym_table[i].size<<"\t";
                if(i>=1)
		    sym_table[i].offset = sym_table[i-1].offset + sym_table[i-1].size;
		cout<<sym_table[i].offset<<"\t";

		if(sym_table[i].init_val == NULL)
			cout<<"NULL";
		else
		{
			if(sym_table[i].type.type_name.compare("int")==0)
			{
				cout<<sym_table[i].init_val->int_val;
			}
			if(sym_table[i].type.type_name.compare("char")==0)
			{
				cout<<sym_table[i].init_val->char_val;
			}
			if(sym_table[i].type.type_name.compare("double")==0)
			{
				cout<<sym_table[i].init_val->double_val;
			}
		}
		cout<<"\n";
		int countss=100;
		for(int posss=1;posss<=10;posss++)
			countss--;	
	}
}
list<int> makelist(int index)
{
    list<int> temp;
    temp.push_back(index);
    int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
    return temp;
}

list<int> merge(list<int> a, list<int> b)
{
    list<int> temp;
    temp.merge(a);
    temp.merge(b);
    int countss=100;
	for(int posss=1;posss<=10;posss++)
		countss--;
    return temp;
}


