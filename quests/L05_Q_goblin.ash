import "util/main.ash";


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
      dg_adventure($location[cobb's knob kitchens]);
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

  if (to_int(get_property("lastDispensaryOpen")) < my_ascensions() && have_outfit("knob goblin elite guard uniform"))
  {
    log("Opening the Knob Goblin dispensary.");
    maximize("outfit knob goblin elite guard uniform");
    return dg_adventure($location[Cobb's knob barracks]);
  }

  if (item_amount($item[knob goblin encryption key]) > 0 && item_amount($item[cobb's knob map]) > 0)
  {
    log("Using the "+ wrap($item[Cobb's Knob Map]) + " to open " + wrap("Cobb's Knob", COLOR_LOCATION) + ".");
    use(1, $item[cobb's knob map]);
  }


  if (quest_status("questL05Goblin") < 1 && item_amount($item[Knob Goblin encryption key]) == 0)
  {
    location outskirts = $location[the outskirts of cobb's knob];
    log("Adventuring in " + wrap(outskirts) + " to get the " + wrap($item[Knob Goblin encryption key]) + ".");
    while (item_amount($item[Knob Goblin encryption key]) == 0 && can_adventure())
    {
      dg_adventure(outskirts, "");
    }
  }

  if (quest_status("questL05Goblin") == FINISHED)
    return false;

  if (my_level() < 5)
    return false;

  if (quest_status("questL05Goblin") == UNSTARTED)
  {
    log("Going to the council to pick up the Goblin King quest.");
    council();
    // would not normally skip out here, but starting this over will catch the
    // code above to use the map if needed.
    return true;
  }

  if (!have_outfit("Knob Goblin Harem Girl Disguise") && !have_outfit("Knob Goblin Elite Guard Uniform"))
  {
    // get a disguise:

    location harem = $location[Cobb's Knob Harem];

    log("Off to try to get the " + wrap("Knob Goblin Harem Girl Disguise", COLOR_ITEM) + " from the " + wrap(harem) + ".");
    add_attract($monster[knob goblin harem girl]);
    while(!have_outfit("Knob Goblin Harem Girl Disguise") && can_adventure())
    {
      dg_adventure(harem, "items");
    }
    remove_attract($monster[knob goblin harem girl]);
    return true;
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
  dg_adventure($location[Throne Room]);

  // TODO: Check if defeated!
  log("Going to let the council know.");
  council();

  log(wrap($monster[knob goblin king]) + " defeated.");

  return true;
}

void main()
{
  L05_Q_goblin();
}
