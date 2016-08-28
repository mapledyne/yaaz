import "util/main.ash";
import "quests/M_pirates.ash";
import "util/adventure.ash";
import "util/requirements.ash";

boolean get_talisman()
{
  if (i_a($item[pirate fledges]) == 0)
    return false;

  if (i_a($item[Talisman o' Namsilat]) > 0)
    return false;

  if (quest_status("questM12Pirate") != FINISHED)
  {
    open_belowdecks();
    return true;
  }

  while(item_amount($item[Talisman o' Namsilat]) == 0)
  {
    maximize("items", $item[pirate fledges]);
    dg_adventure($location[belowdecks]);
    build_requirements();
  }
  return true;
}

boolean L11_Q_palindome()
{
  if (get_talisman())
    return true;

  return false;
}

void main()
{
  L11_Q_palindome();
}
