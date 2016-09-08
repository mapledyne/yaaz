import "util/prep/prep.ash";
import "util/adventure/counters.ash";
import "util/base/inventory.ash";
import "util/iotm/protonic.ash";
import "util/iotm/manuel.ash";
import "util/base/util.ash";
import "util/progress.ash";
import "util/base/locations.ash";
import "util/base/settings.ash";

boolean overrides();
boolean dg_clover(location loc);
boolean dg_adventure(location loc, string maximize);
boolean dg_adventure(location loc);


boolean overrides()
{
  if (!can_adventure())
    return false;

  // we may want to capture an adventure and do something else with it.

  // check for counters like semi-rare and dance cards.
  if (counters())
    return true;

  location prot = protonic();
  if (prot != $location[none])
  {
    log("Who ya gonna call? No one. You're going to trap the ghost in " + wrap(prot) + " and keep it for yourself.");
    wait(3);
    maximize("", $item[protonic accelerator pack]);
    manuel_add_location(prot);
    return adv1(prot, -1, "");
  }

  if (quest_status("questL10Garbage") == FINISHED && i_a($item[wand of nagamar]) == 0 && item_amount($item[disassembled clover]) > 0)
  {
    log("Going to get the pieces of the " + wrap($item[wand of nagamar]) + ".");
    boolean clove = dg_clover($location[The Castle in the Clouds in the Sky (Basement)]);
    if (clove)
    {
      log("Making a " + wrap($item[wand of nagamar]) + ".");
      create(1, $item[wand of nagamar]);
    }
  }

  // we have a function for this, but I don't want to use it here since the
  // file it's in (familiars.ash) is the right place for it, but I can't
  // include that here because of import loops.
  boolean have_cubeling = (i_a($item[eleven-foot pole]) > 0 && i_a($item[pick-o-matic lockpicks]) > 0 && i_a($item[ring of detect boring doors]) > 0);

  if (have_cubeling && !get_property("dailyDungeonDone").to_boolean() && quest_status("questL13Final") < 3)
  {
    if (i_a($item[sneaky pete's key]) == 0 || i_a($item[boris's key]) == 0 || i_a($item[jarlsberg's key]) == 0 || setting("always_daily_with_cubeling") == "true")
    {
      maximize("", $item[ring of detect boring doors]);
      manuel_add_location($location[the daily dungeon]);
      while (!get_property("dailyDungeonDone").to_boolean())
      {
        adv1($location[the daily dungeon], -1, "");
      }
      return true;
    }
  }

  return false;
}

boolean dg_adventure(location loc, string maximize)
{
  if (my_inebriety() > inebriety_limit())
  {
    error("You are too drunk to continue.");
    wait(5);
    return false;
  }

  if (my_adventures() <= abort_on_advs_left)
  {
    error("Cannot auto-adventure with only " + my_adventures() + " adventures remaining. Get some more food/booze in you or wait until tomorrow. Aborting.");
    wait(5);
    return false;
  }

  while (overrides())
  {
    // keep trying overrides() until it has nothing to do and returns false.
  }

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

  manuel_add_location(loc);

  boolean adv = adv1(loc, -1, "");

  progress_sheet();

  return adv;
}

boolean dg_adventure(location loc)
{
  return dg_adventure(loc, "none");
}

boolean dg_clover(location loc)
{
  item clover = $item[disassembled clover];

  if (setting("no_clovers") == "true")
    return false;

  if (item_amount(clover) == 0)
  {
    warning("Trying to clover in " + wrap(loc) + " but you don't have a " + wrap("clover", COLOR_ITEM) + ".");
    return false;
  }

  if (!can_adventure())
  {
    warning("Trying to " + wrap("clover", COLOR_ITEM) + " in " + wrap(loc) + " but you can't adventure right now.");
    return false;
  }

  log("Clovering " + wrap(loc) + ".");
  wait(3);
  use(1, clover);

  string protect = get_property("cloverProtectActive");
  set_property("cloverProtectActive", false);
  boolean ret = adv1(loc, -1, "");
  set_property("cloverProtectActive", protect);

  return ret;
}
