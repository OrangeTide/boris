unsigned int test1(int n);

int vmMain(int x, int y)
{
	int d = test1(x) + y;
	return d;
}

unsigned int test1(int n)
{
	return n + n;
}
