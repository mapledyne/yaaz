import "util/main.ash";

boolean have_staff_of_ed()
{
  if (2286.to_item().available_amount() > 0 && 2268.to_item().available_amount() > 0 && 2180.to_item().available_amount() > 0)
    return true;

  return false;
}

int turners()
{
  return item_amount($item[crumbling wooden wheel]) + item_amount($item[tomb ratchet]);
}

void open_pyramid()
{
  if (quest_status("questL11Pyramid") < 0)
  {
    if (have_staff_of_ed())
    {
      log("Opening up " + wrap("the pyramid", COLOR_LOCATION) + ".");
      visit_url("place.php?whichplace=desertbeach&action=db_pyramid1");
    } else {
      warning("Pyramid not yet discovered. You need to solve more of the MacGuffin mystery.");
      return;
    }
  }
  if (quest_status("questL11Pyramid") > 10)
  {
    warning("Pyramid quest already complete.");
    return;
  }

  while (quest_status("questL11Pyramid") < 1)
  {
    maximize("noncombat");
    dg_adventure($location[The Upper Chamber]);
    if (turners() > 0)
    {
      progress(turners(), 10, "wheel turning things");
    }
  }

  add_attract($monster[tomb rat]);
  while (quest_status("questL11Pyramid") < 3)
  {
    maximize("items");
    dg_adventure($location[The Middle Chamber]);
    if (turners() > 0)
    {
      progress(turners(), 10, "wheel turning things");
    }
  }
  remove_attract($monster[tomb rat]);

  while (turners() < 10)
  {
    maximize("items");
    dg_adventure($location[The Middle Chamber]);
    progress(turners(), 10, "wheel turning things");
  }

}

void main()
{
  open_pyramid();
}
