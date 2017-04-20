import "util/main.ash";

boolean consume_ballroom_delay()
{
  if ($location[the haunted ballroom].turns_spent >= 5) return false;

  yz_adventure($location[the haunted ballroom], "");
  return true;
}

void M_spookyraven_cleanup()
{

}

boolean M_spookyraven()
{

  if (quest_status("questM21Dance") < 0) return false;

  if (quest_status("questM21Dance") == FINISHED)
  {
    return consume_ballroom_delay();
  }

  // bail if we're unlikely to kill things easily enough (using a representative monster):
  if (dangerous($location[the haunted bathroom])) return false;

  if (!have($item[lady spookyraven's powder puff]))
  {
    log("Going to get " + wrap($item[lady spookyraven's powder puff]) + ".");

    location bath = $location[the haunted bathroom];

    if (bath.turns_spent < 5)
    {
      maximize("");
    } else {
      maximize("-combat");
    }

    yz_adventure(bath);
    return true;
  }


  if (!have($item[lady spookyraven's finest gown])
      || !have($item[lord spookyraven's spectacles])
      || !have($item[disposable instant camera]))
  {
    log("Going to get " + wrap($item[lady spookyraven's finest gown]) + " and other things from " + wrap($location[the haunted bedroom]) + ".");

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

    if (!have($item[lady spookyraven's finest gown]))
    {
      set_property("choiceAdventure880", 1);  //gown
    } else {
      set_property("choiceAdventure880", 6);  // skip
    }

    if (!have($item[lord spookyraven's spectacles])
        || have(spooky_quest_item())
        || spooky_quest_item() == $item[none])
    {
      set_property("choiceAdventure877", 1); // coin purse
    } else {
      set_property("choiceAdventure877", 3); // quest item
    }

    if (!have($item[lord spookyraven's spectacles]))
    {
      set_property("choiceAdventure878", 3); // spectacles
    } else if (!have($item[disposable instant camera]))
    {
      set_property("choiceAdventure878", 4); // camera
    } else {
      set_property("choiceAdventure878", 2); // mysticality
    }

    maximize("", $item[lord spookyraven's spectacles]);

    yz_adventure(bed);
    cli_execute("choice-goal");
    cli_execute("choice-goal");

    return true;
  }

  if (!have($item[lady spookyraven's dancing shoes]))
  {
    log("Going to get " + wrap($item[lady spookyraven's dancing shoes]) + ".");
    location gallery = $location[the haunted gallery];
    set_property("louvreDesiredGoal", 7); // dancing shoes

    if (gallery.turns_spent < 5)
    {
      maximize("");
    } else {
      maximize("-combat");
    }

    yz_adventure(gallery);
    return true;
  }

  set_property("louvreDesiredGoal", 10); // prime stat

  if (dancing_items() != 3)
  {
    error("Unsure what happened - we don't have all of Lady Spookyraven's dancing things.");
    wait(10);
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
