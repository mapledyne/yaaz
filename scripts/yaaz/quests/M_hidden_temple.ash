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
  if (!have($item[tree-holed coin]))
  {
     log("Getting the " + wrap($item[tree-holed coin]) + ".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure505", 2);

      yz_adventure($location[The Spooky Forest], "-combat");
      return true;
  }

  if (!have($item[Spooky-Gro fertilizer]))
  {
     log("Next getting the " + wrap($item[Spooky-Gro fertilizer]) +".");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 2);

     yz_adventure($location[The Spooky Forest], "-combat");
     return true;
  }

  if (!have($item[spooky sapling]))
  {
    log("Next getting the " + wrap($item[spooky sapling]) +".");
    set_property("choiceAdventure502", 1);
    set_property("choiceAdventure503", 3);
    set_property("choiceAdventure504", 3);

    yz_adventure($location[The Spooky Forest], "-combat");
    return true;

  }

  debug("Todo: Sell Bar Skins instead of just skipping out.");
  set_property("choiceAdventure504", 4);

  if (!have($item[Spooky Temple map]))
  {
    log("Next getting the " + wrap($item[Spooky Temple map]) + ".");
    set_property("choiceAdventure502", 2);
    set_property("choiceAdventure506", 3);
    set_property("choiceAdventure507", 1);
    yz_adventure($location[The Spooky Forest], "-combat");
    return true;
  }

  log("Using the " + wrap($item[spooky temple map]) + " to unlock " + wrap($location[the hidden temple]) + ".");
  use(1, $item[spooky temple map]);
  return true;
}


void main()
{
  while(M_hidden_temple());
}
