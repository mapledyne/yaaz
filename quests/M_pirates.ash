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

boolean get_getup()
{
  if (have_outfit("swashbuckling getup"))
    return false;

  log("Get the swashbuckling getup...");
  while(!have_outfit("swashbuckling getup"))
  {
    boolean b = dg_adventure($location[The Obligatory Pirate's Cove]);
    if (!b) return true;
  }
  return true;
}

boolean collect_insults()
{
  if (item_amount($item[the big book of pirate insults]) == 0)
    return false;

  if (pirate_insults() >= 6)
    return false;

  while (pirate_insults() < 6)
  {
    if (item_amount($item[Cap'm Caronch's Map]) > 0)
    {
      log("Off to fight the " + wrap($monster[booty crab]) + ".");
      maximize("");
      use(1, $item[Cap'm Caronch's Map]);
      return true;
    }

    maximize("", "swashbuckling getup");
    boolean b = dg_adventure($location[The Obligatory Pirate's Cove]);
    if (!b) return true;
  }
  log(wrap(pirate_insults(), COLOR_ITEM) + " pirate insults discovered.");
  return true;
}

boolean M_pirates()
{
  if (to_int(get_property("lastIslandUnlock")) < my_ascensions())
    return false;

  if (i_a($item[pirate fledges]) > 0)
    return false;

  if (get_getup()) return true;
  if (collect_insults()) return true;

  log("Do something with the pirates?");
  wait(15);

  return false;
}

void main()
{
  M_pirates();
}
