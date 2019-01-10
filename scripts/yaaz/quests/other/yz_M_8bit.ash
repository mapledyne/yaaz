import "util/yz_main.ash";

void M_8bit_progress()
{
  if (!have($item[continuum transfunctioner]))
  {
    task("Get the " + wrap($item[continuum transfunctioner]));
    return;
  }

  if (!have($item[digital key])
      && quest_status("questL13Final") < 5)
  {
    progress(item_amount($item[white pixel]), 30, "make a " + wrap($item[digital key]));
  }

  if (item_amount($item[red pixel potion]) < 5
      && quest_status("questL13Final") < 11
      && !have_skill($skill[ambidextrous funkslinging]))
  {
    progress(item_amount($item[red pixel potion]), 5, wrap($item[red pixel potion], 5) + " for " + wrap($monster[your shadow]));
  }
}

void M_8bit_cleanup()
{
  while (!have($item[digital key])
         && creatable_amount($item[digital key]) == 0
         && creatable_amount($item[white pixel]) > 0
         && quest_status("questL13Final") < 6)
  {
    log("Making a " + wrap($item[white pixel]) + " to help us make a " + $item[digital key] + ".");
    create(1, $item[white pixel]);
  }

  if (!have($item[digital key])
      && creatable_amount($item[digital key]) > 0
      && quest_status("questL13Final") < 6)
  {
    log("Making a " + wrap($item[digital key]) + ".");
    create(1, $item[digital key]);
  }

  if (have($item[digital key]))
  {
    sell_all($item[Blue Pixel]);
    sell_all($item[Green Pixel]);
    sell_all($item[White Pixel]);
  }

  if (have_skill($skill[Ambidextrous Funkslinging]))
  {
    sell_all($item[black pixel]);
    if (have($item[digital key]))
    {
      sell_all($item[Red Pixel]);
    }
  } else {
    // no funkslinging

    // Theoretically could sell off pixels when we have enough potions,
    // but we should stop farming when we have enough. If we end up with
    // enough to make an extra one, we'd do it - then if we lose to the
    // shadow we won't have sold resources we could use.

    if (creatable_amount($item[red pixel potion]) > 0)
    {
      make_all($item[red pixel potion], "to help fight the shadow");
    }
    // shadow defeated:
    if (quest_status("questL13Final") > 10)
    {
      sell_all($item[black pixel]);
      sell_all($item[Red Pixel]);
    }
  }
}

boolean continuum()
{
  if (have($item[continuum transfunctioner])
      || quest_status("questL02Larva") == UNSTARTED)
    return false;

  log("Going to get the " + wrap($item[continuum transfunctioner]) + " from the mystic.");

  visit_url("place.php?whichplace=forestvillage&action=fv_mystic");
  visit_url("choice.php?pwd="+my_hash()+"&whichchoice=664&option=1&choiceform1=Sure%2C+old+man.++Tell+me+all+about+it.");
  visit_url("choice.php?pwd="+my_hash()+"&whichchoice=664&option=1&choiceform1=Against+my+better+judgment%2C+yes.");
  visit_url("choice.php?pwd="+my_hash()+"&whichchoice=664&option=1&choiceform1=Er,+sure,+I+guess+so...");

  return false;
}

boolean M_8bit()
{
  if (continuum()) return true;

  if (!have($item[continuum transfunctioner])) return false;

  if (dangerous($location[8-bit realm]))
  {
    log("Skipping the " + wrap($location[8-bit realm]) + " until it's safer.");
    return false;
  }

  if (!have_skill($skill[Ambidextrous Funkslinging])
      && quest_status("questL13Final") < 11)
  {
    if (item_amount($item[red pixel potion]) < 5)
    {
      log("Because you don't have " + wrap($skill[Ambidextrous Funkslinging]) + ", I'm going to collect some " + wrap($item[red pixel potion], 2) + ".");
      log("Consider making this skill permanent as soon as you can to improve your experience with " + wrap($monster[your shadow]) + ".");
      debug("Todo: check to see if a scented massage oil would be better than these potions.");
      maximize("items", $item[continuum transfunctioner]);
      yz_adventure($location[8-bit realm]);
      return true;
    }
  }

  if (have($item[digital key])) return false;

  // ... or if we've used the key already ...
  if (quest_status("questL13Final") > 5) return false;

  maximize("items", $item[continuum transfunctioner]);
  if (time_combat($monster[blooper], $location[8-bit realm])) return true;
  if (bottle_wish($monster[blooper])) return true;
  monster_attract = $monsters[blooper];

  yz_adventure($location[8-bit realm]);

  return true;
}

void main()
{
  while(M_8bit());
}
