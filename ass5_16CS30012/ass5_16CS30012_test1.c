/*
Name:- Ishwarkar Rohan Shankar
Roll No:- 16CS30012
Compilers Assignment 5
*/
int z;  
int main(){
	int a,b,c,i=9,j=2,*x;
	double d=2.0,f=9.8;
	char c='a';
	char str[20]="vishal";
	a=i++;
	b=++j;
	x=&a;
	b=*x;
	b=+a;
	b=-a;
	b=~a;
	b=!a;
	b=(int)d;
	a=b*c;
	a=b/c;
	b=a%c;	
	b=a++ + ++a;
	return 0;
}
