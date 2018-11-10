import "util/yz_main.ash";
import "util/base/yz_speedy.ash";

void day_begin()
{
  log("Beginning start-of-day prep.");

  log("Current progress:");
  progress_sheet(true);
  speedy_wait(5);

  if (get_property("cloverProtectActive") != "true")
    set_property("cloverProtectActive", "true");

  maybe_pull($item[Infinite BACON Machine]);

  switch (my_primestat())
  {
    case $stat[moxie]:
      maybe_pull($item[green LavaCo Lamp&trade;]);
      break;
    case $stat[muscle]:
      maybe_pull($item[red LavaCo Lamp&trade;]);
      break;
    case $stat[mysticality]:
      maybe_pull($item[blue LavaCo Lamp&trade;]);
      break;
  }
  maximize();

  special();

  prep();

  log("Checking out the Council to make sure our quests are up to date.");
  council();

}

void main()
{
  if (!svn_exists("winterbay-mafia-wham"))
  {
    warning("While this script tries to not require other scripts, and just skips functionality in those cases,");
    warning("I can't currently function without Winterbay's excellent 'WHAM' script. Please go install that and");
    warning("then rerun this script.");
    abort();
  }

  log("Running day begin processes without attempting any quests.");
  wait(5);
  day_begin();
  log("Complete.");
}
