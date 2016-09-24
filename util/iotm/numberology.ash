// yeah, not an IotM, but until there's a better place for it...
import "base/print.ash";

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
	int goal;
	if (hippy_stone_broken())
	{
 		goal = universe_result(37);
		if (goal > 0)
		{
			log("Going to " + wrap($skill[Calculate the universe]) + " to get us some more PvP fights.");
			cli_execute("numberology 37");
			return goal;
		}
		return 0;
	}
	goal = universe_result(69);
	if (goal > 0)
	{
		log("Going to " + wrap($skill[Calculate the universe]) + " to get us some more adventures.");
		cli_execute("numberology 69");
		return goal;
	}
	return 0;
}

void numberology()
{
	if (!have_skill($skill[calculate the universe]))
		return;
	if (to_int(get_property("_universeCalculated")) != 0)
		return; // TODO: doesn't account for >1 calculations possible yet.
	int goal = pick_a_number();

	if (goal == 0)
	 	return;
}

void main()
{
	numberology();
}
