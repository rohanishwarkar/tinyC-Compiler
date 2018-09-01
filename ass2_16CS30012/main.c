// *********************************************************************************************************************
// Ishwarkar Rohan Shankar
// 16CS30012
// Compilers Assignment 2 
// Date:- 31/07/2018



// The only header file included in the program
#include "myl.h"

// The main function to test the other functions
int main(){

	float ff;
	int choice,integer; 
    while(1){
    	printStr("\n Here is the list of functions. Choose any!");
		// int printStr(char *);
		// int readInt(int *);
        printStr("\n1.Read Integer\n");
        // int printInt(int);
        printStr("2.Print integer\n");
        // int readFlt(float *);
        printStr("3.Read Float\n");
        // int printFlt(float);
        printStr("4.Print Float\n");
        // Exit if no function is required
        printStr("5.Exit\n");
        // Print the below statement
        printStr("Enter choice:");
        if(readInt(&choice)==ERR){
                printStr("Invalid choice, re-enter: ");
                continue;
        }
        if(choice==5)break;
        switch(choice){
                case 1:printStr("Enter int: ");
                       if(readInt(&integer)==ERR)printStr("ERR The integer is not valid.\n");
                       else printStr("Integer read.\n");
                       break;
                case 2:printInt(integer);
                       break;
                case 3:printStr("Enter float: \n");
                       if(readFlt(&ff)==ERR)printStr("Invalid Float.\n");
                       else printStr("Float read.\n");
                       break;
                case 4:printFlt(ff);
                       break; 
                default:
                	   break;                     
        
            }
    }
        return 0;
}
