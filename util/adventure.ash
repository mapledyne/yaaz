import "util/prep.ash";
import "util/counters.ash";

int abort_on_advs_left = 5;

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

  return adventure(1, loc);
}
