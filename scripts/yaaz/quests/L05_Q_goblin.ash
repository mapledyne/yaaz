import "util/main.ash";

void L05_Q_goblin_progress()
{
  if (quest_status("questL05Goblin") < 1
      && !have($item[Knob Goblin encryption key]))
  {
    progress($location[The Outskirts of Cobb's Knob].turns_spent, 11, "turns in the Outskirts of Cobb's Knob to get the encryption key");
  }
}

void L05_Q_goblin_cleanup()
{
  if (have($item[knob goblin elite pants])) sell_all($item[knob goblin pants]);
  if (quest_status("questL05Goblin") == FINISHED)
  {
    sell_all($item[knob goblin harem pants]);
    if (quest_status("questL04Bat") == FINISHED)
    {
      sell_all($item[knob goblin harem veil]);
    }
  }
}

string prep_for_king()
{
  if (have_outfit("Knob Goblin Harem Girl Disguise"))
  {
    if (have_effect($effect[Knob Goblin perfume]) > 0)
      return "Knob Goblin Harem Girl Disguise";
    if (item_amount($item[Knob Goblin perfume]) > 0)
    {
      log("Getting all smelly and nice for the " + wrap($monster[knob goblin king]) + ".");
      use(1, $item[Knob Goblin perfume]);
      return "Knob Goblin Harem Girl Disguise";
    }
    outfit("Knob Goblin Harem Girl Disguise");
    adv1($location[Cobb's Knob Harem], -1, "");
    return prep_for_king(); // should get the effect, but this will cause it to try again in case we get a wandering monster or something.
  } else if (have_outfit("Knob Goblin Elite Guard Uniform"))
  {
    item cake = $item[knob cake];

    while (item_amount(cake) == 0 && can_adventure())
    {
      maximize("", "Knob Goblin Elite Guard Uniform");
      yz_adventure($location[cobb's knob kitchens]);
      if (creatable_amount(cake) > 0)
      {
        create(1, cake);
      }
    }
    return "Knob Goblin Elite Guard Uniform";
  } else {
    abort("Prepping for the Goblin King, but I don't have an outfit.");
  }
  return "";
}

boolean L05_Q_goblin()
{
  L05_Q_goblin_cleanup();

  if (to_int(get_property("lastDispensaryOpen")) < my_ascensions() && have_outfit("knob goblin elite guard uniform"))
  {
    log("Opening the Knob Goblin dispensary.");
    maximize("", "knob goblin elite guard uniform");
    // there are some corner cases that won't leave us with this outfit on,
    // so force the issue. (maximizer not wanting to give up on hands-free
    // bonuses from kung fu hustler, for instance):
    outfit("knob goblin elite guard uniform");
    return yz_adventure($location[Cobb's knob barracks]);
  }

  if (item_amount($item[knob goblin encryption key]) > 0 && item_amount($item[cobb's knob map]) > 0)
  {
    log("Using the "+ wrap($item[Cobb's Knob Map]) + " to open " + wrap("Cobb's Knob", COLOR_LOCATION) + ".");
    use(1, $item[cobb's knob map]);
    return true;
  }


  if (quest_status("questL05Goblin") < 1 && !have($item[Knob Goblin encryption key]))
  {
    location outskirts = $location[the outskirts of cobb's knob];
    log("Adventuring in " + wrap(outskirts) + " to get the " + wrap($item[Knob Goblin encryption key]) + ".");
    yz_adventure(outskirts, "");
    return true;
  }

  if (quest_status("questL05Goblin") == FINISHED) return false;

  if (my_level() < 5) return false;

  if (quest_status("questL05Goblin") == UNSTARTED)
  {
    log("Going to the council to pick up the Goblin King quest.");
    council();
    return true;
  }

  if (!have_outfit("Knob Goblin Harem Girl Disguise")
      && !have_outfit("Knob Goblin Elite Guard Uniform"))
  {
    // get a disguise:

    location harem = $location[Cobb's Knob Harem];
    if (dangerous(harem))
    {
      info("Skipping the " + wrap(harem) + " for now because it's dangerous.");
      return false;
    }

    log("Off to try to get the " + wrap("Knob Goblin Harem Girl Disguise", COLOR_ITEM) + " from the " + wrap(harem) + ".");
    yz_adventure(harem, "items");
    return true;
  }

  // bail if the king is still too tough for us...
  if (dangerous($monster[knob goblin king]))
  {
    info("Skipping our assault on the " + wrap($monster[knob goblin king]) + " for now since he's dangerous.");
    return false;
  }

  string disguise = prep_for_king();

  log("Fiddling with monster's heads to get the loot we want from the " + wrap($monster[knob goblin king]) + ".");
  switch(my_primestat())
  {
    case $stat[muscle]:
      change_mcd(10);
      break;
    case $stat[moxie]:
      change_mcd(3);
      break;
    case $stat[mysticality]:
      change_mcd(7);
      break;
  }
  log("Off to fight the " + wrap($monster[knob goblin king]) + ".");
  maximize("", disguise);
  yz_adventure($location[Throne Room]);

  // TODO: Check if defeated!
  log("Going to let the council know.");
  council();

  log(wrap($monster[knob goblin king]) + " defeated.");

  return true;
}

void main()
{
  while (L05_Q_goblin());
}
