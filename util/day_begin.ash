import "util/print.ash";
import "util/iotm.ash";
import "util/prep.ash";
import "util/consume.ash";

void day_begin()
{
  log("Turns used this ascension: " + my_turncount() + ", over " + my_daycount() + " days.");
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore, it'll do a lot of things the hard way.");
  }
  wait(5);
  // breakfast-y stuff...

  iotm();

  log("Day startup tasks complete.");
}

void main()
{
  day_begin();
}
