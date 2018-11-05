// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6

#include "ass6_16CS30012_translator.h"

extern Quad_Array Q_arr;
extern symboltable GT;
extern symboltable *sym;
extern symboltable *curr_sym;
extern type_inf *global_type;
extern int global_width;
extern vector<string> string_lits;
extern int yyparse();

void Code_Generator:: handle_strings()
{
	//handle global string literals
    int global_string_count = 0;

    cout<<"\t.section\t.rodata\n";

    for(vector<string>::iterator it = string_lits.begin(); it != string_lits.end(); it++)
    {
        cout<<global_string_start<<global_string_count++<<":\n";
        cout<<"\t.string "<<*it<<"\n";
    }
    
}

void Code_Generator:: create_Function_Prologue()
{
    int countss=100;
    int tempppp;
    for(int i=0;i<100;i++)
        countss++;
    stack_req = ((stack_size>>4)+1)<<4; //align with word boundary

    cout<<"\t.globl\t"<<function_name<<"\n";	//create a global function
    cout<<"\t.type\t"<<function_name<<", @function\n";	//declare that the function is a function
    cout<<function_name<<":\n";
    //cout<<".cfi_startproc\n";
    cout<<"\tpushq\t%rbp\n";
    cout<<"\tmovq\t%rsp, %rbp\n";
    cout<<"\tsubq\t$"<<stack_req<<",\t%rsp\n";	//allocate stack for local variables
}

void Code_Generator:: create_Function_Epilogue()
{
    //cout << "\t" << "leave" <<endl;
    cout << "\t" << "ret"<<endl;
   // cout<<"\t.cfi_endproc\n";
    //cout << "\t.size\t"<<it->result<<",\t.-"<<it->result<<endl;
}

void Code_Generator:: handle_Globals()
{
    symtab *p;
    int i;
    for(i = 0 ; i < (&GT)->no_of_entries; i++)
    {
        if((&GT)->sym_table[i].id[0] != 't')
        {
            //handle chars
            if((&GT)->sym_table[i].type.type_name.compare("char")==0)
            {
                if((&GT)->sym_table[i].init_val == NULL)
                    cout<<"\tcomm\t"<<(&GT)->sym_table[i].id<<",1,1\n";
                else
                {
                    cout << "\t.globl\t"<<(&GT)->sym_table[i].id<<"\n";
                    cout << "\t.data"<<endl;
                    cout << "\t.type\t"<<(&GT)->sym_table[i].id<<", @object"<<"\n";
                    cout << "\t.size\t"<<(&GT)->sym_table[i].id<<", 1"<<"\n";
                    cout << (&GT)->sym_table[i].id<< ":" << "\n";
                    cout << "\t.byte\t"<<(&GT)->sym_table[i].init_val->int_val<<"\n";
                }
            }
		//handle int
	    if((&GT)->sym_table[i].type.type_name.compare("int")==0)
            {
                if((&GT)->sym_table[i].init_val == NULL)
                    cout<<"\tcomm\t"<<(&GT)->sym_table[i].id<<",4,4\n";
                else
                {
                    cout << "\t.globl\t"<<(&GT)->sym_table[i].id<<"\n";
                    cout << "\t.data"<<endl;
                    cout << "\t.align 4"<<endl;
                    cout << "\t.type\t"<<(&GT)->sym_table[i].id<<", @object"<<"\n";
                    cout << "\t.size\t"<<(&GT)->sym_table[i].id<<", 4"<<"\n";
                    cout << (&GT)->sym_table[i].id<< ":" << "\n";
                    cout << "\t.long\t"<<(&GT)->sym_table[i].init_val->int_val<<"\n";
                }
            }

        }
     
    }
}

string Code_Generator:: generate_GOTO_Labels()
{
    string t = ".L";
    t = t + to_string(goto_label_count);
    goto_label_count++;
    return t;
}

