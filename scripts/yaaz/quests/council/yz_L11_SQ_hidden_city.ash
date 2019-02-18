import "util/yz_main.ash";
import "special/items/yz_deck.ash";

void check_stones()
{
  set_property("choiceAdventure781", 1);
  set_property("choiceAdventure783", 1);
  set_property("choiceAdventure785", 1);
  set_property("choiceAdventure787", 1);

  if (have($item[scorched stone sphere]))
  {
    yz_adventure($location[An Overgrown Shrine (Southeast)]);
  }

  if (have($item[crackling stone sphere]))
  {
    yz_adventure($location[An Overgrown Shrine (Northeast)]);
  }

  if (have($item[dripping stone sphere]))
  {
    yz_adventure($location[An Overgrown Shrine (Southwest)]);
  }

  if (have($item[moss-covered stone sphere]))
  {
    yz_adventure($location[An Overgrown Shrine (Northwest)]);
  }
}


boolean get_machete()
{
  if (have($item[antique machete])) return false;
  if (my_path() == "Way of the Surprising Fist") return false;

  if (get_property("relocatePygmyJanitor") == 0)
  {
    set_property("choiceAdventure789", 1); // Dig through the garbage
  }
  else
  {
    set_property("choiceAdventure789", 2); // knock over the dumpster (moves janitors to the park)
  }

  maximize("");
  yz_adventure($location[the hidden park]);
  return true;
}

boolean do_liana()
{
  maybe_pull($item[antique machete]);
  if (!have($item[antique machete]) || my_path() == "Way of the Surprising Fist")
  {
    return false;
  }

  if (!contains_text($location[a massive ziggurat].noncombat_queue, "Legend of the Temple in the Hidden City"))
  {
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[A massive Ziggurat]) + ".");
    maximize("", $item[antique machete]);
    yz_adventure($location[A Massive Ziggurat]);
    return true;
  }

  if (quest_status("questL11Business") > UNSTARTED
      && quest_status("questL11Curses") > UNSTARTED
      && quest_status("questL11Doctor") > UNSTARTED
      && quest_status("questL11Spare") > UNSTARTED)
  {
    return false;
  }

  maximize("", $item[antique machete]);

  if (quest_status("questL11Business") < 0)
  {
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Northeast)]) + ".");
    yz_adventure($location[An Overgrown Shrine (Northeast)]);
    return true;
  }

  if (quest_status("questL11Curses") < 0)
  {
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Northwest)]) + ".");
    yz_adventure($location[An Overgrown Shrine (Northwest)]);
    return true;
  }

  if (quest_status("questL11Doctor") < 0)
  {
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Southwest)]) + ".");
    yz_adventure($location[An Overgrown Shrine (Southwest)]);
    return true;
  }

  if (quest_status("questL11Spare") < 0)
  {
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Southeast)]) + ".");
    yz_adventure($location[An Overgrown Shrine (Southeast)]);
    return true;
  }

  return false;
}

boolean bowling()
{
  if (prop_int("hiddenBowlingAlleyProgress") < 1) return false;

  if (prop_int("hiddenBowlingAlleyProgress") > 6) return false;

  if (dangerous($location[the hidden bowling alley]))
  {
    info("Waiting a bit on " + wrap($location[the hidden bowling alley]) + " until it's less dangerous.");
    return false;
  }

  log("Defeating " + wrap($location[the hidden bowling alley]) + ".");

  set_property("choiceAdventure788", 1); // bowl, and eventually fight spectre

  if (!have($item[Bowl Of Scorpions])
     && my_ascensions() <= prop_int("hiddenTavernUnlock"))
  {
    log("Buying a " + wrap($item[Bowl Of Scorpions]) + " to get away from a " + wrap($monster[drunk pygmy]) + ".");
    buy(1, $item[Bowl Of Scorpions]);
  }

  if (prop_int("hiddenBowlingAlleyProgress") < 6)
  {
    monster_attract = $monsters[pygmy bowler];
    monster_banish = $monsters[drunk pygmy, pygmy janitor];

    yz_adventure($location[the hidden bowling alley], "items");
    return true;
  }

  if (!have($item[bowling ball]))
  {
    yz_adventure($location[the hidden bowling alley], "items");
    return true;
  }

  if (dangerous($monster[ancient protector spirit]))
  {
    info("Will wait on the " + wrap($monster[ancient protector spirit]) + " until it's less dangerous.");
    return false;
  }
  log("Off to defeat the " + wrap($monster[ancient protector spirit]) + ".");
  yz_adventure($location[the hidden bowling alley], "hot dmg, stench dmg, cold dmg, sleaze dmg");

  return true;
}

boolean hospital()
{
  if (prop_int("hiddenHospitalProgress") < 1) return false;

  if (prop_int("hiddenHospitalProgress") > 6) return false;

  if (dangerous($location[the hidden hospital]))
  {
    info("Waiting a bit on " + wrap($location[the hidden hospital]) + " until it's less dangerous.");
    return false;
  }
  set_property("choiceAdventure784", 1);
  log("Defeating " + wrap($location[the hidden hospital]) + ".");
  monster_attract = $monsters[pygmy witch surgeon];

  maximize("mainstat, hot dmg, stench dmg, cold dmg, sleaze dmg, 50 surgeonosity");
  yz_adventure($location[the hidden hospital]);

  if (prop_int("hiddenHospitalProgress") > 6)
  {
    log(wrap($location[the hidden hospital]) + " cleared.");
  }
  return true;
}

