// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6
// Test File 3

int printi(int num);
int prints(char * c);
int readi(int *eP);

int square(int n)
{
  	return n*n;
}

int main()
{
	int num, sq, fib,temp;
	prints("Enter a number: ");
	int p;
	num = readi(&p);
	sq = square(num);
	prints("Square is ");
	printi(sq);
	prints("\n");
	
	return 0;
}
