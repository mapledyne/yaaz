import "util/yz_main.ash";

void M10_star_key_progress()
{
  if (!have($item[steam-powered model rocketship])) return;
  if (have($item[richard's star key])) return;
  if (quest_status("questL13Final") >= 5) return;

  int star = min(item_amount($item[star]), 8);
  int line = min(item_amount($item[line]), 7);
  int chart = min(item_amount($item[star chart]), 1);
  int key_total = star + line + chart;
  string key_msg = " ("+star+ " " + wrap($item[star], star) + ", " + line + " " + wrap($item[line], line) + ", " + chart + " " + wrap($item[star chart], chart) + ")";
  progress(key_total, 16, "make " + wrap($item[richard's star key]) + key_msg);
}

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

  if (quest_status("questL10Garbage") != FINISHED) return false;

  if (have($item[richard's star key])) return false;

  if (!have($item[steam-powered model rocketship])) return false;

  if (quest_status("questL13Final") > 3) return false;

  if (dangerous($location[the hole in the sky]))
  {
    info("Skipping the " + wrap($location[the hole in the sky]) + " until it's less dangerous.");
    return false;
  }

  log("Going to the " + wrap($location[the hole in the sky]) + " to make " + wrap($item[richard's star key]) + ".");

  familiar fam = $familiar[none];
  if (can_adventure_with_familiar($familiar[space jellyfish]))
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
