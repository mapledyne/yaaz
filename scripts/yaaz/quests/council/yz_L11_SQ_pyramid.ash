import "util/yz_main.ash";
import "util/base/yz_consume.ash";

boolean have_staff_of_ed()
{
  if (2286.to_item().available_amount() > 0 && 2268.to_item().available_amount() > 0 && 2180.to_item().available_amount() > 0)
    return true;

  return false;
}

void get_turner()
{
  if (turners() == 0)
  {
    log("We need another item to turn the wooden wheel.");
  }

  while(turners() == 0)
  {
    if (!yz_adventure($location[The Middle Chamber], "items"))
      return;
  }
}

void turn_wheel_until(int position)
{
  int current = to_int(get_property("pyramidPosition"));
  while (position != current)
  {
    get_turner();
    if (turners() == 0) return;
    visit_url("place.php?whichplace=pyramid&action=pyramid_control");
    if(item_amount($item[crumbling wooden wheel]) > 0)
    {
      string v = visit_url("choice.php?pwd&whichchoice=929&option=1&choiceform1=Use+a+wheel+on+the+peg&pwd="+my_hash());
    }
    else if (item_amount($item[tomb ratchet]) > 0)
    {
      string v = visit_url("choice.php?whichchoice=929&option=2&pwd");
    }
    current = to_int(get_property("pyramidPosition"));
  }
}

boolean L11_SQ_pyramid()
{
  if (item_amount($item[[7965]Holy MacGuffin]) > 0)
  {
    log("Visiting the council to turn in the " + wrap($item[[7965]Holy MacGuffin]) + ".");
    council();
    return true;
  }

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

  if (quest_status("questL11Pyramid") < 1)
  {
    yz_adventure($location[The Upper Chamber], "-combat");
    return true;
  }

  if (quest_status("questL11Pyramid") < 3 || turners() < 10)
  {
    yz_adventure($location[The Middle Chamber], "items");
    return true;
  }

  // Make sure we have enough adventures
  prep();
  if (my_adventures() < 8)
  {
    log("Skipping the Pyramid for now since we're low on adventures and " + wrap($monster[ed the undying]) + " takes a bunch of them.");
    return false;
  }
  if (get_counters('Digitize Monster', 0, 8) != ""
      || get_counters('Enamorang Monster', 0, 8) != ""
      || get_counters('Fortune Cookie', 0, 8) != "")
  {
    log("Skipping the Pyramid for now since we don't want to accidentally clobber something coming up soon.");
    return false;
  }


  log("Turning the wheel to get the " + wrap($item[ancient bronze token]));
  turn_wheel_until(4);
  visit_url("choice.php?pwd&whichchoice=929&option=5&choiceform5=Head+down+to+the+Lower+Chambers+%281%29&pwd="+my_hash());

  log("We have the " + wrap($item[ancient bronze token]) + ", now off to spin the wheel to get the " + wrap($item[ancient bomb]) + ".");
  turn_wheel_until(3);
  visit_url("choice.php?pwd&whichchoice=929&option=5&choiceform5=Head+down+to+the+Lower+Chambers+%281%29&pwd="+my_hash());

  log("We have the " + wrap($item[ancient bomb]) + ", now off to spin the wheel to get the stairs down.");
  turn_wheel_until(1);
  visit_url("choice.php?pwd&whichchoice=929&option=5&choiceform5=Head+down+to+the+Lower+Chambers+%281%29&pwd="+my_hash());

  log("Off to fight " + wrap($monster[ed the undying]) + ".");
  maximize("");
  while (!have($item[[2334]Holy MacGuffin]))
  {
    if (!yz_adventure_bypass($location[the lower chambers])) return true;
  }
  log("Visiting the council to turn in the " + wrap($item[[2334]Holy MacGuffin]) + ".");
  council();
  return true;

}

void main()
{
  while (L11_SQ_pyramid());
}
