// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6


#include "myl.h"
#define MAX 100                        
#define PREC 6  


//function for printing a string
int prints(char* s)
{
    int bytes = 0;                         // length of string is set to 0
    while(s[bytes] != '\0') 				//loop calculates the size of string
		bytes++;    						   
     __asm__ __volatile__ (            	  	// inline assembly code to print a string
         "movl $1, %%eax \n\t"      // $eax <-- $0x2000004 for performing write operation in Mac OS-X
         "movq $1, %%rdi \n\t"           // $rdi<--$1
         "syscall \n\t"                 // software interrupt using syscall
         :
         :"S"(s), "d"(bytes)             // S = s(the string to be printed), d = len
         );
     return bytes;   				// return the length of the string
}


//function for printing an integer
int printi(int n)
{
    char buff[MAX], zero='0'; // string buff stores the integer as a character string
    int i=0, j, k, bytes;		//bytes stores the no. of bytes stored in buff

    if(n == 0) 					
		buff[i++]=zero;			//if number is 0, store character 0 in buffer
    else{
       if(n < 0) {				// if number is negative
          buff[i++]='-';		// store character '-' in the beginning of buffer 
          n = -n;
       }
       while(n){				//store the digits of n in buffer from LSB to MSB, ie, reversed n gets stored
          int dig = n%10;
          buff[i++] = (char)(zero+dig);
          n /= 10;
       }
       if(buff[0] == '-') j = 1;	//initialize j for reversing buff string
       else j = 0;
       k=i-1;
       while(j<k){				// reverse buff string so as to store n from MSB to LSB
          char temp=buff[j];	//swap front and end elements continuously to swap
          buff[j++] = buff[k];
          buff[k--] = temp;
       }
    } 
    //buff[i]='\n';
    bytes = i;

    __asm__ __volatile__ (			//inline assembly code for printing n stored in buffer
          "movl $1, %%eax \n\t"	 // $eax <-- $0x2000004 for performing write operation in Mac OS-X
          "movq $1, %%rdi \n\t"			//$rdi<--$1
          "syscall \n\t"				// software interrupt using syscall
          :
          :"S"(buff), "d"(bytes)		//S = buff, d = bytes
    ) ;  // $1: write, $1: on stdin
	return bytes;						// return the number of bytes printed
}

int print7(int dsp1){
	long long int dsp2=0;
	while(dsp1!=0){
		dsp2++;
		if(dsp1==0)
			return;
		dsp1--;
	}
	return dsp2;
}


//function for reading signed integer from user
int readi( int *eP)
{
    *eP = OK;                           // make the default error value equal to OK
    char buff[MAX];                     // allocate size of buffer for the integer(in terms of string) to be read
    __asm__ __volatile__ (              // inline assembly code for reading a string
        "movl $0, %%eax \n\t"           //$eax <-- $0x2000003 for performing read operation in Mac OS-X
        "movq $0, %%rdi \n\t"           // $rdi<--$0
        "syscall \n\t"                  //software interrupt using syscall
        :
        :"S"(buff), "d"(MAX)            // S = buff, d = MAX
        );
    int i = 0, neg_sign = 0;                          // i<--a counter that stores the index of the character to be read;                      
		  											// neg_sign<-- a flag variable to check if a given number is negative or not
	long long result = 0;  
    
	if(buff[i] == '-')                   	// if input integer if negative
    {
        neg_sign = 1;                        // mark integer as negative
        i++;								// start evaluating integer from the next index of buffer
    }
                   	 					
    while(buff[i] != '\n')               // loop till end of input (assuming input is terminated by a '\n')
    {
		if(buff[i]<'0' || buff[i]>'9')		//if buff contains stray characters other than characters between '0' and '9'
		{
			*eP = ERR;			//input is not a valid integer, mark *eP as ERR to mark it is an error input
			return result;
		}
									//if input character is ok 
		result = result * 10;		//multiply result with 10 
		int dig = buff[i] - '0';
		result = result + dig;		// add current digit with result
		
		if(result >= (1LL<<31))			//check for overflow if the integer size exceeds 32 bits
		{
			*eP = ERR;					//show error
			return result;
		}
			
		i++;							//increment loop variable to read the next buffer input
    }	//end of input and loop

	if(neg_sign != 0)	//if the buff had a '-' character in front
	{
		result = (-1) * result;		//mark result as negative
	}
                                                 
    return result;		//return result

}


