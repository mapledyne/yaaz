import "util/main.ash";

void day_begin()
{
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore or aftercore, it'll do a lot of things the hard way.");
  }

  log("Current progress:");
  progress_sheet("all");
  wait(5);

  maximize();

  iotm();

  special();

  prep();

}

void main()
{
  log("Running day begin processes without attempting any quests.");
  wait(5);
  day_begin();
  log("Complete.");
}
