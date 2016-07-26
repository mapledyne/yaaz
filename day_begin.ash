import "util/main.ash";

void begin_day()
{

// breakfast-y stuff...

  if (equipped_item($slot[weapon]) != $item[none])
  {
    witchess();

    snojo();
  }



  if (to_boolean(get_property("chateauAvailable")) && !to_boolean(get_property("_chateauDeskHarvested")))
  {
    visit_url("place.php?whichplace=chateau&action=chateau_desk2");
  }

}

void main()
{
  log("Turns used this ascension: " + my_turncount() + ", over " + my_daycount() + " days.");
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore, it'll do a lot of things the hard way.");
  }
  wait(5);
  begin_day();
  log("Doing basic cleanup.");
  prep($location[none]);
  log("Checking for any future quest requirements.");
  build_requirements();
  log("Day startup tasks complete.");

  if (get_property("_detectiveCasesCompleted").to_int() < 3)
  {
    warning("You have detective cases you can complete at the precinct.");
    warning("This isn't automated by this script.");
  }
}
