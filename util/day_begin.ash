import "util/print.ash";
import "util/iotm.ash";
import "util/prep.ash";
import "util/requirements.ash";
import "util/consume.ash";

void day_begin()
{
  if (setting("day_begin") == "true")
    return;

  log("Turns used this ascension: " + my_turncount() + ", over " + my_daycount() + " days.");
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore, it'll do a lot of things the hard way.");
  }
  wait(5);
  // breakfast-y stuff...

  log("Item of the Month and related work.");
  iotm();

  spleen();
  
  log("Doing basic prep.");
  prep($location[none]);

  log("Checking for any future quest requirements.");
  build_requirements();

  log("Day startup tasks complete.");

  save_daily_setting("day_begin", "true");
}

void main()
{
  day_begin();
}
