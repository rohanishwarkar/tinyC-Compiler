// Name : Ishwarkar Rohan Shankar
// Roll No : 16CS30012
// Compilers Assignment No.: 6
// Test File 1

int printi(int num);
int prints(char * c);
int readi(int *eP);
int main()
{
    int a,b,p;
    prints("Enter first number : ");
    a = readi(&p);
    prints("Enter second number : ");
    b = readi(&p);
    prints("Sum of two numbers is : ");
    printi(a+b);
    prints(" !\n");
    return 0;
}
