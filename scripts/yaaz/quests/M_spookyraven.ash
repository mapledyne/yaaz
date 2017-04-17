import "util/main.ash";

boolean consume_ballroom_delay()
{
  if ($location[the haunted ballroom].turns_spent >= 5) return false;

  while ($location[the haunted ballroom].turns_spent < 5)
  {
    boolean b = yz_adventure($location[the haunted ballroom], "");
    if (!b) return true;
  }
  return true;
}

boolean M_spookyraven()
{

  if (quest_status("questM21Dance") < 0)
  {
    return false;
  }

  if (quest_status("questM21Dance") == FINISHED)
  {
    return consume_ballroom_delay();
  }

  // bail if we're unlikely to kill things easily enough (using a representative monster):
  if (expected_damage($monster[malevolent hair clog]) > my_maxhp() / 10)
    return false;

  if (item_amount($item[lady spookyraven's powder puff]) == 0)
    log("Going to get " + wrap($item[lady spookyraven's powder puff]) + ".");

  while (item_amount($item[lady spookyraven's powder puff]) == 0)
  {
    location bath = $location[the haunted bathroom];

    if (bath.turns_spent < 5)
    {
      maximize("");
    } else {
      maximize("-combat");
    }

    boolean b = yz_adventure(bath);
    if (!b)
      return true;
  }

  if (item_amount($item[lady spookyraven's finest gown]) == 0)
    log("Going to get " + wrap($item[lady spookyraven's finest gown]) + " and other things from " + wrap($location[the haunted bedroom]) + ".");

  while (item_amount($item[lady spookyraven's finest gown]) == 0 || i_a($item[lord spookyraven's spectacles]) == 0 || item_amount($item[disposable instant camera]) == 0)
  {

    location bed = $location[the haunted bedroom];

    if (my_primestat() == $stat[muscle])
    {
      set_property("choiceAdventure876", 2); // muscle
    } else {
      set_property("choiceAdventure876", 6); // ignore it
    }

    if (my_primestat() == $stat[moxie])
    {
      set_property("choiceAdventure879", 1); // moxie
    } else {
      set_property("choiceAdventure879", 6); // ignore it
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

    boolean b = yz_adventure(bed);
    cli_execute("choice-goal");
    cli_execute("choice-goal");

    if (!b)
      return true;
  }

  if (item_amount($item[lady spookyraven's dancing shoes]) == 0)
    log("Going to get " + wrap($item[lady spookyraven's dancing shoes]) + ".");

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

    boolean b = yz_adventure(gallery);
    if (!b)
      return true;
  }

  set_property("louvreDesiredGoal", 10); // prime stat

  if (dancing_items() != 3)
  {
    warning("Unsure what happened - we don't have all of Lady Spookyraven's dancing things.");
    return true;
  }

  log("Dancing items found. Returning them.");

  visit_url("place.php?whichplace=manor2&action=manor2_ladys");

  yz_adventure($location[the haunted ballroom]);
  log("Dancing complete!");
  return true;
}

void main()
{
  while(M_spookyraven());
}
