import "util/main.ash";

boolean M_8bit()
{
  if (have($item[digital key]))
    return false;

  if (quest_status("questL13Final") > 3)
    return false;

  if (!have($item[continuum transfunctioner]))
    return false;

  if (dangerous($monster[blooper]))
  {
    log("Skipping the " + wrap($location[8-bit realm]) + " until it's safer.");
    return false;
  }

  while(!have($item[digital key]))
  {
    if (creatable_amount($item[digital key]) > 0)
    {
      log("Making a " + wrap($item[digital key]) + ".");
      create(1, $item[digital key]);
      continue;
    }
    maximize("items", $item[continuum transfunctioner]);
    if (!time_combat($monster[blooper], $location[8-bit realm]))
    {
      if (!yz_adventure($location[8-bit realm]) return true;
    }
  }

  if (!have_skill($skill[Ambidextrous Funkslinging]))
  {
    if (item_amount($item[red pixel potion]) < 5)
    {
      log("Because you don't have " + wrap($skill[Ambidextrous Funkslinging]) + ", I'm going to collect some " + wrap($item[red pixel potion]) + ".");
      log("Consider making this skill permanent as soon as you can.");
      wait(5);
      while(item_amount($item[red pixel potion]) < 5)
      {
        maximize("items", $item[continuum transfunctioner]);
        if (!yz_adventure($location[8-bit realm]) return true;
      }
    }
  }
  return true;
}

void main()
{
  M_8bit();
}
