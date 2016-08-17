import "util/main.ash";
import "quests/M_pirates.ash";
import "util/adventure.ash";

void get_talisman()
{
  if (i_a($item[pirate fledges]) == 0)
  {
    warning("Palindome quest can't start until you have at least the " + wrap($item[pirate fledges]) + ".");
    return;
  }

  if (quest_status("questM12Pirate") != FINISHED)
  {
    open_belowdecks();
  }
abort();
  while(item_amount($item[Talisman o' Namsilat]) == 0)
  {
    maximize("items", $item[pirate fledges]);
    dg_adventure($location[belowdecks]);
  }
}

void palindome()
{
  get_talisman();
}

void main()
{
  palindome();
}
