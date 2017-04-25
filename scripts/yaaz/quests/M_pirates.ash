import "util/main.ash";

void M_pirates_progress()
{
  if (to_int(get_property("lastIslandUnlock")) < my_ascensions()) return;

  if (!have_outfit("swashbuckling getup") && !have($item[pirate fledges]))
  {
    task("Get the " + wrap("swashbuckling getup", COLOR_ITEM));
  }

  if (have_outfit("swashbuckling getup") && quest_status("questM12Pirate") == UNSTARTED)
  {
    task("Find " + wrap($item[cap'm caronch's map]));
  }

  if (quest_status("questM12Pirate") == 0)
  {
    task("Get " + wrap($item[Cap'm Caronch's nasty booty]));
  }
  if (quest_status("questM12Pirate") == 1)
  {
    task("Get " + wrap($item[orcish frat house blueprints]));
  }
  if (quest_status("questM12Pirate") == 2)
  {
    task("Get " + wrap($item[cap'm caronch's dentures]));
  }

  if (quest_status("questM12Pirate") > 0 && quest_status("questM12Pirate") < 5)
  {
    int current = pirate_insults();
    progress(current, 8, "pirate insults (" + pirate_insult_success() + "% chance)");
  }

  if (quest_status("questM12Pirate") == 5)
  {

    string mop = UNCHECKED;
    string ball = UNCHECKED;
    string shampoo  = UNCHECKED;
    int fledge_count = 0;
    if (have($item[mizzenmast mop]))
    {
      mop = CHECKED;
      fledge_count++;
    }
    if (have($item[ball polish]))
    {
      ball = CHECKED;
      fledge_count++;
    }
    if (have($item[rigging shampoo]))
    {
      shampoo = CHECKED;
      fledge_count++;
    }

    progress(fledge_count, 3, wrap($location[The F'c'le]) + " items (" + mop + "Mop, " + ball + "Polish, " + shampoo + "Shampoo)");

  }

}

