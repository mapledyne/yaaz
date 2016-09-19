import "util/base/print.ash";
import "util/base/maximize.ash";
import "util/adventure/adventure.ash";

int witchess_left()
{
  if (get_campground() contains $item[Witchess Set])
    return 5 - to_int(get_property("_witchessFights"));
  return 0;
}

boolean can_witchess()
{
  if(can_adventure() && witchess_left() > 0)
    return true;
  return false;
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
    progress_sheet();
  } else {
    warning("Cannot fight " + wrap($item[Witchess Set]) + " pieces. There aren't any left to fight.");
  }

}

void witchess()
{
  if (!can_witchess())
    return;

  log("Checking your " + $item[witchess set] + ".");

  while (can_witchess())
  {
    maximize("");
    if (item_amount($item[armored prawn]) == 0)
    {
      witchess($item[armored prawn]);
      continue;
    }
    witchess($item[Sacramento wine]);
  }
}

void main()
{
  witchess();
}
