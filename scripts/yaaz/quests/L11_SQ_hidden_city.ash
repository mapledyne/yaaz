import "util/main.ash";
import "util/iotm/deck.ash";

void check_stones()
{
  set_property("choiceAdventure781", 1);
  set_property("choiceAdventure783", 1);
  set_property("choiceAdventure785", 1);
  set_property("choiceAdventure787", 1);

  if (item_amount($item[scorched stone sphere]) > 0)
  {
    yz_adventure($location[An Overgrown Shrine (Southeast)]);
  }

  if (item_amount($item[crackling stone sphere]) > 0)
  {
    yz_adventure($location[An Overgrown Shrine (Northeast)]);
  }

  if (item_amount($item[dripping stone sphere]) > 0)
  {
    yz_adventure($location[An Overgrown Shrine (Southwest)]);
  }

  if (item_amount($item[moss-covered stone sphere]) > 0)
  {
    yz_adventure($location[An Overgrown Shrine (Northwest)]);
  }
}


void get_machete()
{
  if (have($item[antique machete]))
  {
    return;
  }

  maximize("");
  while (!have($item[antique machete]))
  {
    boolean b = yz_adventure($location[the hidden park]);
    if (!b)
      return;
  }
}

boolean do_liana()
{
  maybe_pull($item[antique machete]);
  if (!have($item[antique machete]) || my_path() == "Way of the Surprising Fist")
  {
    return false;
  }

  if (quest_status("questL11Business") > -1
      && quest_status("questL11Curses") > -1
      && quest_status("questL11Doctor") > -1
      && quest_status("questL11Spare") > -1)
  {
    return false;
  }

  maximize("");

  if (my_path() != "Way of the Surprising Fist")
  {
    equip($slot[weapon], $item[antique machete]);
  }

  if(quest_status("questL11Business") < 0)
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Northeast)]) + ".");
  while(quest_status("questL11Business") < 0)
  {
    yz_adventure($location[An Overgrown Shrine (Northeast)]);
  }

  if (quest_status("questL11Curses") < 0)
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Northwest)]) + ".");
  while(quest_status("questL11Curses") < 0)
  {
    yz_adventure($location[An Overgrown Shrine (Northwest)]);
  }

  if (quest_status("questL11Doctor") < 0)
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Southwest)]) + ".");
  while(quest_status("questL11Doctor") < 0)
  {
    yz_adventure($location[An Overgrown Shrine (Southwest)]);
  }

  if (quest_status("questL11Spare") < 0)
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Southeast)]) + ".");
  while(quest_status("questL11Spare") < 0)
  {
    yz_adventure($location[An Overgrown Shrine (Southeast)]);
  }

  if ($location[A Massive Ziggurat].turns_spent < 3)
    log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[A massive Ziggurat]) + ".");
  while ($location[A Massive Ziggurat].turns_spent < 3)
  {
    yz_adventure($location[A Massive Ziggurat]);
  }

  return false;
}

boolean bowling()
{
  if (to_int(get_property("hiddenBowlingAlleyProgress")) < 1)
  {
    return false;
  }
  if (to_int(get_property("hiddenBowlingAlleyProgress")) > 6)
  {
    return false;
  }

  log("Defeating " + wrap($location[the hidden bowling alley]) + ".");
  add_attract($monster[pygmy bowler]);
  while(to_int(get_property("hiddenBowlingAlleyProgress")) < 6)
  {
    if(item_amount($item[Bowl Of Scorpions]) == 0 && my_ascensions() <= to_int(get_property("hiddenTavernUnlock")))
    {
      log("Buying a " + wrap($item[Bowl Of Scorpions]) + " to get away from a " + wrap($monster[drunk pygmy]) + ".");
      buy(1, $item[Bowl Of Scorpions]);
    }
    yz_adventure($location[the hidden bowling alley], "items");
  }
  remove_attract($monster[pygmy bowler]);
  while(item_amount($item[bowling ball]) == 0)
  {
    yz_adventure($location[the hidden bowling alley], "items");
  }

  log("Off to defeat the " + wrap($monster[ancient protector spirit]) + ".");
  yz_adventure($location[the hidden bowling alley], "elemental dmg");

  return true;
}

boolean hospital()
{
  if (to_int(get_property("hiddenHospitalProgress")) < 1)
    return false;

  if (to_int(get_property("hiddenHospitalProgress")) > 6)
    return false;

  log("Defeating " + wrap($location[the hidden hospital]) + ".");
  add_attract($monster[pygmy witch surgeon]);
  while(to_int(get_property("hiddenHospitalProgress")) < 6)
  {
    maximize("mainstat, +effective, elemental dmg, 50 surgeonosity");
    yz_adventure($location[the hidden hospital]);
  }
  remove_attract($monster[pygmy witch surgeon]);
  log(wrap($location[the hidden hospital]) + " cleared.");
  return true;
}

