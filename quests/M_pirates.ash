import "util/main.ash";


void open_belowdecks()
{
  if (quest_status("questM12Pirate") != 6)
  {
    warning("Wrong status to try to open " + wrap($location[belowdecks]) + ".");
    return;
  }

  if (quest_status("questL11MacGuffin") < 2)
  {
    warning("Go read " + wrap($item[your father's macguffin diary]) + ".");
    return;
  }

  log("Opening up " + wrap($location[belowdecks]) + ".");
  while (quest_status("questM12Pirate") != FINISHED)
  {
    maximize("-combat", $item[pirate fledges]);
    dg_adventure($location[the poop deck]);
  }
  log(wrap($location[belowdecks]) + " opened.");
}

void maybe_make_talisman()
{
  while (item_amount($item[Talisman o' Namsilat]) == 0 && item_amount($item[gaudy key]) > 0)
  {
    cli_execute("checkpoint");
    if (!have_equipped($item[pirate fledges]))
    {
      equip($item[pirate fledges]);
    }
    use(1, $item[gaudy key]);
    cli_execute("outfit checkpoint");
  }
}

boolean get_talisman()
{
  if (i_a($item[pirate fledges]) == 0)
    return false;

  if (i_a($item[Talisman o' Namsilat]) > 0)
    return false;

  if (quest_status("questM12Pirate") != FINISHED)
  {
    open_belowdecks();
    return true;
  }

  while(item_amount($item[Talisman o' Namsilat]) == 0)
  {
    maximize("items", $item[pirate fledges]);
    dg_adventure($location[belowdecks]);
    maybe_make_talisman();
  }
  return true;
}
