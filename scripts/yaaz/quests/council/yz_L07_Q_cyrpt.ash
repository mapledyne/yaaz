import "util/yz_main.ash";

int evil_progress(int p)
{
	return 25-(max(0,p-25));
}


void L07_Q_cyrpt_progress()
{
	if (!quest_active("questL07Cyrptic")) return;

	int evil = 200 - to_int(get_property("cyrptTotalEvilness"));
	progress(evil, 200, "Cyrpt progress");
	if (get_property("cyrptAlcoveEvilness").to_int() > 0 && get_property("cyrptAlcoveEvilness").to_int() < 50)
		progress(evil_progress(get_property("cyrptAlcoveEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled alcove]));

	if (get_property("cyrptCrannyEvilness").to_int() > 0 && get_property("cyrptCrannyEvilness").to_int() < 50)
		progress(evil_progress(get_property("cyrptCrannyEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled cranny]));

	if (get_property("cyrptNicheEvilness").to_int() > 0 && get_property("cyrptNicheEvilness").to_int() < 50)
		progress(evil_progress(get_property("cyrptNicheEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled niche]));

	if (get_property("cyrptNookEvilness").to_int() > 0 && get_property("cyrptNookEvilness").to_int() < 50)
		progress(evil_progress(get_property("cyrptNookEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled nook]));

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

		monster_attract = $monsters[dirty old lihc];
		monster_banish = $monsters[senile lihc, slick lihc];
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

	if (get_property("cyrptTotalEvilness").to_int() > 0
	    && have($item[nightmare fuel])
			&& to_int(get_property("_nightmareFuelCharges")) == 0)
	{
		use(1, $item[nightmare fuel]);
	}

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

	if(get_property("cyrptTotalEvilness").to_int() <= 0)
	{
		// maybe fight it later?
		if (dangerous($monster[bonerdagon]))
		{
			info("Skipping fighting the " + wrap($monster[bonerdagon]) + " for a bit until he's less dangerous.");
			return false;
		}
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
