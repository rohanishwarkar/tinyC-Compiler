int printi(int n);
int readi(int *eP);
int prints(char *str);

int binary_search(int arr[10], int left, int right, int search_key)
{
	int middle, temp;
	if(left < right || left == right)
	{
		middle = (left + right)/2;
		if(arr[middle] == search_key)
			return middle;
		else if (search_key < arr[middle])
		{
			temp = binary_search(arr, left, middle - 1, search_key);
			return temp;
		}
		else
		{
			temp = binary_search(arr,middle + 1, right, search_key);
			return temp;			
		}
	}
	else
		return -1;		
}
int main()
{
	int n, p, i, x, value;
	int a[10];
	prints("Enter the number of elements of array: ");
	n = readi(&p);
	prints("Enter the elements in sorted order:\n");
	for(i=0; i<n ;i++)
	{
		x = readi(&p);
		a[i] = x;
	}	
	prints("Enter the element to search : ");
	value = readi(&p);
	int ret_value;
	ret_value = binary_search(a, 0, n-1, value);
	if(ret_value == -1)
		prints("Value not found!!\n");
	else
	{
		prints("Element at position: ");
		printi(ret_value);
		prints(" !\n");
	}
	return 0;
}
