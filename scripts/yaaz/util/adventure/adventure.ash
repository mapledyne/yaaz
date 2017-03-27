import "util/prep/prep.ash";
import "util/adventure/counters.ash";
import "util/adventure/consult.ash";
import "util/base/inventory.ash";
import "special/items/manuel.ash";
import "util/base/util.ash";
import "util/progress.ash";
import "util/base/locations.ash";
import "util/base/settings.ash";

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

  manuel_add_location(loc);
  adv = adv1(loc, -1, "");

  if (loc == $location[the haunted bedroom])
  {
    string v = visit_url("/campground.php");
    if (contains_text(v, "the now-still nightstand"))
    {
      adv = adv1(loc, -1, "");
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

  progress_sheet();

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
    return false;

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
