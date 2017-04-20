import "util/main.ash";

void M_untinker_progress()
{

}

void M_untinker_cleanup()
{

}

boolean do_untinker()
{
  if (knoll_available())
  {
    log("Visiting " + wrap("Innabox", COLOR_LOCATION) + " to get the " + wrap("screwdriver", COLOR_ITEM) + ".");
    visit_url("place.php?whichplace=knoll_friendly&action=dk_innabox");
    return true;
  }

  if (dangerous($location[The Degrassi Knoll Garage])) return false;

  yz_adventure($location[The Degrassi Knoll Garage]);
  return true;
}

boolean M_untinker()
{
  if (quest_status("questM01Untinker") == FINISHED) return false;

  switch (quest_status("questM01Untinker"))
  {
    default:
      warning("Unknown status in the Untinker quest: " + wrap(quest_status("questM01Untinker"), COLOR_ITEM) + ".");
      wait(5);
      return false;
    case UNSTARTED:
      log("Visiting the " + wrap("Untinker", COLOR_LOCATION) + " to start his quest.");
      visit_url("place.php?whichplace=forestvillage&preaction=screwquest&action=fv_untinker_quest");
      set_property("questM01Untinker", 'started');
    case STARTED:
      return do_untinker();
    case 1:
      log("Returning the " + wrap($item[rusty screwdriver]) + " to the " + wrap("Untinker", COLOR_LOCATION) + ".");
      visit_url("place.php?whichplace=forestvillage&action=fv_untinker");
      return true;
  }

  return false;
}

void main()
{
  while(M_untinker());
}
