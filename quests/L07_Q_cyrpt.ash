import "util/main.ash";

int evil_progress(int p)
{
	return 25-(max(0,p-25));
}

float modern_zmobie_pct()
{
	return min(100.0, 15.0 + initiative_modifier() / 10.0);
}

int estimated_alcove_turns()
{
	float pct = modern_zmobie_pct();
	float average = 1 * ((100-pct)/100) + 5 * (pct/100);
	float turns = (max(0, get_property("cyrptAlcoveEvilness").to_int() - 25) / average);
	return turns;
}

void clear_alcove()
{
	if(get_property("cyrptAlcoveEvilness").to_int() > 0)
	{

		maximize("noncombat");
		choose_familiar("init");
		max_effects("init");

		log("Undefiling " + wrap($location[The Defiled Alcove]) + ". " + wrap($monster[Modern Zmobie]) + " appearance " + modern_zmobie_pct() + "% at +" + initiative_modifier() + " init.");
		int est = estimated_alcove_turns();
		log("Estimated turns: " + est);
		int adv_count = my_adventures();

		while (get_property("cyrptAlcoveEvilness").to_int() > 0)
		{
			maximize("init, -combat");
			dg_adventure($location[The Defiled Alcove]);
			progress(evil_progress(get_property("cyrptAlcoveEvilness").to_int()), 25, "evilness cleared in Alcove.");

		}
		int total_turns = adv_count - my_adventures();
		log("Actual turns to clear " + wrap($location[The Defiled Alcove]) + ": " + total_turns + ". We estimated " + est);
	}
}

void clear_niche()
{
	if(get_property("cyrptNicheEvilness").to_int() > 0)
	{

		log("Undefiling " + wrap($location[The Defiled Niche]) + ".");
		int adv_count = my_adventures();

		while (get_property("cyrptNicheEvilness").to_int() > 0)
		{
			maximize("items");
			dg_adventure($location[The Defiled Niche]);
			progress(evil_progress(get_property("cyrptNicheEvilness").to_int()), 25, "evilness cleared in Niche.");

		}
		int total_turns = adv_count - my_adventures();
		log("Turns to clear " + wrap($location[The Defiled Niche]) + ": " + total_turns + ".");
		warning_no_estimate();

	}
}

void clear_nook()
{
	if(get_property("cyrptNookEvilness").to_int() > 0)
	{
		log("Undefiling " + wrap($location[The Defiled Nook]) + ".");
		int adv_count = my_adventures();

		while (get_property("cyrptNookEvilness").to_int() > 0)
		{
			maximize("items");
			dg_adventure($location[The Defiled Nook]);
			if(item_amount($item[evil eye]) > 0)
			{
				use(item_amount($item[evil eye]), $item[evil eye]);
			}
			progress(evil_progress(get_property("cyrptNookEvilness").to_int()), 25, "evilness cleared in Nook.");

		}
		int total_turns = adv_count - my_adventures();
		log("Turns to clear " + wrap($location[The Defiled Nook]) + ": " + total_turns + ".");
		warning_no_estimate();

	}

}

void clear_cranny()
{
	if(get_property("cyrptCrannyEvilness").to_int() > 0)
	{
		log("Undefiling " + wrap($location[The Defiled Cranny]) + ".");
		int adv_count = my_adventures();

		set_property("choiceAdventure523", "4");

		while (get_property("cyrptCrannyEvilness").to_int() > 0)
		{
			maximize("ml, -combat");
			dg_adventure($location[The Defiled Cranny]);
			progress(evil_progress(get_property("cyrptCrannyEvilness").to_int()), 25, "evilness cleared in Cranny.");
		}

		int total_turns = adv_count - my_adventures();
		log("Turns to clear " + wrap($location[The Defiled Cranny]) + ": " + total_turns + ".");
		warning_no_estimate();

	}
}

void defeat_cyrpt()
{
	if(my_level() < 7)
  {
    error('Cannot adventure here yet. Get to level 7!');
    return;
  }

  if (get_property("questL07Cyrptic") == "finished")
  {
    warning("You've already completed the cyrpt.");
    return;
  }

	if(item_amount($item[chest of the bonerdagon]) == 1)
	{
    log("Looks like we've completed the quest but not opened the chest yet.");
		use(1, $item[chest of the bonerdagon]);
		return;
	}

	int timer = my_adventures();

	if (item_amount($item[evilometer]) == 0)
	{
		log("We don't have an evilometer. Maybe we haven't started the quest yet?");
		council();
	}

	clear_alcove();

	clear_nook();

	clear_niche();

	clear_cranny();

	if(get_property("cyrptTotalEvilness").to_int() <= 0)
	{
		if (my_primestat() == $stat[Mysticality])
		{
			change_mcd(5);
		} else {
			change_mcd(10);
		}

		set_property("choiceAdventure527", 1);

		maximize("");
		boolean boner = dg_adventure($location[Haert of the Cyrpt]);
		if(item_amount($item[chest of the bonerdagon]) == 1)
		{
			int total_adv = timer - my_adventures();
			log("Bonerdagon defeated! It took " + total_adv + " adventures.");
			use(1, $item[chest of the bonerdagon]);
		}
		else if(!boner)
		{
			warning("We tried to kill the Bonerdagon, but couldn't adventure there. The area seems defiled. Probably the cyrpt is complete? Worth checking by hand.");
		}
		else
		{
			abort("Failed to kill bonerdagon");
		}
	}
}

void main()
{
  defeat_cyrpt();
}
