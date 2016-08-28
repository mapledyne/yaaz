import "util/main.ash";


void check_stones()
{
  set_property("choiceAdventure781", 1);
  set_property("choiceAdventure783", 1);
  set_property("choiceAdventure785", 1);
  set_property("choiceAdventure787", 1);

  if (item_amount($item[scorched stone sphere]) > 0)
  {
    dg_adventure($location[An Overgrown Shrine (Southeast)]);
  }

  if (item_amount($item[crackling stone sphere]) > 0)
  {
    dg_adventure($location[An Overgrown Shrine (Northeast)]);
  }

  if (item_amount($item[dripping stone sphere]) > 0)
  {
    dg_adventure($location[An Overgrown Shrine (Southwest)]);
  }

  if (item_amount($item[moss-covered stone sphere]) > 0)
  {
    dg_adventure($location[An Overgrown Shrine (Northwest)]);
  }
}


void get_machete()
{
  if (i_a($item[antique machete]) > 0)
  {
    return;
  }

  maximize("");
  while (i_a($item[antique machete]) == 0)
  {
    dg_adventure($location[the hidden park]);
  }
}

void do_liana()
{
  if (i_a($item[antique machete]) == 0)
  {
    error("You need a machete before this script can continue.");
    abort();
  }

  if (quest_status("questL11Business") > -1 && quest_status("questL11Curses") > -1 && quest_status("questL11Doctor") > -1 && quest_status("questL11Spare") > -1)
  {
    return;
  }

  maximize("");
  equip($item[antique machete]);

  log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Northeast)]) + ".");
  while(quest_status("questL11Business") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Northeast)]);
  }

  log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Northwest)]) + ".");
  while(quest_status("questL11Curses") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Northwest)]);
  }

  log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Southwest)]) + ".");
  while(quest_status("questL11Doctor") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Southwest)]);
  }

  log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[An Overgrown Shrine (Southeast)]) + ".");
  while(quest_status("questL11Spare") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Southeast)]);
  }

  log("Clearing out the " + wrap($monster[dense liana]) + " from " + wrap($location[A massive Ziggurat]) + ".");
  while ($location[A Massive Ziggurat].turns_spent < 3)
  {
    dg_adventure($location[A Massive Ziggurat]);
  }

}

void bowling()
{
  if (to_int(get_property("hiddenBowlingAlleyProgress")) < 1)
  {
    error("Open " + wrap($location[the hidden bowling alley]) + " first.");
    return;
  }
  if (to_int(get_property("hiddenBowlingAlleyProgress")) > 6)
  {
    return;
  }

  log("Defeating " + wrap($location[the hidden bowling alley]) + ".");
  add_attract($monster[pygmy bowler]);
  while(to_int(get_property("hiddenBowlingAlleyProgress")) < 6)
  {
    dg_adventure($location[the hidden bowling alley], "items");
    progress(to_int(get_property("hiddenBowlingAlleyProgress")) - 1, 5, "bowling balls found");
  }
  remove_attract($monster[pygmy bowler]);
  while(item_amount($item[bowling ball]) == 0)
  {
    dg_adventure($location[the hidden bowling alley], "items");
    progress(to_int(get_property("hiddenBowlingAlleyProgress")) - 1, 5, "bowling balls found");
  }

  log("Off to defeat the " + wrap($monster[ancient protector spirit]) + ".");
  dg_adventure($location[the hidden bowling alley], "elemental dmg");

}

void hospital()
{
  if (to_int(get_property("hiddenHospitalProgress")) < 1)
  {
    error("Open " + wrap($location[the hidden hospital]) + " first.");
    return;
  }
  if (to_int(get_property("hiddenHospitalProgress")) > 6)
    return;

  log("Defeating " + wrap($location[the hidden hospital]) + ".");

  add_attract($monster[pygmy witch surgeon]);
  while(to_int(get_property("hiddenHospitalProgress")) < 6)
  {
    maximize("mainstat, +effective, elemental dmg, 50 surgeonosity");
    dg_adventure($location[the hidden hospital]);
  }
  remove_attract($monster[pygmy witch surgeon]);
  log(wrap($location[the hidden hospital]) + " cleared.");
}

boolean L11_Q_hidden_city()
{
  if (my_level() < 11)
    return false;

  if (quest_status("questL11Worship") < 3)
  {
    warning("This script assumes you already have opened the hidden city.");
    wait(10);
    return false;
  }

  if (quest_status("questL11Worship") == FINISHED)
    return false;

  get_machete();

  do_liana();

  check_stones();

  bowling();

  check_stones();

  hospital();

  check_stones();

  return true;
}

void main()
{
  L11_Q_hidden_city();
}
