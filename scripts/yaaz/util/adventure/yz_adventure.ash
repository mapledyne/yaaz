import "util/prep/yz_prep.ash";
import "util/adventure/yz_counters.ash";
import "util/adventure/yz_consult.ash";
import "util/base/yz_inventory.ash";
import "special/items/yz_manuel.ash";
import "util/base/yz_util.ash";
import "util/base/yz_locations.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_quests.ash";

boolean overrides();
boolean yz_clover(location loc);
boolean yz_adventure(location loc, string maximize);
boolean yz_adventure(location loc);



boolean overrides()
{
  if (!can_adventure())
    return false;

  // we may want to capture an adventure and do something else with it.

  // check for counters like semi-rare and dance cards.
  if (counters())
    return true;

  return false;
}

boolean yz_adventure_bypass(location loc)
{

  boolean adv;

  if (get_property("cloverProtectActive") != "true")
    set_property("cloverProtectActive", "true");

  manuel_add_location(loc);
  string msg = "Adventuring: " + wrap(loc);
  if (current_quest != "") msg += ", to advance current quest: " + wrap(current_quest, COLOR_LOCATION);
  log(msg);

  adv = adv1(loc, -1, "yz_consult");

  if (loc == $location[the haunted bedroom])
  {
    string v = visit_url("/campground.php");
    if (contains_text(v, "the now-still nightstand"))
    {
      adv = adv1(loc, -1, "yz_consult");
    }
  }

  if (loc == $location[the naughty sorceress' chamber])
  {
    string v = visit_url("/campground.php");
    if (contains_text(v, "The Naughty Sorceress"))
    {
      adv = adv1(loc, -1, "yz_consult");
    }
  }

  if (last_monster().random_modifiers["clingy"])
  {
    info("Previous monster was clingy. Fighting the followup monster now.");
    run_combat("yz_consult");
  }

  return adv;
}


boolean yz_adventure(location loc, string maximize)
{
  if (my_inebriety() > inebriety_limit())
  {
    error("You are too drunk to continue.");
    wait(5);
    return false;
  }

  if (my_adventures() <= abort_on_advs_left)
  {
    return false;
  }

  if (overrides()) return true;

  if (!location_open(loc))
  {
    boolean b = open_location(loc);
    if (!b)
    {
      warning("Trying to open the location " + wrap(loc) + " but I couldn't for some reason.");
      return false;
    }
  }

  prep(loc);

  if (maximize != "none")
  {
    maximize(maximize);
  }

  return yz_adventure_bypass(loc);
}

boolean yz_adventure(location loc)
{
  return yz_adventure(loc, "none");
}

boolean yz_clover(location loc)
{
  item clover = $item[disassembled clover];
  item tenleaf = $item[ten-leaf clover];

  if (setting("no_clovers") == "true")
  {
    info("Considering using a clover at " + wrap(loc) + ", but you've asked me not to use clovers, so I won't.");
    return false;
  }

  if (!can_adventure())
  {
    warning("Trying to " + wrap("clover", COLOR_ITEM) + " in " + wrap(loc) + " but you can't adventure right now.");
    return false;
  }

  log("Clovering " + wrap(loc) + ".");
  wait(3);

  if(item_amount(tenleaf) == 0 && item_amount(clover) > 0 && be_good(clover))
  {
    use(1, clover);
  }

  if(item_amount(tenleaf) == 0 && closet_amount(tenleaf) > 0)
  {
    take_closet(1, tenleaf);
  }

  if (item_amount(tenleaf) == 0 && closet_amount(clover) > 0 && be_good(clover))
  {
    take_closet(1, clover);
    use(1, clover);
  }

  if (item_amount(tenleaf) == 0)
  {
    warning("Trying to clover in " + wrap(loc) + " but you don't have a " + wrap("clover", COLOR_ITEM) + ".");
    return false;
  }

  string protect = get_property("cloverProtectActive");
  set_property("cloverProtectActive", false);
  boolean ret = adv1(loc, -1, "yz_consult");
  set_property("cloverProtectActive", protect);

  return ret;
}
