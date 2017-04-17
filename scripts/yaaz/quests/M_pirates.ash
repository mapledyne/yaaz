import "util/main.ash";

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

void open_belowdecks()
{
  if (quest_status("questM12Pirate") != 6)
  {
    warning("Wrong status to try to open " + wrap($location[belowdecks]) + ".");
    return;
  }

  if (quest_status("questL11MacGuffin") < 2)
  {
    warning("Go read " + wrap($item[your father's macguffin diary]) + ".");
    return;
  }

  log("Opening up " + wrap($location[belowdecks]) + ".");

	set_property("choiceAdventure189", "1");
	set_property("oceanAction", "continue");
	set_property("oceanDestination", to_lower_case(my_primestat()));

  while (quest_status("questM12Pirate") != FINISHED)
  {
    maximize("-combat", $item[pirate fledges]);
    boolean b = yz_adventure($location[the poop deck]);
		if (!b) return;
  }
  log(wrap($location[belowdecks]) + " opened.");
}

void maybe_make_talisman()
{
  while (!have($item[Talisman o' Namsilat]) && have($item[gaudy key]))
  {
    cli_execute("checkpoint");
    if (!have_equipped($item[pirate fledges]))
    {
      equip($item[pirate fledges]);
    }
    use(1, $item[gaudy key]);
    cli_execute("outfit checkpoint");
  }
}

boolean get_talisman()
{
  if (!have($item[pirate fledges]))
    return false;

  if (have($item[Talisman o' Namsilat]))
    return false;

  if (quest_status("questM12Pirate") != FINISHED)
  {
    open_belowdecks();
    return true;
  }

	maybe_make_talisman();

  while(!have($item[Talisman o' Namsilat]))
  {
    maximize("items", $item[pirate fledges]);
		if (!time_combat($monster[gaudy pirate], $location[belowdecks]))
		{
			boolean b = yz_adventure($location[belowdecks]);
			if (!b) return true;
		}
    maybe_make_talisman();
  }
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
  if (!have($item[the big book of pirate insults]))
    return false;

  if (pirate_insults() >= 6)
    return false;

	// wait until later when this isn't as risky.
	if (expected_damage($monster[toothy pirate]) > my_hp() / 4) return false;

  set_property("choiceAdventure187", "2");

  while (pirate_insults() < 6)
  {
    if (item_amount($item[Cap'm Caronch's Map]) > 0
        && item_amount($item[Cap'm Caronch's nasty booty]) == 0)
    {
      log("Off to fight the " + wrap($monster[booty crab]) + ".");
      maximize("");
      use(1, $item[Cap'm Caronch's Map]);
      return true;
    }

    maximize("combat", "swashbuckling getup");
		if (expected_damage($monster[toothy pirate]) > my_hp() / 4) return true;
    boolean b = yz_adventure($location[Barrrney's barrr]);
    if (!b) return true;
  }
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

  log("Off to get our " + wrap($item[pirate fledges]) + ".");

  while ((item_amount($item[rigging shampoo]) == 0
         || item_amount($item[ball polish]) == 0
         || item_amount($item[mizzenmast mop]) == 0)
				 && !have($item[pirate fledges]))
  {
    maximize(max, "swashbuckling getup");
    boolean b = yz_adventure($location[The F\'c\'le]);
    if (!b) return true;
  }

	if (have($item[pirate fledges])) return true;


  if((item_amount($item[rigging shampoo]) == 1)
     && (item_amount($item[ball polish]) == 1)
     && (item_amount($item[mizzenmast mop]) == 1))
  {
    log("Returning the items to get us some " + wrap($item[pirate fledges]) + ".");
    use(1, $item[rigging shampoo]);
    use(1, $item[ball polish]);
    use(1, $item[mizzenmast mop]);
    outfit("swashbuckling getup");
    yz_adventure($location[The F\'c\'le]);
  }

  return true;
}

boolean M_pirates()
{
  if (to_int(get_property("lastIslandUnlock")) < my_ascensions())
    return false;

  if (have($item[pirate fledges]))
    return false;

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

  if (fcle()) return true;

  log("Shouldn't get here anymore...?");
  wait(15);

  return false;
}

void main()
{
  while(M_pirates());
}
