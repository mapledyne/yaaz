import "util/main.ash";

void day_begin()
{
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script is built with Hardcore in mind. It has rudimentary Softcore support, but it may still do some things the hard way.");
  }

  log("Current progress:");
  progress_sheet("all");
  wait(5);

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

  iotm();

  special();

  prep();

  log("Checking out the Council to make sure our quests are up to date.");
  council();

}

void main()
{
  log("Running day begin processes without attempting any quests.");
  wait(5);
  day_begin();
  log("Complete.");
}
