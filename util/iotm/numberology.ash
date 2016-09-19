// yeah, not an IotM, but until there's a better place for it...


int moon_sign_id()
{
	switch(my_sign())
	{
		default:
			return 0;
		case "Mongoose":
			return 1;
		case "Wallaby":
			return 2;
		case "Vole":
			return 3;
		case "Platypus":
			return 4;
		case "Opossum":
			return 5;
		case "Marmot":
			return 6;
		case "Wombat":
			return 7;
		case "Blender":
			return 8;
		case "Packrat":
			return 9;
		case "Bad Moon":
			return 10;
	}
}

int universe_result(int input)
{
  int b = my_spleen_use() + my_level();
  int c = (my_ascensions() + moon_sign_id()) * b + my_adventures();

  for x from 0 to 99
	{
    int v = x * b + c;
    int last_two_digits = v % 100;
		if (last_two_digits == input)
		{
			return x;
		}
  }
	return 0;
}

int pick_a_number()
{
	if (hippy_stone_broken())
		return universe_result(37);
	return universe_result(69);
}

void main()
{
	int num = pick_a_number();
	if (num == 0)
		print("No good number found.");
	else
		print("Try: " + num + ".");

}
