import "util/main.ash";

boolean have_staff_of_ed()
{
  if (2286.to_item().available_amount() > 0 && 2268.to_item().available_amount() > 0 && 2180.to_item().available_amount() > 0)
    return true;

  return false;
}

boolean L11_SQ_pyramid()
{
  if (quest_status("questL11Pyramid") < 0)
  {
    if (have_staff_of_ed())
    {
      log("Opening up " + wrap("the pyramid", COLOR_LOCATION) + ".");
      visit_url("place.php?whichplace=desertbeach&action=db_pyramid1");
      return true;
    } else {
      return false;
    }
  }
  if (quest_status("questL11Pyramid") > 10)
  {
    return false;
  }

  while (quest_status("questL11Pyramid") < 1)
  {
    maximize("noncombat");
    dg_adventure($location[The Upper Chamber]);
  }

  add_attract($monster[tomb rat]);
  while (quest_status("questL11Pyramid") < 3)
  {
    maximize("items");
    dg_adventure($location[The Middle Chamber]);
  }
  remove_attract($monster[tomb rat]);

  while (turners() < 10)
  {
    maximize("items");
    dg_adventure($location[The Middle Chamber]);
  }
  log("You have all the wheel turning things, but actually turning the wheel isn't scripted.");
  wait(15);

  return true;
}

void main()
{
  L11_SQ_pyramid();
}
