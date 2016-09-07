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
  if (turners() < 10)
  {
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
  }

  log("Scripting the pyramid is woefully poor. Should be checking prop 'pyramidPosition' and inventory to know what to do.");
  wait(10);
  int x = 0;
  while(x < 10)
  {
    if(item_amount($item[crumbling wooden wheel]) > 0)
    {
      log("Turning the wheel with a " + wrap($item[crumbling wooden wheel]) + ".");
      visit_url("choice.php?pwd&whichchoice=929&option=1&choiceform1=Use+a+wheel+on+the+peg&pwd="+my_hash());
    }
    else
    {
      log("Turning the wheel with a " + wrap($item[tomb ratchet]) + ".");
      visit_url("choice.php?whichchoice=929&option=2&pwd");
    }
    x = x + 1;
    if((x == 3) || (x == 7) || (x == 10))
    {
      log("Heading down to the lower chambers.");
      visit_url("choice.php?pwd&whichchoice=929&option=5&choiceform5=Head+down+to+the+Lower+Chambers+%281%29&pwd="+my_hash());
    }
    if((x == 3) || (x == 7))
    {
      log("Heading down to the pyramid control room.");
      visit_url("place.php?whichplace=pyramid&action=pyramid_control");
    }
  }


  log("Ed should be unlocked?");
  wait(15);

  return true;
}

void main()
{
  L11_SQ_pyramid();
}
