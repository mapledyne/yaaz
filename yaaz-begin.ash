import "util/main.ash";

void day_begin()
{
  log("Turns used this ascension: " + wrap(my_turncount(), COLOR_LOCATION) + ", over " + wrap(my_daycount(), COLOR_LOCATION) + " days.");
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore or aftercore, it'll do a lot of things the hard way.");
  }

  log("Current progress:");
  progress_sheet("all");
  wait(5);

  maximize();
  prep();

  iotm();

}

void main()
{
  log("Running day begin processes without attempting any quests.");
  wait(5);
  day_begin();
  log("Complete.");
}
