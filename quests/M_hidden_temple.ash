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

  int count = my_adventures();

  log("Unlocking " + wrap($location[the hidden temple]) +".");
  if (item_amount($item[tree-holed coin]) < 1) {
     log("Getting the " + wrap($item[tree-holed coin]) + ".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure505", 2);
     while (item_amount($item[tree-holed coin]) < 1)
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
  }

  if (item_amount($item[Spooky-Gro fertilizer]) < 1) {
     log("Next getting the " + wrap($item[Spooky-Gro fertilizer]) +".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 2);
     while (item_amount($item[Spooky-Gro fertilizer]) < 1)
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
  }

  if (item_amount($item[spooky sapling]) < 1) {
     log("Next getting the " + wrap($item[spooky sapling]) +".");
     set_property("choiceAdventure502", 1);
     set_property("choiceAdventure503", 3);
     set_property("choiceAdventure504", 3);
     while (item_amount($item[spooky sapling]) < 1)
     {
        if (!yz_adventure($location[The Spooky Forest], "-combat"))
          return true;
     }
     set_property("choiceAdventure504", 4);
  }

  if (item_amount($item[Spooky Temple map]) < 1) {
      log("Next getting the " + wrap($item[Spooky Temple map]) + ".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 3);
     set_property("choiceAdventure507", 1);
     while (item_amount($item[Spooky Temple map]) < 1)
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
  M_hidden_temple();
}
