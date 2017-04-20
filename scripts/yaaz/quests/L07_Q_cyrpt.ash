import "util/main.ash";


void L07_Q_cyrpt_progress()
{

}

void L07_Q_cyrpt_cleanup()
{
	while (have($item[evil eye])
		     && get_property("cyrptNookEvilness").to_int() > 25)
	{
		use(1, $item[evil eye]);
	}
}

float modern_zmobie_pct()
{
	return min(100.0, 15.0 + initiative_modifier() / 10.0);
}

/*
int estimated_alcove_turns()
{
	float pct = modern_zmobie_pct();
	float average = 1 * ((100-pct)/100) + 5 * (pct/100);
	float turns = (max(0, get_property("cyrptAlcoveEvilness").to_int() - 25) / average);
	return turns;
}
*/

void clear_alcove()
{

	if (get_property("cyrptAlcoveEvilness").to_int() <= 0) return;

	log("Undefiling " + wrap($location[The Defiled Alcove]) + ". " + wrap($monster[Modern Zmobie]) + " appearance " + modern_zmobie_pct() + "% at +" + initiative_modifier() + " init.");

	maximize("init, -combat", $item[gravy boat]);
	yz_adventure($location[The Defiled Alcove]);

}

void clear_niche()
{
	if (get_property("cyrptNicheEvilness").to_int() <= 0) return;

		log("Undefiling " + wrap($location[The Defiled Niche]) + ".");

		maximize("items", $item[gravy boat]);
		yz_adventure($location[The Defiled Niche]);
}

void clear_nook()
{
	if (get_property("cyrptNookEvilness").to_int() <= 0) return;

	log("Undefiling " + wrap($location[The Defiled Nook]) + ".");

	maximize("items", $item[gravy boat]);
	yz_adventure($location[The Defiled Nook]);

}

void clear_cranny()
{
	if (get_property("cyrptCrannyEvilness").to_int() <= 0) return;

	log("Undefiling " + wrap($location[The Defiled Cranny]) + ".");

	set_property("choiceAdventure523", "4");

	maximize("ml, -combat", $item[gravy boat]);
	yz_adventure($location[The Defiled Cranny]);
}

boolean L07_Q_cyrpt()
{

	L07_Q_cyrpt_cleanup();

	if(my_level() < 7) return false;

	if (quest_status("questL07Cyrptic") == FINISHED) return false;

	maybe_pull($item[gravy boat]);

	if (my_daycount() == 1
			&& get_campground() contains $item[cornucopia]
			&& !have($item[gravy boat]))
	{
		log("Skipping the Cyrpt quest for today. Tomorrow we'll have some " + wrap($item[cashew], 2) + " and can use them to our advantage.");
		return false;
	}

	if (have($item[chest of the bonerdagon]))
	{
    log("Looks like we've completed the quest but not opened the chest yet.");
		use(1, $item[chest of the bonerdagon]);
		return true;
	}

	if (!have($item[evilometer]))
	{
		log("We don't have an " + wrap($item[evilometer]) + ". Maybe we haven't started the quest yet?");
		council();
	}
	if (dangerous($location[the defiled alcove])) return false;

	if (get_property("cyrptAlcoveEvilness").to_int() > 0)
	{
		if (get_property("cyrptAlcoveEvilness").to_int() > 25
		    || !dangerous($monster[conjoined zmombie]))
		{
			clear_alcove();
			return true;
		}
	}

	if (dangerous($location[the defiled nook])) return false;
	if (get_property("cyrptNookEvilness").to_int() > 0)
	{
		if (get_property("cyrptNookEvilness").to_int() > 25
				|| !dangerous($monster[giant skeelton]))
		{
			clear_nook();
			return true;
		}
	}

	if (dangerous($location[the defiled niche])) return false;
	if (get_property("cyrptNicheEvilness").to_int() > 0)
	{
		if (get_property("cyrptNookEvilness").to_int() > 25
				|| !dangerous($monster[giant skeelton]))
		{
			clear_niche();
			return true;
		}
	}

	if (dangerous($location[the defiled cranny])) return false;
	if (get_property("cyrptCrannyEvilness").to_int() > 0)
	{
		if (get_property("cyrptCrannyEvilness").to_int() > 25
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
			log("Bonerdagon defeated!");
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
  while (L07_Q_cyrpt());
}
