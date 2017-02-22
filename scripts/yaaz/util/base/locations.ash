import "util/base/util.ash";
import "util/base/quests.ash";
import "util/base/print.ash";
import "util/base/settings.ash";

boolean open_location(location loc);
location pick_semi_rare_location();


location pick_semi_rare_location()
{
  location last = to_location(get_property("semirareLocation"));

  if (quest_status("questL10Garbage") >= 9
      && to_boolean(setting("war_nuns", "false"))
      && get_property("sidequestNunsCompleted") == "none"
      && last != $location[The Castle in the Clouds in the Sky (Top Floor)])
  {
    return $location[The Castle in the Clouds in the Sky (Top Floor)];
  }

  // if we don't have the KGE outfit, get it for dispensary access.
  if (!have_outfit("Knob Goblin Elite Guard Uniform")
      && last != $location[Cobb's Knob Barracks])
  {
    return $location[Cobb's Knob Barracks];
  }

  // Get some stone wool if useful:
  if (!hidden_temple_unlocked() && item_amount($item[stone wool]) < 2)
  {
    if (quest_status("questL11Worship") < 3)
      return $location[The Hidden Temple];
  }

  if (last == $location[the haunted pantry])
  {
    return $location[the sleazy back alley];
  }
  return $location[the haunted pantry];
}



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
        return open_location(l);
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
