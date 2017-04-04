import "util/main.ash";

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

		maximize("-combat");
		choose_familiar("init");
		max_effects("init");

		log("Undefiling " + wrap($location[The Defiled Alcove]) + ". " + wrap($monster[Modern Zmobie]) + " appearance " + modern_zmobie_pct() + "% at +" + initiative_modifier() + " init.");
		int est = estimated_alcove_turns();
		int adv_count = my_adventures();

		while (get_property("cyrptAlcoveEvilness").to_int() > 0 && can_adventure())
		{
			maximize("init, -combat", $item[gravy boat]);
			if (!yz_adventure($location[The Defiled Alcove])) return;
			// bail on boss and force us to come back here through the loop.
			// this will force another check on dangerous() in case we should skip for now.
			if (get_property("cyrptAlcoveEvilness").to_int() == 25) return;
		}
		int total_turns = adv_count - my_adventures();
	}
}

void clear_niche()
{
	if(get_property("cyrptNicheEvilness").to_int() > 0)
	{

		log("Undefiling " + wrap($location[The Defiled Niche]) + ".");
		int adv_count = my_adventures();

		while (get_property("cyrptNicheEvilness").to_int() > 0 && can_adventure())
		{
			maximize("items", $item[gravy boat]);
			if (!yz_adventure($location[The Defiled Niche])) return;
			// bail on boss and force us to come back here through the loop.
			// this will force another check on dangerous() in case we should skip for now.
			if (get_property("cyrptNicheEvilness").to_int() == 25) return;
		}
		int total_turns = adv_count - my_adventures();

	}
}

void clear_nook()
{
	if(get_property("cyrptNookEvilness").to_int() > 0)
	{
		log("Undefiling " + wrap($location[The Defiled Nook]) + ".");
		int adv_count = my_adventures();

		while (get_property("cyrptNookEvilness").to_int() > 0 && can_adventure())
		{
			maximize("items", $item[gravy boat]);
			yz_adventure($location[The Defiled Nook]);
			if(item_amount($item[evil eye]) > 0)
			{
				use(item_amount($item[evil eye]), $item[evil eye]);
			}
			// bail on boss and force us to come back here through the loop.
			// this will force another check on dangerous() in case we should skip for now.
			if (get_property("cyrptNookEvilness").to_int() == 25) return;

		}
		int total_turns = adv_count - my_adventures();

	}

}

void clear_cranny()
{
	if(get_property("cyrptCrannyEvilness").to_int() > 0)
	{
		log("Undefiling " + wrap($location[The Defiled Cranny]) + ".");
		int adv_count = my_adventures();

		set_property("choiceAdventure523", "4");

		while (get_property("cyrptCrannyEvilness").to_int() > 0 && can_adventure())
		{
			maximize("ml, -combat", $item[gravy boat]);
			if (!yz_adventure($location[The Defiled Cranny])) return;
			// bail on boss and force us to come back here through the loop.
			// this will force another check on dangerous() in case we should skip for now.
			if (get_property("cyrptCrannyEvilness").to_int() == 25) return;
		}

		int total_turns = adv_count - my_adventures();

	}
}

boolean L07_Q_cyrpt()
{
	if(my_level() < 7)
    return false;

	if (quest_status("questL07Cyrptic") == FINISHED)
	  return false;

	maybe_pull($item[gravy boat]);

	if (my_daycount() == 1
			&& get_campground() contains $item[cornucopia]
			&& !have($item[gravy boat]))
	{
		log("Skipping the Cyrpt quest for today. Tomorrow we'll have some " + wrap($item[cashew], 2) + " and can use them to our advantage.");
		return false;
	}

	if(item_amount($item[chest of the bonerdagon]) == 1)
	{
    log("Looks like we've completed the quest but not opened the chest yet.");
		use(1, $item[chest of the bonerdagon]);
		return true;
	}

	int timer = my_adventures();

	if (item_amount($item[evilometer]) == 0)
	{
		log("We don't have an " + wrap($item[evilometer]) + ". Maybe we haven't started the quest yet?");
		council();
	}

	if (dangerous($location[the defiled alcove])) return false;
	if (get_property("cyrptAlcoveEvilness").to_int() > 0)
	{
		if (get_property("cyrptAlcoveEvilness").to_int() != 25
		    || !dangerous($monster[conjoined zmombie]))
		{
			clear_alcove();
			return true;
		}
	}

	if (dangerous($location[the defiled nook])) return false;
	if (get_property("cyrptNookEvilness").to_int() > 0)
	{
		if (get_property("cyrptNookEvilness").to_int() != 25
				|| !dangerous($monster[giant skeelton]))
		{
			clear_nook();
			return true;
		}
	}

	if (dangerous($location[the defiled niche])) return false;
	if (get_property("cyrptNicheEvilness").to_int() > 0)
	{
		if (get_property("cyrptNookEvilness").to_int() != 25
				|| !dangerous($monster[giant skeelton]))
		{
			clear_niche();
			return true;
		}
	}

	if (dangerous($location[the defiled cranny])) return false;
	if (get_property("cyrptCrannyEvilness").to_int() > 0)
	{
		if (get_property("cyrptCrannyEvilness").to_int() != 25
				|| !dangerous($monster[huge ghuol]))
		{
			clear_cranny();
			return true;
		}
	}

	// maybe fight it later?
	if (dangerous($monster[bonerdagon]))
		return false;

	if(get_property("cyrptTotalEvilness").to_int() <= 0)
	{
		if (my_primestat() == $stat[Mysticality])
		{
			log("Changing MCD to 5 to get us a " + wrap($item[rib of the bonerdagon]) + ".");
			change_mcd(5);
		} else {
			log("Changing MCD to 10 to get us a " + wrap($item[vertebra of the bonerdagon]) + ".");
			change_mcd(10);
		}

		set_property("choiceAdventure527", 1);

		boolean boner = yz_adventure($location[Haert of the Cyrpt], "");
		if(item_amount($item[chest of the bonerdagon]) == 1)
		{
			int total_adv = timer - my_adventures();
			log("Bonerdagon defeated! It took " + total_adv + " adventures.");
			use(1, $item[chest of the bonerdagon]);
			log("Going to the " + wrap("council", COLOR_LOCATION) + " to report our victory.");
			council();
		}
		else if(!boner)
		{
			warning("We tried to kill the Bonerdagon, but couldn't adventure there. The area seems defiled. Probably the cyrpt is complete? Worth checking by hand.");
			abort();
		}
		else
		{
			abort("Failed to kill bonerdagon");
		}
	}
	return true;
}

void main()
{
  L07_Q_cyrpt();
}
