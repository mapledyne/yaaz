import "util/main.ash";

void M10_star_key_cleanup()
{
  if (!have($item[richard's star key])
      && quest_status("questL13Final") < 6)
  {
    if (item_amount($item[star]) >= 8
        && item_amount($item[line]) >= 7)
    {
      maybe_pull($item[star chart]);
    }

    if (creatable_amount($item[richard's star key]) > 0)
    {
      log("Creating " + wrap($item[richard's star key]) + ".");
      create(1, $item[richard's star key]);
    }
  }

}

boolean M10_star_key()
{

  M10_star_key_cleanup();

  if (quest_status("questL10Garbage") != FINISHED) return false;

  if (have($item[richard's star key])) return false;

  if (!have($item[steam-powered model rocketship])) return false;

  if (quest_status("questL13Final") > 3) return false;

  log("Going to the " + wrap($location[the hole in the sky]) + " to make " + wrap($item[richard's star key]) + ".");

  familiar fam = $familiar[none];
  if (have_familiar($familiar[space jellyfish]))
    fam = $familiar[space jellyfish];
  maximize("items", fam);

  if (!have($item[star chart]) && my_familiar() == $familiar[space jellyfish])
  {
    set_property("choiceAdventure1221", 2); // astronomer (/star chart)
  } else {
    set_property("choiceAdventure1221", 1); // skin flute (/stars + lines)
  }

  yz_adventure($location[the hole in the sky]);
  return true;
}

void main()
{
  while(M10_star_key());
}