void Code_Generator:: set_GOTO_Labels_target()
{
    int countss=100;
    int tempppp;
    for(int i=0;i<100;i++)
        countss++;
    for(vector<Quad>::iterator it = Q_arr.arr.begin(); it != Q_arr.arr.end(); it++)
    {
        if(it->op >= IF_LESS && it->op <= GOTO)
        {
            int backpatch_result = atoi(((*it).result).c_str());
            if(generate_goto.count(backpatch_result)==0)
            {
                string label = generate_GOTO_Labels();
                generate_goto[backpatch_result] = label;
            }
            (*it).result = generate_goto[backpatch_result];
        }
    }
}


void Code_Generator:: Map_TAC_to_Assembly()
{
    int countss=100;
    int tempppp;
    for(int i=0;i<100;i++)
        countss++;
    int arg1_binding, arg2_binding, result_binding;
    arg1_binding = arg2_binding = result_binding = 0;   //make quad argument bindings

    symtab *global_arg1, *global_arg2, *global_result;    

    symtab* curr_arg1 ;
    curr_arg1 = curr_sym->lookup(current_quad.arg_1);
    symtab* curr_arg2 ;
    curr_arg2= curr_sym->lookup(current_quad.arg_2);
    symtab* curr_result;
    curr_result = curr_sym->lookup(current_quad.result); //All are present in symboltable, so lookup will handle it fine
    
    global_arg1 = NULL;
    global_arg2 = NULL;
    global_result = NULL;
   
    for(int j = 0; j < (&GT)->no_of_entries; j++)
    {
        if((&GT)->sym_table[j].id.compare(current_quad.arg_1)==0)
            global_arg1 = &((&GT)->sym_table[j]);
        
    }
    
    for(int j = 0; j < (&GT)->no_of_entries; j++)
    {
        if((&GT)->sym_table[j].id.compare(current_quad.arg_2)==0)
            global_arg2 = &((&GT)->sym_table[j]);
    }
    
    for(int j = 0; j < (&GT)->no_of_entries; j++)
    {
        if((&GT)->sym_table[j].id.compare(current_quad.result)==0)
            global_result = &((&GT)->sym_table[j]);
        else 
        global_result = NULL;
    }
    
    
     

    string generator_arg1 = empty_string;
    string generator_arg2 = empty_string;
    string generator_result = empty_string;

    if(current_quad.result[0] <= '0' || current_quad.result[0] >= '9')
    {
        if(global_result == NULL)
        {
            result_binding = curr_result->offset;
            //cout<<result_binding<<"\n";
	    string bind = to_string(result_binding);
            generator_result = bind + "(%rbp)";
        }
        else
            generator_result = current_quad.result;
    }
    

    if(current_quad.arg_1[0] <= '0' || current_quad.arg_1[0] >= '9')
    {
        if(global_arg1 == NULL)
        {
            arg1_binding = curr_arg1->offset;
	    string bind = to_string(arg1_binding);
            generator_arg1 = bind + "(%rbp)";
            //cout<<arg1_binding<<"\n";
        }
        else
	{
	    if(global_arg1->type.type_name.compare("function")==0)
	    {
		func_type = 1;		//handle functions, particularly the library functions which were created
	    }
	    else
                {generator_arg1 = current_quad.arg_1;}
	}

    }            

        if(current_quad.arg_2[0] <= '0' || current_quad.arg_2[0] >= '9')
        {
        if(global_arg2 == NULL)
        {
            arg2_binding = curr_arg2->offset;
	    string bind = to_string(arg2_binding);
            generator_arg2 = bind + "(%rbp)";
        }
        else
	{
	    //cout<<"#--"<<global_arg2->type.type_name<<endl;

	    generator_arg2 = current_quad.arg_2;
	    
	}
            
    }            

    //start with the operations
    
    if(current_quad.op == UNARY_MINUS)
    {
        int countss=100;
        int tempppp;
        for(int i=0;i<100;i++)
            countss++;
        cout << "\t" << "movq" << "\t" <<generator_arg1<< ",\t%rax" << endl; 
        cout << "\t" << "negq\t %rax"<< endl;
        cout << "\t" << "movq" << "\t" << "%rax,\t" << generator_result << "\t"  << endl; 
    }

    else if(current_quad.op == COPY)
    {
	/*if(ptr_type == 1)
	{
		if(current_quad.arg_1[0]>='0' && current_quad.arg_1[0]<='9')
		{
		    cout<<"\tmovq\t$"<<current_quad.arg_1<<",\t"<<generator_result<<"\n";
		}

		else
		{
		    cout << "\t" << "movq" << "\t" <<generator_arg1 << ",\t%rax" << endl; 
		    cout << "\t" << "movq" << "\t" << "%rax,\t" << generator_result << "\t"  << endl; 
		}
	
	}*/
	if(func_type==1)
	{
	    //cout<<"\tmovq\t%rax,\t%rdx\n";
	    cout<<"\tmovl\t%eax,\t"<<generator_result<<endl;
	    func_type = 0;
	    
	}
	else
	{
		if(current_quad.arg_1[0]>='0' && current_quad.arg_1[0]<='9')
		{
		    cout<<"\tmovl\t$"<<current_quad.arg_1<<",\t"<<generator_result<<"\n";
		}

		else
		{
		    cout<<"\tmovl\t"<<generator_arg1<<",\t%eax\n"; 
		    cout<<"\tmovl\t"<<"%eax,\t"<<generator_result<<"\n"; 
		}
	}
    }

    else if(current_quad.op == PLUS)
    {
        if((current_quad.arg_2.compare("1"))==0)
        {//result = a + 1
            cout<< "\tmovl\t" <<generator_arg1<<",\t%edx\n";
            cout<< "\taddl\t$1,\t%edx\n";
            cout<< "\tmovl\t%edx,\t%eax\n";
            cout<< "\tmovl\t%eax,\t"<< generator_result<<"\n";
        }
        else
        {
            //result = a + b
            cout<<"\tmovl\t" <<generator_arg1<<",\t%edx\n";
            if(current_quad.arg_2[0]>='0' && current_quad.arg_2[0]<='9')
                cout<<"\tmovl\t$" <<current_quad.arg_2<<",\t%eax\n";
            else
                cout << "\tmovl\t" <<generator_arg2 << ",\t%eax\n";
            cout<<"\taddl\t %edx,\t%eax\n";
            cout<<"\tmovl\t %eax,\t"<<generator_result<<"\n";     
        }

    }

    else if(current_quad.op == MINUS)
    {
        if((current_quad.arg_2).compare("1")==0)
        {
	    //result = a + 1
            cout << "\tmovl\t" <<generator_arg1<< ",\t%edx\n";
            cout << "\tsubl\t$1,\t %edx\n";
            cout << "\tmovl\t %edx,\t %eax\n";
            cout << "\tmovl \t %eax,\t"  << generator_result<< "\n";
        }
        else
        {
            //result = a - b

            cout<< "\tmovl\t" <<generator_arg1<< ",\t%edx\n";
            cout<< "\tmovl\t" <<generator_arg2 << ",\t%eax\n";
            cout<< "\tsubl\t%eax,\t%edx\n";
            cout<< "\tmovl\t%edx,\t%eax\n";
            cout<< "\tmovl \t%eax,\t" << generator_result<<"\n";       
        }
        int countss=100;
        int tempppp;
        for(int i=0;i<100;i++)
            countss++;

    }

    else if(current_quad.op==MULT)
    {
        
        cout<< "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        if(current_quad.arg_2[0]>='0' && current_quad.arg_2[0]<='9')
            cout<< "\timull\t$" << current_quad.arg_2 << ",%eax\n";
        else
        {
            cout<< "\timull\t" <<generator_arg2 << ",%eax\n";
        }
        cout<< "\tmovl\t%eax,\t"<< generator_result<< "\n";           
        
    }

    else if(current_quad.op==DIVIDE)
    {
        cout << "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        cout << "\tcltd\n";
        cout << "\tidivl\t"<< generator_arg2 << "\n";
        cout << "\tmovl\t%eax,\t" << generator_result<< "\n";       
        
    }
    else if(current_quad.op==MODULO)
    {
        cout << "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        cout << "\tcltd\n";
        cout << "\tidivl\t"<< generator_arg2 << "\n";
        cout << "\tmovl\t%edx,\t"  << generator_result << "\n";          
        
    }

    
    else if(current_quad.op==IF_LESS)
    {
        
        cout << "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        cout << "\tcmpl\t" <<generator_arg2 << ",\t%eax\n";
        cout << "\tjge\t.L" << goto_label_count <<"\n";
        cout << "\tjmp\t" <<current_quad.result <<"\n";
        cout << ".L" << goto_label_count  << ":\n";
        goto_label_count = goto_label_count + 1;

    }

    else if(current_quad.op==IF_GREATER)
    {
        //  if a > b goto .L1
        cout<< "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        cout<< "\tcmpl\t" <<generator_arg2 << ",\t%eax\n";
	//jump on less
        cout<< "\tjle\t.L" << goto_label_count << "\n";
        cout<< "\tjmp\t" <<current_quad.result << "\n";
        cout<< ".L"<< goto_label_count  << ":\n";
        goto_label_count = goto_label_count + 1;

    }

    else if(current_quad.op==IF_IS_EQUAL)
    {
        //  if a == b goto L1
        
        cout << "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        cout << "\tcmpl\t" <<generator_arg2 << ",\t%eax\n";
        cout << "\tjne\t.L" << goto_label_count << "\n";
        cout << "\tjmp\t" <<current_quad.result << "\n";
        cout << ".L" << goto_label_count  << ":\n";
        goto_label_count = goto_label_count + 1;

    }

    else if(current_quad.op==IF_NOT_EQUAL)
    {
        //  if a != b goto .L1
        
        cout << "\tmovl\t" <<generator_arg1 << ",\t%eax\n";
        cout << "\tcmpl\t" <<generator_arg2 << ",\t%eax\n";
        cout << "\tje\t.L" << goto_label_count << "\n";
        cout << "\tjmp\t" <<current_quad.result << "\n";
        cout << ".L" << goto_label_count  << ":\n";
        goto_label_count = goto_label_count + 1;

    }
    
    else if(current_quad.op==IF_NOT_EXPRESSION)
    {
	//if a==0 goto .L1
        cout<< "\tcmpl\t$0,\t"<<generator_arg1<< "\n"; 
        cout<< "\tjne\t.L"<< goto_label_count<<"\n"; 
        cout<< "\tjmp\t"<<current_quad.result<<endl;
        cout<< ".L"<<goto_label_count<<" : \n";  
        goto_label_count = goto_label_count + 1;     
    }

    else if(current_quad.op==IF_EXPRESSION)
    {  
	//if a!= 0 goto .L1
        cout<< "\tcmpl\t$0,\t"<<generator_arg1<< endl; 
        cout<< "\tje\t.L"<< goto_label_count<<endl; 
        cout<< "\tjmp\t"<<current_quad.result<<endl;
        cout<< ".L" <<goto_label_count<<" : \n" ;  
        goto_label_count++;
    }

  
    else if(current_quad.op==GOTO)
    {
        //goto .L1
        cout<<"\tjmp\t" <<current_quad.result<<"\n";
    }


    else if(current_quad.op == PARAM)
    {
	//cout<<"#--"<<next_quad.result<<endl;
        if(next_quad.result.compare("printi")==0 || next_quad.result.compare("prints")==0 || next_quad.result.compare("readi")==0)
	{
	    if(current_quad.result[0]=='.')
	    {
		cout<<"\tmovq\t$"<<current_quad.result<<",\t%rdi\n";
	    }
	    else if(current_quad.result[0]>='0' && current_quad.result[0]<='9')
                cout<<"\tmovq\t$"<<current_quad.result<<",\t%rdi\n";
            else
                cout<<"\tmovq\t"<<generator_result<<",\t%rdi\n";
            no_of_params++;
	}
	else
	{
	     string s;
             std::vector<string> str1;
	     int flag = 0;

             if(current_quad.result[0]>='0' && current_quad.result[0]<='9')
             {
                s = s + "\tmovq\t$" + current_quad.result + ",\t%rax\n";
             }
             else{
		 flag = 0;
		 for(int i=0;i<new_sym->no_of_entries;i++)
		 {
		     if(current_quad.result.compare(new_sym->sym_table[i].id)==0 && new_sym->sym_table[i].type.array_type.compare("array")==0)
		     {
			//flag = 0;
		     	if(result_binding>0)
				{s = s + "\tmovq\t" + generator_result + ",\t%rax\n";flag = 1;}
			else
				{s = s + "\tleaq\t" + generator_result + ",\t%rax\n";flag = 1;}
		     }
		      
			//s = s + "\tmovq\t" + generator_result + ",\t%rax\n";
		 }
		 if(flag == 0)
                 	s = s + "\tmovq\t" + generator_result + ",\t%rax\n";
        	 str1.push_back(s);
        	 str1.push_back("\tpushq\t%rax\n");
        	 stack_of_parameters.push(str1);
	  
	    }
	}
    }

    else if(current_quad.op==CALL)
    {
	if(current_quad.result.compare("printi")==0 || current_quad.result.compare("prints")==0 || current_quad.result.compare("readi")==0)
	{
	   int num;
           num = atoi((current_quad.arg_1).c_str());
           num=num*4;
           cout << "\t" << "call\t"<<current_quad.result << endl;
           //cout << "\t" << "addq\t$"<<num<<",\t%rsp"<< endl;
           if(current_quad.arg_2 != "")
               cout << "\t" << "movq\t%rax,\t"<<generator_arg2<< endl;

	}
	else{
	int num;
        num = atoi((current_quad.arg_1).c_str());
        num=num*8;
        while(stack_of_parameters.size() > 0)
        {
            vector<string> str; 
            str = stack_of_parameters.top();
            for(int i = 0; i<str.size(); i++)
            {
                cout<<str[i];
            }
	    stack_of_parameters.pop();    //pop from stack
        }
        
        cout << "\tcall\t"<<current_quad.result << "\n";
        cout << "\taddq\t$"<<num<<",\t%rsp"<< "\n";
	cout<<"#--"<<current_quad.arg_2<<"\n";
          //          cout << "\t" << "movq\t%rax,\t"<<generator_arg2<< endl;
	}

    }

    else if(current_quad.op==RETURN)
    {
        if(current_quad.result.compare(empty_string)!=0)
        	cout<<"\tmovq\t"<<generator_result<< ",\t%rax"<< endl;
	cout <<"\tleave\n\tret\n";
	    //function_name = empty_string;
	no_of_params = 0;
	  /*  memory = 16;
	    memory_bind_ebp = 0;*/
            
    }

    else if(current_quad.op==DEREFERENCE)
    {
        // a = *p
        cout<<"\tmovq\t"<<generator_arg1<<",\t%rax\n";
        cout<<"\tmovl\t(%rax),\t %ecx\n";
        cout<<"\tmovl\t%ecx,\t"<<generator_result<<"\n";
    }

    else if(current_quad.op==REFERENCE)
    {
        //p = &a
        cout<<"\tleaq\t"<<generator_arg1<<",\t%rax\n";
        cout<<"\tmovq\t%rax,\t"<<generator_result<<"\n";
    }


    
    else if(current_quad.op==ARRAY_ACCESS)
    {
        //b = a[i]
	if(arg1_binding>0)		//required for passing array as parameters
	{
		cout<<"\tmovslq\t"<<generator_arg2<<",\t%rdx\n";
		cout<<"\tmovq\t"<<arg1_binding<<"(%rbp),\t%rdi\n";
		cout<<"\taddq\t%rdi,\t%rdx\n";
		cout<<"\tmovl\t(%rdx),\t%eax\n";
		cout<<"\tmovl\t%eax,\t"<<generator_result<<"\n";
	}
	else
	{
		cout<<"\tmovslq\t"<<generator_arg2<<",\t%rdx"<< endl;
		cout<<"\tmovl\t"<<arg1_binding<<"(%rbp,%rdx,1),\t%eax\n";
		cout<<"\tmovl\t%eax,\t"<<generator_result<<"\n";
	} 
    }

    else if(current_quad.op==ARRAY_DEREFERENCE)
    {
        //a[i] = b
	if(result_binding>0)		//required for passing array as parameters
	{
		cout<<"\tmovslq\t"<<generator_arg2<<",\t%rdx\n";
		cout<<"\tmovl\t"<<generator_arg1<<",\t%eax\n";
		cout<<"\tmovq\t"<<result_binding<<"(%rbp),\t%rdi\n";
		cout<<"\taddq\t%rdi,\t%rdx\n";
		
		cout<<"\tmovl\t%eax,\t(%rdx)\n";
	}
	else{
        cout<<"\tmovslq\t"<<generator_arg2<<",\t%rdx\n";
        cout<<"\tmovslq\t"<<generator_arg1<<",\t%rax\n";
        cout<<"\tmovq\t%rax,\t"<<result_binding<<"(%rbp,%rdx,1)\n";}
    }

    

}