boolean office()
{
  if (prop_int("hiddenOfficeProgress") < 1) return false;

  if (prop_int("hiddenOfficeProgress") > 6) return false;

  if (dangerous($location[the hidden office building]))
  {
    info("Waiting a bit on " + wrap($location[the hidden office building]) + " until it's less dangerous.");
    return false;
  }

  log("Defeating " + wrap($location[the hidden office building]) + ".");

  monster_attract = $monsters[pygmy witch accountant];
  if (have($item[McClusky file (complete)]))
  {
    set_property("choiceAdventure786", 1); // fight spirit
  }
  else if (!have($item[boring binder clip]))
  {
    set_property("choiceAdventure786", 2); // get binder clip
  }
  else
  {
    set_property("choiceAdventure786", 3); // fight accountant
  }

  int turns = $location[the hidden office building].turns_spent % 5;
  if (have($item[boring binder clip])
      && !have($item[McClusky file (complete)])
      && turns == 0
      && quest_status("questL11Curses") != FINISHED)
  {
    log("Trying to get the rest of the " + wrap("McClusky File", COLOR_ITEM) + " from the " + wrap($location[the hidden apartment building]));
    return false;
  }

  if (have($item[McClusky file (complete)])
      && dangerous($monster[ancient protector spirit (The Hidden Office Building)]))
  {
    info("Will fight the " + wrap($monster[ancient protector spirit (The Hidden Office Building)]) + " when it's less dangerous.");
    return false;
  }

  string max = "";

  if (have($item[McClusky file (complete)])
      && turns == 0)
  {
    max = "hot dmg, stench dmg, cold dmg, sleaze dmg";
  }

  yz_adventure($location[the hidden office building], max);

  if (prop_int("hiddenOfficeProgress") > 6)
  {
    log(wrap($location[the hidden office building]) + " cleared.");
  }

  return true;
}

boolean apartment()
{
  if (prop_int("hiddenApartmentProgress") < 1) return false;

  if (prop_int("hiddenApartmentProgress") > 6)
  {
    // we have the sphere, so remove the curse if hottub available
    if (have_effect($effect[thrice-cursed]) > 0) vip_hottub();
    return false;
  }

  if (dangerous($monster[ancient protector spirit])
      && have_effect($effect[once-cursed]) == 0
      && have_effect($effect[twice-cursed]) == 0
      && have_effect($effect[thrice-cursed]) == 0)
  {
    info("Waiting a bit on " + wrap($location[the hidden apartment building]) + " until it's less dangerous.");
    return false;
  }


  log("Defeating " + wrap($location[the hidden apartment building]) + ".");

  if (have_effect($effect[thrice-cursed]) > 0)
  {
    set_property("choiceAdventure780", 1); // fight spirit
  }
  else
  {
    set_property("choiceAdventure780", 2); // increase our curse
  }

  if (get_property("olfactedMonster") != $monster[pygmy witch accountant]
      || quest_status("questL11Business") == FINISHED)
  {
    monster_attract = $monsters[pygmy shaman];
  }

  monster_banish = $monsters[pygmy janitor, pygmy witch lawyer];

  if (prop_int("hiddenTavernUnlock") < my_ascensions())
  {
    maybe_pull($item[book of matches]);
  }

  if (have_effect($effect[twice-cursed]) > 0
      && prop_int("hiddenTavernUnlock") == my_ascensions())
  {
    log("Trying to drink a " + wrap($item[cursed punch]) + " for the extra curse.");
    try_consume($item[cursed punch]);
  }

  string max = "";
  if (have_effect($effect[thrice-cursed]) > 0)
  {
    max = "hot dmg, stench dmg, cold dmg, sleaze dmg";
  }
  yz_adventure($location[the hidden apartment building], max);

  if (prop_int("hiddenApartmentProgress") > 6)
  {
    log(wrap($location[the hidden apartment building]) + " cleared.");
  }

  return true;
}

boolean fight_spirit()
{
  if (quest_status("questL11Worship") != 4) return false;

  log("Fighting the " + wrap($monster[Protector Spectre]) + ".");
  yz_adventure($location[A Massive Ziggurat], "elemental damage");
  run_combat('yz_consult');
  return true;
}

boolean get_nose()
{
	if (quest_status("questL11Worship") != 1) return false;

	if (have($item[The Nostril of the Serpent])) return false;

  if (!have($item[Stone Wool]) && (have_effect($effect[stone-faced]) == 0))
	{
    cheat_deck("sheep", "get some " + wrap($item[Stone Wool]) + ".");
    maybe_pull($item[stone wool]);
    if (!have($item[Stone Wool]))
    {
      log("Going adventuring to get some " + wrap($item[stone wool]) + ".");
      yz_adventure($location[the hidden temple], "items");
      return true;
    }
	}

	set_property("choiceAdventure582", "1");
	set_property("choiceAdventure579", "2");

  if (have_effect($effect[stone-faced]) == 0)
	{
    log("Using a " + wrap($item[stone wool]) + " to access " + wrap($location[the hidden temple]) + ".");
    use(1, $item[stone wool]);
  }

  if (have_effect($effect[stone-faced]) == 0) return false;

	log("Going to get a " + wrap($item[The Nostril of the Serpent]) + ".");

  yz_adventure($location[The Hidden Temple]);
	cli_execute("refresh inv");
	return true;
}

