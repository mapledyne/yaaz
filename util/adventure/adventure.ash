import "util/base/prep.ash";
import "util/adventure/counters.ash";
import "util/base/inventory.ash";
import "util/iotm/protonic.ash";
import "util/base/util.ash";

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

  if (quest_status("questL10Garbage") == FINISHED && i_a($item[wand of nagamar]) == 0)
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
      while (!get_property("dailyDungeonDone").to_boolean())
      {
        adv1($location[the daily dungeon], -1, "");
      }
    }
  }

  return false;
}


void update_flyer_progress()
{
  if (get_property("questL12War") != "step1")
    return;
  if (get_property("sidequestArenaCompleted") != "none")
    return;

  if (have_flyers())
  {
    int flyerML = get_property("flyeredML").to_int() / 100;
    progress(flyerML, "flyers delivered");
  }
}

boolean dg_adventure(location loc, string maximize)
{
  if (my_inebriety() > inebriety_limit())
  {
    error("You are too drunk to continue.");
    wait(5);
    log("Going to do end-of-day tasks...");
    wait(5);
    cli_execute("call util/day_end.ash");
    abort("Too drunk to adventure more. Go sleep it off.");
  }

  if (my_adventures() <= abort_on_advs_left)
  {
    error("Cannot auto-adventure with only " + my_adventures() + " adventures remaining. Get some more food/booze in you or wait until tomorrow. Aborting.");
    wait(5);
    log("Going to do end-of-day tasks...");
    wait(5);
    cli_execute("call util/day_end.ash");
    abort("Not enough adventures to do more with. Maybe find a nightcap?");
  }

  overrides();

  if (maximize != "none")
  {
    maximize(maximize);
  }

  prep(loc);

  if (protonic())
    return true;

  boolean adv = adv1(loc, -1, "");

  update_flyer_progress();


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
