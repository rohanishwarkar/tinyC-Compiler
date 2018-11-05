// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6
// Test File 2

int printi(int num);
int prints(char * c);
int readi(int *eP);

int main()
{
	int a[5];
	int b[5];
	int p, n, x, i, y, z;
	prints("Enter 5 elements of first array : ");
	for(i = 0; i < 5; i++ )
	{
		x = readi(&p);
		a[i] = x;
	}
	prints("Enter 5 elements of second array : ");
	for(i = 0; i < 5; i++ )
	{
		x = readi(&p);
		b[i] = x;
	}
	prints("The elements of the summed array are:\n");
	for( i = 0; i < 5; i++ )
	{
		x = a[i];	
		y = b[i];
		z = x + y;
		printi(z);
		prints(" ");
	}
	prints("\n");
	return 0;
}