void Code_Generator:: Bind_Memory_Record()
{
    
    handle_strings();
    handle_Globals();
    set_GOTO_Labels_target();

    int quad_size = Q_arr.arr.size();
    for(int i = 0; i < quad_size; i++)
    {
	//print the quads for reference
	cout<<"  # "; Q_arr.arr[i].print();
        
        if(generate_goto.count(i)>0)
        {
            cout<<generate_goto[i]<<":\n";
        }
        current_quad = Q_arr.arr[i];	//update current quad
	if(i<quad_size-1)
		next_quad = Q_arr.arr[i+1];	//update next quad
        //cout<<current_quad.arg_1<<"\n";
        if(Q_arr.arr[i].op == _FUNCTION_START)
        {
            if(Q_arr.arr[i+1].op != _FUNCTION_END)
            {
		ptr_type=0;
                symtab *p=NULL;
                for(int j = 0; j < (&GT)->no_of_entries; j++)
                {
                    //cout<<j<<": ";
                    //cout<<(&GT)->sym_table[j].id<<"\n";
                    if(((&GT)->sym_table[j].id).compare(Q_arr.arr[i].result)==0)
                        p = &((&GT)->sym_table[j]);
                }
                
                function_name = Q_arr.arr[i].result;
                row = p;
		
                //new_sym = curr_sym;
                //if(p!=NULL)
                new_sym = p->nested_table;
                curr_sym = new_sym;
                flag_parameter = 1;
                int total_count; 
                total_count =  row->type.no_of_params;
                //if (p==NULL)
                //    cout<<"1\n";
		for(int j = 0; j < total_count; j++)
		{
		    new_sym->sym_table[j].offset = memory;
		    memory = memory + 8;
		    cout<<"#--param_offset:"<<memory<<"\n";
		}
		//cout<<"#--total:"<<total_count<<"\n";
		memory_bind_ebp = 0;
                for(int j = total_count; j < new_sym->no_of_entries; j++)
                {
		    if(new_sym->sym_table[j].id.compare("retVal")==0)
		    {
			//new_sym->sym_table[j].size = 4;
		    }
                    if(new_sym->sym_table[j].id.compare("retVal"))
                    {
                        memory_bind_ebp = memory_bind_ebp - new_sym->sym_table[j].size;
                        new_sym->sym_table[j].offset = memory_bind_ebp;
			cout<<"#--loacl var offset: "<<new_sym->sym_table[j].size<<" "<<new_sym->sym_table[j].offset<<"\n";
                    }
                }
                cout<<"#"<<memory_bind_ebp<<endl;
                stack_size = memory_bind_ebp*(-1) + memory;
		for(int j = 0; j< new_sym->no_of_entries; j++)
		{
			if(new_sym->sym_table[j].id.compare(current_quad.result)==0||!new_sym->sym_table[j].id.compare(current_quad.arg_1)==0
                       ||!new_sym->sym_table[j].id.compare(current_quad.arg_2)==0)
			{
				if(new_sym->sym_table[j].type.pointer_type.compare("ptr")==0)
					ptr_type = 1;
				cout<<"##ptr"<<new_sym->sym_table[j].id<<endl;
			}
		}
                create_Function_Prologue();
            }
            else
            {
                i++;
		no_of_params = 0;
		memory = 16;
		memory_bind_ebp = 0;
                continue;
            }
        }
        else if(Q_arr.arr[i].op == _FUNCTION_END)
        {
            sym = &GT;
            curr_sym = &GT;
	    cout<<"\tleave\n\tret\n";
            cout << "\t.size\t"<<function_name<<",\t.-"<<function_name<<endl;
	    function_name = "";
            no_of_params = 0;
	    memory = 16;
	    memory_bind_ebp = 0;
	    continue;
        }

        if(function_name.compare(empty_string))
        {
            Map_TAC_to_Assembly();
        }

    }
}


