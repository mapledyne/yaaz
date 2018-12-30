// make things to use up inventory that shouldn't generally be done
// without explicitly asking to do so (as in calling this script)

void try_create(item toy, int max)
{
	int make = creatable_amount(toy);
	make = min(max, make);
	if (make > 0)
	{
		create(make, toy);
	}
}

void try_create(item toy)
{
	try_create(toy, 10000);
}

void main()
{
	try_create($item[eldritch concentrate]);
}
