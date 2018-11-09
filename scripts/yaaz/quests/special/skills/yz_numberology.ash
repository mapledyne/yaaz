import "base/yz_print.ash";
import "base/yz_war_support.ash";
import "util/adventure/yz_consult.ash";
import "base/yz_inventory.ash";

void numberology_progress()
{
	if (!have_skill($skill[calculate the universe])) return;
	if (to_int(get_property("_universeCalculated")) >= to_int(get_property("skillLevel144"))) return;

	task("Calculate the Universe");
}

void numberology_cleanup()
{

}

int universe_result(int input)
{
  return reverse_numberology()[input];
}

int pick_a_number()
{
	int goal;

	if (war_side() == "fratboy"
		  && !have_outfit_simple(war_outfit()))
	{
		if (yellow_ray_item() != $item[none])
		{
			if (expected_damage($monster[War Frat 151st Infantryman]) > my_hp() * 0.8)
				return 0;

			goal = universe_result(51);
			if (goal > 0)
			{
				log("Going to " + wrap($skill[Calculate the universe]) + " to get us the " + wrap("Frat Warrior Fatigues", COLOR_ITEM) + ".");
				cli_execute("checkpoint");
				maximize("");
				cli_execute("numberology 51");
				run_combat("yz_consult");
				outfit("checkpoint");
				return goal;
			}
			return 0;
		}

		if (can_adventure_with_familiar($familiar[intergnat])
				&& my_adventures() > 8)
		{
			// wait a bit to collect bacon and get a viral video:
			return 0;
		}

	}

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

boolean numberology()
{
	if (!have_skill($skill[calculate the universe]))
		return false;
	if (to_int(get_property("_universeCalculated")) >= to_int(get_property("skillLevel144")))
		return false;
	int goal = pick_a_number();

	if (goal == 0)
	{
	 	return false;
	} else {
		return true;
	}
}

void main()
{
	while(numberology());
}
