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
