import "util/print.ash";
import "util/maximize.ash";

// Snojo:

boolean can_snojo();
void snojo();

// Witchess:

boolean can_witchess();
void witchess();
void witchess(item it);



void snojo()
{
  if (!can_snojo())
  {
    return;
  }
  maximize("", false);

  while(can_snojo())
  {
      dg_adventure($location[The X-32-F Combat Training Snowman]);
      if (have_effect($effect[beaten up]) > 0)
      {
        break;
      }
  }
}

boolean can_snojo()
{
  if (to_boolean(get_property("snojoAvailable")) && get_property("_snojoFreeFights").to_int() < 10)
  {
    return true;
  }

  if (to_boolean(get_property("snojoAvailable")) && get_property("snojoSetting") == "NONE")
  {
    warning(wrap($location[The X-32-F Combat Training Snowman]) + " is available but not set up. Hit a control button!");
  }
  return false;
}

boolean can_witchess()
{
  if(get_campground() contains $item[Witchess Set] && get_property("_witchessFights").to_int() < 5)
    return true;
  return false;
}


void witchess()
{
  while (can_witchess())
  {
    maximize("", false);
    if (item_amount($item[armored prawn]) == 0)
    {
      witchess($item[armored prawn]);
      continue;
    }
    witchess($item[Sacramento wine]);
  }
}

void witchess(item it)
{
  if(get_campground() contains $item[Witchess Set] && get_property("_witchessFights").to_int() < 5)
  {
    int choice = 0;
    switch(it)
    {
      case $item[armored prawn]:
        choice = 1935;
        break;
      case $item[jumping horseradish]:
        choice = 1936;
        break;
      case $item[Sacramento wine]:
        choice = 1942;
        break;
      case $item[Greek fire]:
        choice = 1938;
        break;
      default:
        warning("I don't know how to fight the " + wrap($item[Witchess Set]) + " pieces to gain a " + wrap(it) + ".");
        return;
    }

    visit_url("campground.php?action=witchess");
    run_choice(1);
    visit_url("choice.php?option=1&pwd="+my_hash()+"&whichchoice=1182&piece=" + choice, false);
    run_combat();

  } else {
    warning("Cannot fight " + wrap($item[Witchess Set]) + " pieces. There aren't any left to fight.");
  }

}
