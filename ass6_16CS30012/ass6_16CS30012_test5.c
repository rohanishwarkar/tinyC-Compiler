// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6
// Test File 5

int printi(int num);
int prints(char * c);
int readi(int *eP);

int gcd(int m, int n)
{
	if(n==0)
		return m;    
	return gcd(n, m%n);
}

int main()
{
	int a, b, c, p;
	prints("Enter first number : ");
	a = readi(&p);
	prints("Enter second number : ");
	b = readi(&p);	
	prints("The gcd of above two number is: ");
	c = gcd(a, b);
	printi(c);
	prints("\n");	
	return 0;
}
