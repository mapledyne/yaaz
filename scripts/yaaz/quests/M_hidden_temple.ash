import "util/main.ash";

boolean M_hidden_temple()
{
  if (hidden_temple_unlocked())
    return false;

  if (quest_status("questL02Larva") == UNSTARTED)
  {
    log("Opening up the " + wrap($location[the spooky forest]) + " by starting the Larva quest.");
    council();
  }
  maybe_pull($item[spooky-gro fertilizer]);

  int count = my_adventures();

  log("Unlocking " + wrap($location[the hidden temple]) +".");
  if (!have($item[tree-holed coin])) {
     log("Getting the " + wrap($item[tree-holed coin]) + ".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure505", 2);
     while (!have($item[tree-holed coin]))
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
  }

  if (!have($item[Spooky-Gro fertilizer])) {
     log("Next getting the " + wrap($item[Spooky-Gro fertilizer]) +".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 2);
     while (!have($item[Spooky-Gro fertilizer]))
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
  }

  if (!have($item[spooky sapling])) {
     log("Next getting the " + wrap($item[spooky sapling]) +".");
     set_property("choiceAdventure502", 1);
     set_property("choiceAdventure503", 3);
     set_property("choiceAdventure504", 3);
     while (!have($item[spooky sapling]))
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
     set_property("choiceAdventure504", 4);
  }

  if (!have($item[Spooky Temple map])) {
      log("Next getting the " + wrap($item[Spooky Temple map]) + ".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 3);
     set_property("choiceAdventure507", 1);
     while (!have($item[Spooky Temple map]))
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
  }

  int turns = count - my_adventures();
  log("Using the " + wrap($item[spooky temple map]) + " to unlock " + wrap($location[the hidden temple]) + ".");
  if (use(1, $item[spooky temple map]))
     log("Temple unlocked! It took " + turns + " adventures.");
  else
  {
    warning("Failed to unlock the hidden temple. Unsure what to do about this.");
    abort();
  }
  return true;
}


void main()
{
  while(M_hidden_temple());
}
