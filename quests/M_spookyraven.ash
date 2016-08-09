import "util/main.ash";

int dancing_items()
{
  return item_amount($item[lady spookyraven's powder puff]) + item_amount($item[lady spookyraven's dancing shoes]) + item_amount($item[lady spookyraven's finest gown]);
}

void go_dancing()
{
  if (quest_status("questM21Dance") < 0)
  {
    warning("Need to get Lady Spookyraven's telegram first.");
    return;
  }
  if (quest_status("questM21Dance") == 0)
  {
    warning("Speak to Lady Spookyraven on the second floor.");
    return;
  }
  if (quest_status("questM21Dance") == FINISHED)
  {
    warning("You've already danced with Lady Spookyraven.");
    return;
  }

  if (item_amount($item[lady spookyraven's powder puff]) == 0)
  {
    log("Going to get " + wrap($item[lady spookyraven's powder puff]) + ".");
  }
  while (item_amount($item[lady spookyraven's powder puff]) == 0)
  {
    location bath = $location[the haunted bathroom];

    if (bath.turns_spent < 5)
    {
      maximize("");
    } else {
      maximize("-combat");
    }

    dg_adventure(bath);
    progress(dancing_items(), 3, "dancing things found");
  }

  if (item_amount($item[lady spookyraven's finest gown]) == 0)
  {
    log("Going to get " + wrap($item[lady spookyraven's finest gown]) + " and other things from " + wrap($location[the haunted bedroom]) + ".");
  }

  while (item_amount($item[lady spookyraven's finest gown]) == 0 || item_amount($item[lord spookyraven's spectacles]) == 0 || item_amount($item[disposable instant camera]) == 0)
  {

    location bed = $location[the haunted bedroom];

    if (my_primestat() == $stat[muscle])
    {
      set_property("choiceAdventure876", 2); // muscle
    } else {
      set_property("choiceAdventure876", 4); // ignore it
    }

    if (my_primestat() == $stat[moxie])
    {
      set_property("choiceAdventure876", 1); // moxie
    } else {
      set_property("choiceAdventure876", 6); // ignore it
    }

    if (item_amount($item[lady spookyraven's finest gown]) == 0)
    {
      set_property("choiceAdventure880", 1);  //gown
    } else {
      set_property("choiceAdventure880", 6);  // skip
    }

    if (item_amount($item[lord spookyraven's spectacles]) == 0 || item_amount(spooky_quest_item()) > 0 || spooky_quest_item() == $item[none])
    {
      set_property("choiceAdventure877", 1); // coin purse
    } else {
      set_property("choiceAdventure877", 3); // quest item
    }

    if (i_a($item[lord spookyraven's spectacles]) == 0)
    {
      set_property("choiceAdventure878", 3); // spectacles
    } else if (item_amount($item[disposable instant camera]) == 0)
    {
      set_property("choiceAdventure878", 4); // camera
    } else {
      set_property("choiceAdventure878", 2); // mysticality
    }

    if (i_a($item[lord spookyraven's spectacles]) > 0)
    {
      maximize("equip lord spookyraven's spectacles");
    } else {
      maximize();
    }

    dg_adventure(bed);
    progress(dancing_items(), 3, "dancing things found");
  }

  if (item_amount($item[lady spookyraven's dancing shoes]) == 0)
  {
    log("Going to get " + wrap($item[lady spookyraven's dancing shoes]) + ".");
  }
  while (item_amount($item[lady spookyraven's dancing shoes]) == 0)
  {
    location gallery = $location[the haunted gallery];
    set_property("louvreDesiredGoal", 7); // dancing shoes

    if (gallery.turns_spent < 5)
    {
      maximize("");
    } else {
      maximize("-combat");
    }

    dg_adventure(gallery);
    progress(dancing_items(), 3, "dancing things found");
  }
  
  set_property("louvreDesiredGoal", 10); // prime stat

  log("Dancing items complete.");

}

void main()
{
  go_dancing();
}
