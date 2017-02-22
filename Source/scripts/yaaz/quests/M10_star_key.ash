import "util/main.ash";

boolean M10_star_key()
{
  if (quest_status("questL10Garbage") != FINISHED)
    return false;

  if (have($item[richard's star key]))
    return false;

  if (!have($item[steam-powered model rocketship]))
    return false;

  if (quest_status("questL13Final") > 3)
    return false;

  log("Going to the " + wrap($location[the hole in the sky]) + " to make " + wrap($item[richard's star key]) + ".");

  while(creatable_amount($item[richard's star key]) == 0)
  {
    if (have($item[star chart]) && my_familiar() == $familiar[space jellyfish])
    {
      set_property("choiceAdventure1221", 2); // astronomer (/star chart)
    } else {
      set_property("choiceAdventure1221", 1); // skin flute (/stars + lines)
    }

    boolean b = yz_adventure($location[the hole in the sky], "items");
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
