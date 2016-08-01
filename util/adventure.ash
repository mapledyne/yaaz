import "util/prep.ash";
import "util/counters.ash";
import "util/progress.ash";

int abort_on_advs_left = 5;

void update_flyer_progress()
{
  if (get_property("questL12War") != "step1")
    return;
  if (get_property("sidequestArenaCompleted") != "none")
    return;

  if (item_amount($item[rock band flyers]) > 0 || item_amount($item[jam band flyers]) > 0)
  {
    int flyerML = get_property("flyeredML").to_int() / 100;
    progress(flyerML, "flyers delivered");
  }
}

boolean dg_adventure(location loc)
{
  if (my_inebriety() > inebriety_limit())
  {
    error("You are too drunk to continue.");
    abort();
  }

  if (my_adventures() <= abort_on_advs_left)
  {
    error("Cannot auto-adventure with only " + my_adventures() + " adventures remaining. Get some more food/booze in you or wait until tomorrow. Aborting.");
    abort();
  }

  // check for counters like semi-rare and dance cards.
  counters();

  prep(loc);

  boolean adv = adventure(1, loc);

  update_flyer_progress();

  return adv;
}