int main(int argc, char *argv[])
{   
    int countss=100;
    int tempppp;
    for(int i=0;i<100;i++)
        countss++;
    bool failure = yyparse();
    int arr_size = Q_arr.arr.size();
    
    string output_file = "a.out";
    if(argc==2) output_file = string(argv[1]);
    string quad_file = "ass6_16CS30012_quads" + output_file + ".out";
    ofstream outf1(quad_file.c_str());
    streambuf *coutbuf1 = cout.rdbuf();
    cout.rdbuf(outf1.rdbuf());
    
    //freopen(argv[2],"w",stdout);
    cout<<"********************Here are all Quads**********************\n";
    cout<<"--------------------------------------------------------\n";
    cout<<"*********************Quads******************************\n";
    for(int i = 0; i<arr_size;i++)
    {
        cout<<i<<" : "; 
        Q_arr.arr[i].print();
    }

    cout<<"\n----------------SYMBOL TABLE (ST.gbl)-----------------------\n";
    symboltable *g = &GT;
    g->print();
    cout<<"----------------------------------------------------\n";
    //cout<<g->no_of_entries<<endl;

    for(int i = 0; i< g->no_of_entries; i++)
    {
        if(g->sym_table[i].nested_table != NULL)
        {
            cout<<"----------------SYMBOL TABLE of "<<g->sym_table[i].id<<"----------------"<<endl;
            g->sym_table[i].nested_table->print();
            cout<<"--------------------------------------------"<<endl;
        }
    }
    cout<<"----------------Compilation Result------------------\n";
    if(failure != 0)
        printf("Compilation Failure\n");
    else
        printf("Compilation Success\n");
    cout<<"*****************************************************\n";
    
    cout.rdbuf(coutbuf1);

    string tmp = "ass6_16CS30012_" + output_file + ".s";
    ofstream outfile(tmp.c_str());
    streambuf *coutbuf = cout.rdbuf();
    cout.rdbuf(outfile.rdbuf());
    curr_sym = sym;
    Code_Generator c;
    c.Bind_Memory_Record();
    
    cout.rdbuf(coutbuf);
    return 0;

}

