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
    boolean b = dg_adventure($location[Barrrney's barrr]);
    if (!b) return true;
  }
  log(wrap(pirate_insults(), COLOR_ITEM) + " pirate insults discovered.");
  return true;
}

boolean get_capm_map()
{
  if (quest_status("questM12Pirate") > UNSTARTED) return false;

  while (item_amount($item[Cap'm Caronch's Map]) == 0)
  {
    maximize("", "swashbuckling outfit");
    boolean b = dg_adventure($location[barrrney's barrr]);
    if (!b) return true;
  }
  return true;
}

boolean get_blueprints()
{
  if (quest_status("questM12Pirate") != 1) return false;

  if (item_amount($item[Cap'm Caronch's nasty booty]) == 0) return false;

  while (item_amount($item[Orcish Frat House blueprints]) == 0)
  {
    maximize("", "swashbuckling outfit");
    boolean b = dg_adventure($location[barrrney's barrr]);
    if (!b) return true;
  }
  return true;
}

boolean get_skirt()
{
  if (i_a($item[frilly skirt]) > 0) return false;

  if (knoll_available())
  {
    log("Buying a " + wrap($item[frilly skirt]) + " to sneak into the frathouse.");
    buy(1, $item[frilly skirt]);
    return true;
  }
  log("Head to the " + wrap($location[the degrassi knoll gym]) + " to get a " + wrap($item[frilly skirt]) + ".");
  while (i_a($item[frilly skirt]) == 0)
  {
    boolean b = dg_adventure($location[the degrassi knoll gym], "items");
    if (!b) return true;
  }
  return true;
}

boolean fcle()
{

  if (i_a($item[pirate fledges]) == 0) return false;

  // The ordering here determines what familiar is used.
  // If we left it always at "combat, items" and didn't have the dog,
  // it'd default to a 'default' familiar, and we want to fall back to an
  // items familiar in this case.
  string max = "items, combat";
  if (have_familiar($familiar[jumpsuited hound dog]))
  {
    max = "combat, items";
  }

  log("Off to get our " + wrap($item[pirate fledges]) + ".");

  while ((item_amount($item[rigging shampoo]) == 0)
         && (item_amount($item[ball polish]) == 0)
         && (item_amount($item[mizzenmast mop]) == 0))
  {
    maximize(max);
    boolean b = dg_adventure($location[The F\'c\'le]);
    if (!b) return true;
  }


  if((item_amount($item[rigging shampoo]) == 1)
     && (item_amount($item[ball polish]) == 1)
     && (item_amount($item[mizzenmast mop]) == 1))
  {
    log("Returning the items to get us some " + wrap($item[pirate fledges]) + ".");
    use(1, $item[rigging shampoo]);
    use(1, $item[ball polish]);
    use(1, $item[mizzenmast mop]);
    outfit("swashbuckling getup");
    dg_adventure($location[The F\'c\'le]);
    return true;
  }

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

  if (pirate_insults() < 6) return false;

  if (get_capm_map()) return true;

  if (item_amount($item[Cap'm Caronch's Map]) > 0)
  {
    log("Using " + wrap($item[Cap'm Caronch's Map]) + ".");
    use(1, $item[Cap'm Caronch's Map]);
    return true;
  }

  if (get_blueprints()) return true;

  if (quest_status("questM12Pirate") == 5)
  {
    if (get_skirt()) return true;
    equip($item[frilly skirt]);
    use(1, $item[orcish frat house blueprints]);
    return true;
  }

  if (fcle()) return true;

  log("Shouldn't get here anymore...?");
  wait(15);

  return false;
}

void main()
{
  M_pirates();
}
