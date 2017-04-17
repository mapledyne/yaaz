import "util/main.ash";

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
      create(creatable_amount($item[red pixel potion]), $item[red pixel potion]);
    }
  }
}

boolean M_8bit()
{
  M_8bit_cleanup();

  if (!have($item[continuum transfunctioner]))
    return false;

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
      wait(5);
      while(item_amount($item[red pixel potion]) < 5)
      {
        maximize("items", $item[continuum transfunctioner]);
        if (!yz_adventure($location[8-bit realm])) return true;
        M_8bit_cleanup();
      }
    }
  }

  if (have($item[digital key])) return false;

  // ... or if we've used the key already ...
  if (quest_status("questL13Final") > 5) return false;

  while(!have($item[digital key]))
  {
    maximize("items", $item[continuum transfunctioner]);
    if (!time_combat($monster[blooper], $location[8-bit realm]))
    {
      if (!yz_adventure($location[8-bit realm])) return true;
    }
    M_8bit_cleanup();
  }

  return true;
}

void main()
{
  while(M_8bit());
}
