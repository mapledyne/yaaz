import "util/main.ash";

boolean get_wine_bomb()
{
  if (i_a($item[wine bomb]) > 0)
  {
    return false;
  }
  if (creatable_amount($item[unstable fulminate]) > 0)
  {
    create(1, $item[unstable fulminate]);
  }

  if (i_a($item[unstable fulminate]) == 0)
  {
    warning("You don't have the " + wrap($item[unstable fulminate]) + " or the ingredients to make it.");
    return false;
  }

  add_attract($monster[monstrous boiler]);

  log("Going after the " + wrap($monster[monstrous boiler]) + " to make the " + wrap($item[wine bomb]));

  while (i_a($item[wine bomb]) == 0)
  {
    dg_adventure($location[the haunted boiler room], "ml, equip unstable fulminate");
  }

  remove_attract($monster[monstrous boiler]);
  return true;
}

boolean get_blasting()
{
  if (quest_status("questL11Manor") < 1)
  {
    error("Trying to work in the laundry room, but it isn't opened yet.");
    return false;
  }
  if (quest_status("questL11Manor") >= 3)
  {
    return false;
  }
  if (item_amount($item[blasting soda]) > 0 || item_amount($item[unstable fulminate]) > 0 || item_amount($item[wine bomb]) > 0)
  {
    return false;
  }

  log("Trying to find the " + wrap($item[blasting soda]) + " in the " + wrap($location[the haunted laundry room]) + ".");

  add_attract($monster[cabinet of dr. limpieza]);
  while (item_amount($item[blasting soda]) == 0 && item_amount($item[unstable fulminate]) == 0 && item_amount($item[wine bomb]) == 0)
  {
    dg_adventure($location[the haunted laundry room], "items");
  }
  remove_attract($monster[cabinet of dr. limpieza]);
  build_requirements();
  return true;
}

boolean get_vinegar()
{
  if (quest_status("questL11Manor") < 1)
  {
    error("Trying to work in the cellar, but it isn't opened yet.");
    return false;
  }
  if (quest_status("questL11Manor") >= 3)
  {
    return false;
  }

  if (item_amount($item[bottle of Chateau de Vinegar]) > 0 || item_amount($item[unstable fulminate]) > 0 || item_amount($item[wine bomb]) > 0)
  {
    return false;
  }

  log("Trying to find the " + wrap($item[bottle of Chateau de Vinegar]) + " in the " + wrap($location[the haunted wine cellar]) + ".");

  add_attract($monster[possessed wine rack]);
  while (item_amount($item[bottle of Chateau de Vinegar]) == 0 && item_amount($item[unstable fulminate]) == 0 && item_amount($item[wine bomb]) == 0)
  {
    dg_adventure($location[the haunted wine cellar], "items");
  }
  remove_attract($monster[possessed wine rack]);
  build_requirements();
  return true;
}

void open_cellar()
{
  while (quest_status("questL11Manor") == STARTED)
  {
    string max = "";
    if ($location[the haunted ballroom].turns_spent >= 5)
    {
      max = "-combat";
    }
    dg_adventure($location[the haunted ballroom]);
  }

  if (quest_status("questL11Manor") <= STARTED)
  {
    warning("Something happened and the cellar doesn't appear to be open.");
    abort();
  }
  log(wrap("The Haunted Cellar", COLOR_LOCATION) + " is open.");
}

boolean do_spookyraven()
{
  switch(quest_status("questL11Manor"))
  {
    default:
      error("I don't know the " + wrap($monster[lord spookyraven]) + " quest status of " + get_property("questL11Manor"));
      return false;
    case FINISHED:
      return false;
    case UNSTARTED:
      error("You should recover and read " + wrap($item[your father's MacGuffin diary]) + " before doing this quest.");
      return false;
    case STARTED:
      open_cellar();
      return true;
    case 1:
      if (i_a($item[lord spookyraven's spectacles]) == 0)
      {
        warning("This script requires that you have " + wrap($item[lord spookyraven's spectacles]) + ". Go get them before continuing.");
        return false;
      }
      if (i_a($item[recipe: mortar-dissolving solution]) == 0)
      {
        log("Getting the " + wrap($item[recipe: mortar-dissolving solution]) + ".");
        visit_url('place.php?whichplace=manor4&action=manor4_chamberwall_label');
      }

      if (!have_equipped($item[lord spookyraven's spectacles]))
      {
        log("Wearing " + wrap($item[lord spookyraven's spectacles]));
        equip($slot[acc1], $item[lord spookyraven's spectacles]);
      }
      log("Reading " + wrap($item[recipe: mortar-dissolving solution]));
      use(1, $item[recipe: mortar-dissolving solution]);
      return true;
    case 2:
      if (get_blasting())
        return true;
      if (get_vinegar())
        return true;
      if (get_wine_bomb())
        return true;
      log("Going to try to kill " + wrap($monster[lord spookyraven]) + ".");
      visit_url('place.php?whichplace=manor4&action=manor4_chamberwall_label');
      dg_adventure($location[summoning chamber], "all res");
      return true;
  }
}

boolean L11_Q_summoning()
{
if (quest_status("questL11Manor") == FINISHED)
  return false;
if (quest_status("questL11MacGuffin") == UNSTARTED)
  return false;

  while(do_spookyraven())
  {

  }
  if (quest_status("questL11Manor") != FINISHED)
  {
    warning("Could not defeat " + wrap($monster[lord spookyraven]) +" for some reason.");
    return true;
  } else {
    log(wrap($monster[lord spookyraven]) + " has been defeated.");
    return true;
  }
}

void main()
{
  L11_Q_summoning();
}
