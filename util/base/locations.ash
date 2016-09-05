import "util/base/util.ash";
import "util/base/quests.ash";
import "util/base/print.ash";

boolean location_open(location l)
{
  switch (l)
  {
    case $location[the old landfill]:
      return (quest_status("questM19Hippy") != UNSTARTED);
    case $location[madness bakery]:
      return (quest_status("questM25Armory") != UNSTARTED);
    case $location[the overgrown lot]:
      if (quest_status("questM24Doc") != UNSTARTED)
        return true;
      if (setting("overgrown_lot") == "true")
        return true;
      string lot = visit_url("place.php?whichplace=town_wrong");
      if (contains_text(lot, "The Overgrown Lot"))
      {
        save_daily_setting("overgrown_lot", "true");
        return true;
      } else {
        return false;
      }
    default:
      return true;
  }
}

boolean open_location(location loc)
{
  switch(loc)
  {
    default:
      log("I don't yet know how to open " + wrap(loc) + ".");
      wait(10);
      return false;
    case $location[the overgrown lot]:
      return start_galaktik();
  }

}
