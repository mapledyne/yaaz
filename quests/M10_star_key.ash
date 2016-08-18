import "util/main.ash";

boolean M10_star_key()
{
  if (quest_status("questL10Garbage") != FINISHED)
    return false;

  if (item_amount($item[steam-powered model rocketship]) == 0)
  {
    warning("Go and get the " + wrap($item[steam-powered model rocketship]) + " first.");
    warning("... this should be scripted ...");
    wait(10);
    return false;
  }

  if (item_amount($item[richard's star key]) > 0)
    return false;

  while(creatable_amount($item[richard's star key]) == 0)
  {
    dg_adventure($location[the hole in the sky], "items");
  }

  log("Creating " + wrap($item[richard's star key]) + ".");
  create(1, $item[richard's star key]);
  return true;
}

void main()
{
  M10_star_key();
}
