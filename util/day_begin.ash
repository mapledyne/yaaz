import "util/base/print.ash";
import "util/iotm.ash";
import "util/base/prep.ash";
import "util/base/consume.ash";
import "util/base/maximize.ash";
import "util/progress.ash";

void day_begin()
{
  log("Turns used this ascension: " + my_turncount() + ", over " + my_daycount() + " days.");
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore, it'll do a lot of things the hard way.");
  }
  wait(5);
  maximize();

  // breakfast-y stuff...

  iotm();

  progress_sheet();
  wait(5);

  log("Day startup tasks complete. About to begin doing stuff.");
  wait(10);
}

void main()
{
  day_begin();
}
