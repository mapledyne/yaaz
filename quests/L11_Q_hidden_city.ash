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

  while(quest_status("questL11Business") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Northeast)]);
  }

  while(quest_status("questL11Curses") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Northwest)]);
  }

  while(quest_status("questL11Doctor") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Southwest)]);
  }

  while(quest_status("questL11Spare") < 0)
  {
    dg_adventure($location[An Overgrown Shrine (Southeast)]);
  }

}

void hidden_city()
{
  if (quest_status("questL11Worship") < 3)
  {
    warning("This script assumes you already have opened the hidden city.");
    return;
  }

  if (quest_status("questL11Worship") > 10)
  {
    warning("You've already completed the hidden city. Horray!");
    return;
  }

  get_machete();

  do_liana();

  check_stones();
}

void main()
{
  hidden_city();
}
