import "util/main.ash";

void unlock_temple()
{
  if (hidden_temple_unlocked())
  {
    log("You have already unlocked the hidden temple!");
    return;
  }

  int count = my_adventures();

  log("Unlocking the hidden temple.");
  if (item_amount($item[tree-holed coin]) < 1) {
     log("Getting the tree-holed coin");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure505", 2);
     while (item_amount($item[tree-holed coin]) < 1)
     {
        maximize("noncombat");
        dg_adventure($location[The Spooky Forest]);
     }
  }

  if (item_amount($item[Spooky-Gro fertilizer]) < 1) {
     log("Next getting the spooky-gro fertilizer.");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 2);
     while (item_amount($item[Spooky-Gro fertilizer]) < 1)
     {
        maximize("noncombat");
        dg_adventure($location[The Spooky Forest]);
     }
  }

  if (item_amount($item[spooky sapling]) < 1) {
     log("Next getting the spooky sapling.");
     set_property("choiceAdventure502", 1);
     set_property("choiceAdventure503", 3);
     set_property("choiceAdventure504", 3);
     while (item_amount($item[spooky sapling]) < 1)
     {
        maximize("noncombat");
        dg_adventure($location[The Spooky Forest]);
     }
     set_property("choiceAdventure504", 4);
  }

  if (item_amount($item[Spooky Temple map]) < 1) {
      log("Next getting the spooky temple map.");
     set_property("choiceAdventure502", 2);
     set_property("choiceAdventure506", 3);
     set_property("choiceAdventure507", 1);
     while (item_amount($item[Spooky Temple map]) < 1)
     {
        maximize("noncombat");
        dg_adventure($location[The Spooky Forest]);
     }
  }

  int turns = count - my_adventures();
  if (use(1, $item[spooky temple map]))
     log("Temple unlocked! It took " + turns + " adventures.");
  else warning("Failed to unlock the hidden temple.");

}


void main()
{
  unlock_temple();
}