boolean office()
{
  if (to_int(get_property("hiddenOfficeProgress")) < 1)
    return false;

  if (to_int(get_property("hiddenOfficeProgress")) > 6)
    return false;

  log("Defeating " + wrap($location[the hidden office building]) + ".");
  add_attract($monster[pygmy witch accountant]);
  while(to_int(get_property("hiddenOfficeProgress")) < 6)
  {
    int turns = $location[the hidden office building].turns_spent % 5;
    if (item_amount($item[boring binder clip]) > 0
        && item_amount($item[McClusky file (complete)]) == 0
        && turns == 0
        && quest_status("questL11Curses") != FINISHED)
    {
      log("Trying to get the rest of the " + wrap("McClusky File", COLOR_ITEM) + " from the " + wrap($location[the hidden apartment building]));
      return false;
    }
    yz_adventure($location[the hidden office building], "");
  }
  remove_attract($monster[pygmy witch accountant]);
  log(wrap($location[the hidden office building]) + " cleared.");
  return true;
}

boolean apartment()
{
  if (to_int(get_property("hiddenApartmentProgress")) < 1)
    return false;

  if (to_int(get_property("hiddenApartmentProgress")) > 6)
    return false;

  log("Defeating " + wrap($location[the hidden apartment building]) + ".");
  if (get_property("olfactedMonster") != $monster[pygmy witch accountant]
      || quest_status("questL11Business") == FINISHED)
  {
    add_attract($monster[pygmy shaman]);
  }

  if (to_int(get_property("hiddenTavernUnlock")) < my_ascensions()
      && !have($item[book of matches]))
  {
    maybe_pull($item[book of matches]);
  }


  while(to_int(get_property("hiddenApartmentProgress")) < 6)
  {
    if (have_effect($effect[twice-cursed]) > 0
        && to_int(get_property("hiddenTavernUnlock")) == my_ascensions())
    {
      log("Trying to drink a " + wrap($item[cursed punch]) + " for the extra curse.");
      try_consume($item[cursed punch]);
    }
    yz_adventure($location[the hidden apartment building], "");
  }
  remove_attract($monster[pygmy shaman]);
  log(wrap($location[the hidden apartment building]) + " cleared.");
  vip_hottub(); // remove curses if hottub available
  return true;
}

boolean fight_spirit()
{
  if (quest_status("questL11Worship") != 4)
  {
    return false;
  }

  log("Fighting the " + wrap($monster[Protector Spectre]) + ".");
  yz_adventure($location[A Massive Ziggurat], "elemental damage");
  run_combat('yz_consult');
  return true;
}

boolean get_nose()
{
	if(quest_status("questL11Worship") != 1)
		return false;

	if(have($item[The Nostril of the Serpent]))
		return false;

  if((!have($item[Stone Wool])) && (have_effect($effect[stone-faced]) == 0))
	{
    cheat_deck("sheep", "get some " + wrap($item[Stone Wool]) + ".");
    maybe_pull($item[stone wool]);
    if (item_amount($item[Stone Wool]) == 0)
    {
      warning("Going adventuring to get some " + wrap($item[stone wool]) + ". We should have gotten this in advance.");
      while(can_adventure() && item_amount($item[stone wool]) == 0)
      {
        boolean b = yz_adventure($location[the hidden temple], "items");
        if (!b)
          return true;
      }
    }
	}
	set_property("choiceAdventure582", "1");
	set_property("choiceAdventure579", "2");

  if (have_effect($effect[stone-faced]) == 0)
	{
    log("Using a " + wrap($item[stone wool]) + " to access " + wrap($location[the hidden temple]) + ".");
    use(1, $item[stone wool]);
  }

  if (have_effect($effect[stone-faced]) == 0)
    return false;

	log("Going to get a " + wrap($item[The Nostril of the Serpent]) + ".");

  yz_adventure($location[The Hidden Temple]);
	cli_execute("refresh inv");
	return true;
}

boolean L11_SQ_hidden_city()
{
  if (my_level() < 11)
    return false;

  if (quest_status("questL11Worship") == UNSTARTED)
    return false;

  if (get_nose()) return true;

  if (quest_status("questL11Worship") < 3)
  {

    if((item_amount($item[Stone Wool]) == 0) && (have_effect($effect[stone-faced]) == 0))
  	{
      cheat_deck("sheep", "get some " + wrap($item[Stone Wool]) + ".");
      maybe_pull($item[stone wool]);
      if (item_amount($item[Stone Wool]) == 0)
      {
        warning("Going adventuring to get some " + wrap($item[stone wool]) + ". We should have gotten this in advance.");
        while(can_adventure() && item_amount($item[stone wool]) == 0)
        {
          boolean b = yz_adventure($location[the hidden temple], "items");
          if (!b)
            return true;
        }
      }
  	}

    if (have_effect($effect[stone-faced]) == 0)
  	{
      log("Using a " + wrap($item[stone wool]) + " to access " + wrap($location[the hidden temple]) + ".");
      use(1, $item[stone wool]);
    }

    if (have_effect($effect[stone-faced]) == 0)
      return false;

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

  if (quest_status("questL11Worship") == FINISHED)
    return false;

  if (my_path() != "Way of the Surprising Fist")
    get_machete();

  check_stones();

  if (do_liana()) return true;
  if (bowling()) return true;
  if (hospital()) return true;
  if (office()) return true;
  if (apartment()) return true;

  check_stones();

  if (fight_spirit()) return true;

  return false;
}

void main()
{
  L11_SQ_hidden_city();
}
