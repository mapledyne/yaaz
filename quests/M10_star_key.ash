import "util/main.ash";

boolean M10_star_key()
{
  if (quest_status("questL10Garbage") != FINISHED)
    return false;

  if (item_amount($item[richard's star key]) > 0)
    return false;

  if (item_amount($item[steam-powered model rocketship]) == 0)
    return false;

  if (quest_status("questL13Final") > 3)
    return false;

  log("Going to the " + wrap($location[the hole in the sky]) + " to make " + wrap($item[richard's star key]) + ".");

  while(creatable_amount($item[richard's star key]) == 0)
  {
    boolean b = dg_adventure($location[the hole in the sky], "items");
    if (!b)
      return true;
  }

  log("Creating " + wrap($item[richard's star key]) + ".");
  create(1, $item[richard's star key]);
  return true;
}

void main()
{
  M10_star_key();
}
