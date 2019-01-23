import "util/yz_main.ash";

void S01_sea_progress()
{

}

void S01_sea_cleanup()
{

}

boolean S01_sea()
{
  if (my_level() < 11) return false;
  if (!can_access_sea()) return false;

  if (quest_status("questS01OldGuy") == UNSTARTED)
  {
    log("Going to visit the " + wrap("Old Man", COLOR_MONSTER) + " to be able to visit " + wrap("The Sea", COLOR_LOCATION) + ".");
    visit_url("place.php?whichplace=sea_oldman&action=oldman_oldman");
    return true;
  }

  return false;
}

void main()
{
  S01_sea();
}