//function to read floating point numbers
int readf( float *fp)
{
    char buff[MAX];                     // allocate size for the string to be read
    __asm__ __volatile__ (              // inline assembly code for reading a string (a float number eventually)
        "movl $0, %%eax \n\t"           //$eax <-- $0x2000003 for performing read operation in Mac OS-X 
        "movq $0, %%rdi \n\t"           // $ebx <-- $0
        "syscall \n\t"                 // software interrupt using syscall
        :
        :"S"(buff), "d"(MAX)            // S = str, d = MAX
        );
    int i = 0, neg_sign=0;
    //int neg = 0;
    if(buff[i] == '-')                   // check for negative sign
    {
        neg_sign = 1;
        i++;
    }
    float result = 0;				//initialise result as 0
	while(buff[i]!='.' && buff[i]!='\n')		//Run loop till decimal point or end of input is achieved, whichever comes first
	{
		if(buff[i]<'0' || buff[i]>'9')			//if buff contains stray characters other than characters between '0' and '9'
		{
			*fp = result;						
			return ERR;							//report error
		}
		
		result = result * 10;
		result = result + (buff[i] - '0');		//otherwise extract digits from buffer and create a number
		i++;
	}
	
	if(buff[i] == '.')						// if decimal point is reached
	{
		i++;
		float mult_fact = 0.1;				//multiply dig by 0.1, then 0.1/10, 0.1/100 and so on..
		while(buff[i]!='\n')
		{
			if(buff[i]<'0' || buff[i]>'9')		//if buff contains stray characters other than characters between '0' and '9'
			{
				*fp = result;
				return ERR;			//report error
			}
			 
			result = result + ((float)(buff[i] - '0'))*mult_fact;			//compute the decimal part and add it to result
			mult_fact = mult_fact / 10;
			i++;			//increment loop variable
		}
	}
	
	if(neg_sign != 0)		//if negative flag is 1
	{
		result = (-1) * result;		// make the result negative
	}
	
	*fp = result;	// make *fp hold the final result
	return OK;	//every condition passed, so return OK
}

int printuu(int dsp1){
	long long int dsp2=0;
	while(dsp1!=0){
		dsp2++;
		if(dsp1==0)
			return;
		dsp1--;
	}
	return dsp2;
}
int printd(float f)
{
	int bytes = 0;
	char buff[MAX];		//string for storing character buffer of floating point number to be printed
	int i,j;
	i=0;				
	if(f == 0)			//if the floating point number is 0
	{
		buff[i++] = '0';	//put the '0' character in the buffer
		bytes = i;
	}
	else
	{
		if(f < 0)			//if the number is negative
		{
			buff[bytes++] = '-';		//put '-' character in the buffer
			f = -f;
		}
		
		long long intpart_f = (long long)f;	//intpart_f has the integral part of f
		f = f - intpart_f;		//  f has the fractional part of f
		
		if(intpart_f == 0)		// if the integral part is 0
			buff[bytes++] = '0';		// put '0' in the buffer
		else
		{
			i = bytes;
			while(intpart_f > 0)	//put the characters in buffer in reverse order from LSB to MSB
			{
				int dig = intpart_f % 10;
				buff[bytes++] = (char)('0' + dig);
				intpart_f = intpart_f / 10;
			}
			j = bytes - 1;
			while(j>i)			// put characters in correct order from MSB to LSB
			{
				char temp = buff[i];	//swap from front and back
				buff[i++] = buff[j];
				buff[j--] = temp;
			}
		}
		
		f = f * 10;		//extract each fractional part digits by multiplying f with 10 and taking the integer part
		buff[bytes++] = '.';	// put the decimal point
		i = 0;
		while(i<PREC)		//6 bits precision
		{
			int dig = (int)f;	// integer part of f, take the fractional part digits one by one
			buff[bytes++] = dig + '0';	//insert each digit after decimal point
			f = f - dig;	// again reduce f to having only fractional part
			f = f * 10;		// take the next fractional digit to the integral part
			i++;
		}
	}
    __asm__ __volatile__ (              // assembly code for printing a string
        "movl $1, %%eax \n\t"          //$eax <-- $0x2000004 for performing write operation in Mac OS-X 
        "movq $1, %%rdi \n\t"           // $ebx <-- $1
        "syscall \n\t"                 // software interrupt using syscall
        :
        :"S"(buff), "d"(bytes)             // S = buff,d = bytes
        );
    
	return bytes;                         // return the number of bytes printed
}

