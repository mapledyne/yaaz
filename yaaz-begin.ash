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

  if (!hippy_stone_broken() && setting("no_pvp") != "true")
  {
    warning("You haven't broken your Hippy Stone to enable PvP.");
    warning("This script can handle PvP for you if you break the stone.");
    warning("If you don't want to fight in PvP, and don't want this message,");
    log("set " + SETTING_PREFIX + "_no_pvp=true");
    warning("Otherwise, his ESC and go break that stone!");
    wait(10);
  }
}

void main()
{
  log("Running day begin processes without attempting any quests.");
  wait(5);
  day_begin();
  log("Complete.");
}