void L11_SQ_hidden_city_progress()
{

  if (quest_status("questL11Worship") >= 3 && quest_status("questL11Worship") < FINISHED)
  {
    if (!have($item[antique machete])) task("Find an " + wrap($item[antique machete]));
    progress(item_amount($item[stone triangle]), 4, "stone triangles from the Hidden City");

    if (quest_status("questL11Doctor") == UNSTARTED)
      progress($location[An Overgrown Shrine (Southwest)].turns_spent, 3, "defeated southwest/hospital " + wrap($monster[dense liana]));
    if (quest_status("questL11Spare") == UNSTARTED)
      progress($location[An Overgrown Shrine (Southeast)].turns_spent, 3, "defeated southeast/bowling " + wrap($monster[dense liana]));
    if (quest_status("questL11Business") == UNSTARTED)
      progress($location[An Overgrown Shrine (Northeast)].turns_spent, 3, "defeated northeast/office " + wrap($monster[dense liana]));
    if (quest_status("questL11Curses") == UNSTARTED)
      progress($location[An Overgrown Shrine (Northwest)].turns_spent, 3, "defeated northwest/apartment " + wrap($monster[dense liana]));

    int surgeon = prop_int("hiddenHospitalProgress");
    if (quest_active("questL11Doctor"))
    {
      int s = numeric_modifier("surgeonosity");
      progress(s, 5, "surgeonosity (" + (s * 10) + "% to find protector spirit)");
    }

    if (quest_active("questL11Spare"))
    {
      progress(prop_int("hiddenBowlingAlleyProgress"), 5, "bowling balls rolled");
    }

    if (quest_active("questL11Business"))
    {
      if (!have($item[McClusky file (complete)]))
      {
        if (!have($item[boring binder clip]))
        {
          task("get boring binder clip");
        }
        progress(mcclusky_items(), 5, "McClusky file pages");
      } else {
        task("fight the Protector Spirit in the Office Building");
      }
    }

    if (quest_active("questL11Curses"))
    {
      int curse = 0;
      if (have_effect($effect[once-cursed]) > 0)
        curse = 1;
      if (have_effect($effect[twice-cursed]) > 0)
        curse = 2;
      if (have_effect($effect[thrice-cursed]) > 0)
        curse = 3;
      progress(curse, 3, "curses for the penthouse");
    }

  }

}

void L11_SQ_hidden_city_cleanup()
{

}

boolean L11_SQ_hidden_city()
{
  if (my_level() < 11) return false;

  if (quest_status("questL11Worship") == UNSTARTED) return false;

  set_property("choiceAdventure581", 3); // fight clan of cave bars. Should it be something else?

  if (get_nose()) return true;

  if (quest_status("questL11Worship") < 3)
  {

    if (!have($item[Stone Wool]) && (have_effect($effect[stone-faced]) == 0))
  	{
      cheat_deck("sheep", "get some " + wrap($item[Stone Wool]) + ".");
      maybe_pull($item[stone wool]);
      if (!have($item[Stone Wool]))
      {
        log("Going adventuring to get some " + wrap($item[stone wool]) + ".");
        yz_adventure($location[the hidden temple], "items");
        return true;
      }
  	}

    if (have_effect($effect[stone-faced]) == 0)
  	{
      log("Using a " + wrap($item[stone wool]) + " to access " + wrap($location[the hidden temple]) + ".");
      use(1, $item[stone wool]);
    }

    if (have_effect($effect[stone-faced]) == 0) return false;

    log("Trying to open the " + wrap("Hidden City", COLOR_LOCATION) + ".");

    visit_url("adventure.php?snarfblat=280");
    visit_url("choice.php?whichchoice=582&option=2&pwd");
    visit_url("choice.php?whichchoice=580&option=2&pwd");
    visit_url("choice.php?whichchoice=584&option=4&pwd");
    visit_url("choice.php?whichchoice=580&option=1&pwd");
    visit_url("choice.php?whichchoice=123&option=2&pwd");
    visit_url("choice.php");
    cli_execute("dvorak");
    visit_url("choice.php?whichchoice=125&option=3&pwd");
    log(wrap("Hidden City", COLOR_LOCATION) + " unlocked");
    return true;
  }

  if (quest_status("questL11Worship") == FINISHED) return false;

  if (get_machete()) return true;

  check_stones();

  if (do_liana()) return true;
  if (bowling()) return true;
  if (hospital()) return true;
  if (office()) return true;
  if (apartment()) return true;
  if (fight_spirit()) return true;

  return false;
}

void main()
{
   L11_SQ_hidden_city();
}
