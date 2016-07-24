import "util/main.ash";

void get_machete()
{

  maximize("");
  while (i_a($item[antique machete]) == 0)
  {
    dg_adventure($location[hidden park]);
  }
}

void do_liana()
{
  if (i_a($item[antique machete]) == 0)
  {
    error("You need a machete before this script can continue.");
    abort();
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

  get_machete();

  do_liana();
}

void main()
{
  hidden_city();
}