void M_pirates_cleanup()
{
  if (to_int(get_property("lastIslandUnlock")) < my_ascensions()) return;

  while (!have($item[Talisman o' Namsilat]) && have($item[gaudy key]))
  {
    cli_execute("checkpoint");
    if (!have_equipped($item[pirate fledges]))
    {
      equip($item[pirate fledges]);
    }
    use(1, $item[gaudy key]);
    cli_execute("outfit checkpoint");
    cli_execute("refresh inv");
  }

  if (!have($item[abridged dictionary]) && !have($item[dictionary]))
  {
    buy(1, $item[abridged dictionary]);
  }


}


// stolen from cc_ascend, which has other great work in it, too.
boolean beer_pong(string page)
{
	record r {
		string insult;
		string retort;
	};

	r [int] insults;
	insults[1].insult="Arrr, the power of me serve'll flay the skin from yer bones!";
	insults[1].retort="Obviously neither your tongue nor your wit is sharp enough for the job.";
	insults[2].insult="Do ye hear that, ye craven blackguard?  It be the sound of yer doom!";
	insults[2].retort="It can't be any worse than the smell of your breath!";
	insults[3].insult="Suck on <i>this</i>, ye miserable, pestilent wretch!";
	insults[3].retort="That reminds me, tell your wife and sister I had a lovely time last night.";
	insults[4].insult="The streets will run red with yer blood when I'm through with ye!";
	insults[4].retort="I'd've thought yellow would be more your color.";
	insults[5].insult="Yer face is as foul as that of a drowned goat!";
	insults[5].retort="I'm not really comfortable being compared to your girlfriend that way.";
	insults[6].insult="When I'm through with ye, ye'll be crying like a little girl!";
	insults[6].retort="It's an honor to learn from such an expert in the field.";
	insults[7].insult="In all my years I've not seen a more loathsome worm than yerself!";
	insults[7].retort="Amazing!  How do you manage to shave without using a mirror?";
	insults[8].insult="Not a single man has faced me and lived to tell the tale!";
	insults[8].retort="It only seems that way because you haven't learned to count to one.";

	while(!page.contains_text("victory laps"))
	{
		string old_page = page;

		if(!page.contains_text("Insult Beer Pong"))
		{
			abort("You don't seem to be playing Insult Beer Pong.");
		}

		if(page.contains_text("Phooey"))
		{
			log("Looks like something went wrong and you lost.");
			return false;
		}

		foreach i in insults
		{
			if(page.contains_text(insults[i].insult))
			{
				if(page.contains_text(insults[i].retort))
				{
					log("Found appropriate retort for insult.");
					log("Insult: " + insults[i].insult);
					log("Retort: " + insults[i].retort);
					page = visit_url("beerpong.php?value=Retort!&response=" + i);
					break;
				}
				else
				{
					warning("Looks like you needed a retort you haven't learned.");
					log("Insult: " + insults[i].insult);
					log("Retort: " + insults[i].retort);

					// Give a bad retort
					page = visit_url("beerpong.php?value=Retort!&response=9");
					return false;
				}
			}
		}

		if(page == old_page)
		{
			abort("String not found. There may be an error with one of the insult or retort strings.");
		}
	}

	log("You won a thrilling game of Insult Beer Pong!");
	return true;
}

boolean try_beer_pong()
{
  set_property("choiceAdventure187", "0");
	string page = visit_url("adventure.php?snarfblat=157");
	boolean won = false;
	if(contains_text(page, "Arrr You Man Enough?"))
	{
    log("Attempting beer pong. Chance of success is " + pirate_insult_success() + "%.");
		won = beer_pong(visit_url("choice.php?pwd&whichchoice=187&option=1"));
	}
	return won;
}

boolean open_belowdecks()
{
  if (quest_status("questM12Pirate") != 6)
  {
    warning("Wrong status to try to open " + wrap($location[belowdecks]) + ".");
    return false;
  }

  if (quest_status("questL11MacGuffin") < 2)
  {
    warning("Go read " + wrap($item[your father's macguffin diary]) + ".");
    return false;
  }

  log("Opening up " + wrap($location[belowdecks]) + ".");

	set_property("choiceAdventure189", "1");
	set_property("oceanAction", "continue");
	set_property("oceanDestination", to_lower_case(my_primestat()));

  maximize("-combat", $item[pirate fledges]);
  yz_adventure($location[the poop deck]);

	if (quest_status("questM12Pirate") == FINISHED)
  	log(wrap($location[belowdecks]) + " opened.");
	return true;
}



boolean get_talisman()
{
  if (!have($item[pirate fledges])) return false;

  if (have($item[Talisman o' Namsilat])) return false;

  if (quest_status("questM12Pirate") != FINISHED)
  {
    open_belowdecks();
    return true;
  }

  maximize("items", $item[pirate fledges]);
	if (time_combat($monster[gaudy pirate], $location[belowdecks])) return true;

	yz_adventure($location[belowdecks]);
  return true;
}

boolean get_getup()
{
	if (my_basestat($stat[moxie]) < 25) return false; // needed for pants
	if (my_basestat($stat[mysticality]) < 25) return false; // needed for parrot

  if (have_outfit("swashbuckling getup"))
    return false;

	// wait until later when this isn't as risky.
	if (dangerous($location[The Obligatory Pirate's Cove])) return false;

  log("Get the swashbuckling getup...");
	maybe_pull($item[stuffed shoulder parrot]);
	maybe_pull($item[eyepatch]);
	maybe_pull($item[swashbuckling pants]);

  while(!have_outfit("swashbuckling getup"))
  {
    boolean b = yz_adventure($location[The Obligatory Pirate's Cove], "items, -combat");
    if (!b) return true;
  }
  return true;
}

boolean collect_insults()
{
  if (!have($item[the big book of pirate insults])) return false;

  if (pirate_insults() >= 6) return false;

	// wait until later when this isn't as risky.
	if (dangerous($location[Barrrney's barrr])) return false;

  set_property("choiceAdventure187", "2");

  if (item_amount($item[Cap'm Caronch's Map]) > 0
      && item_amount($item[Cap'm Caronch's nasty booty]) == 0)
  {
    if (dangerous($monster[booty crab])) return false;
    log("Off to fight the " + wrap($monster[booty crab]) + ".");
    maximize("");
    use(1, $item[Cap'm Caronch's Map]);
    return true;
  }

  maximize("combat", "swashbuckling getup");
  yz_adventure($location[Barrrney's barrr]);
  return true;
}

boolean get_capm_map()
{
  if (quest_status("questM12Pirate") > UNSTARTED) return false;

  while (item_amount($item[Cap'm Caronch's Map]) == 0)
  {
    maximize("", "swashbuckling getup");
    boolean b = yz_adventure($location[barrrney's barrr]);
    if (!b) return true;
  }
  return true;
}

boolean get_blueprints()
{
  if (quest_status("questM12Pirate") != 1) return false;

  if (item_amount($item[Cap'm Caronch's nasty booty]) == 0) return false;

  while (item_amount($item[Orcish Frat House blueprints]) == 0)
  {
    maximize("", "swashbuckling getup");
    boolean b = yz_adventure($location[barrrney's barrr]);
    if (!b) return true;
  }
  return true;
}

boolean get_skirt()
{
  if (have($item[frilly skirt])) return false;

  if (knoll_available())
  {
    log("Buying a " + wrap($item[frilly skirt]) + " to sneak into the frathouse.");
    buy(1, $item[frilly skirt]);
    return true;
  }
  log("Head to the " + wrap($location[the degrassi knoll gym]) + " to get a " + wrap($item[frilly skirt]) + ".");
  while (i_a($item[frilly skirt]) == 0)
  {
    boolean b = yz_adventure($location[the degrassi knoll gym], "items");
    if (!b) return true;
  }
  return true;
}

boolean fcle()
{

  if (have($item[pirate fledges])) return false;
  if (quest_status("questM12Pirate") < 5) return false;

  // The ordering here determines what familiar is used.
  // If we left it always at "combat, items" and didn't have the dog,
  // it'd default to a 'default' familiar, and we want to fall back to an
  // items familiar in this case.
  string max = "items, combat";
  if (have_familiar($familiar[jumpsuited hound dog]) && setting("100familiar") == "")
  {
    max = "combat, items";
  }

	if(have($item[rigging shampoo])
     && have($item[ball polish])
     && have($item[mizzenmast mop]))
  {
    log("Returning the items to get us some " + wrap($item[pirate fledges]) + ".");
    use(1, $item[rigging shampoo]);
    use(1, $item[ball polish]);
    use(1, $item[mizzenmast mop]);
		max = ""; // to prevent our 'max' above from using any items and such to keep up effects.
	} else {
		log("Off to get our " + wrap($item[pirate fledges]) + ".");
	}

  maximize(max, "swashbuckling getup");
  if (my_buffedstat(my_primestat()) < $location[The F\'c\'le].recommended_stat)
  {
    max_effects("mainstat", true);
  }

  yz_adventure($location[The F\'c\'le]);
  return true;
}

boolean M_pirates()
{

  if (to_int(get_property("lastIslandUnlock")) < my_ascensions()) return false;

  if (have($item[pirate fledges])) return false;

  if (get_getup()) return true;

	if (!have_outfit("swashbuckling getup")) return false;

  if (collect_insults()) return true;

  if (pirate_insults() < 6) return false;

  if (get_capm_map()) return true;

  if (item_amount($item[Cap'm Caronch's Map]) > 0 && quest_status("questM12Pirate")  < 1)
  {
    log("Using " + wrap($item[Cap'm Caronch's Map]) + ".");
    use(1, $item[Cap'm Caronch's Map]);
    return true;
  }

  if (get_blueprints()) return true;

  if (quest_status("questM12Pirate") == 2)
  {
    if (get_skirt()) return true;
    equip($item[frilly skirt]);
    set_property("choiceAdventure188", 3);
    use(1, $item[orcish frat house blueprints]);
    return true;
  }

  if (quest_status("questM12Pirate") > 2
      && quest_status("questM12Pirate") < 5)
  {
    outfit("swashbuckling getup");
    while(!try_beer_pong()) { }
    return true;
  }

  return fcle();

}

void main()
{
  while(M_pirates());
}
