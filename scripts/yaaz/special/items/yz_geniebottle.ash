import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_maximize.ash";
import "util/base/yz_monsters.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_inventory.ash";
import "util/prep/yz_prep.ash";

boolean can_wish()
{
  if (!have($item[genie bottle])) return false;
  if (!be_good($item[genie bottle])) return false;
  int wishes = prop_int("_genieWishesUsed");

  if (wishes >= 3) return false;

  return true;
}


void geniebottle_progress()
{
  if (!have($item[genie bottle])) return;
  if (!be_good($item[genie bottle])) return;

  // _genieFightsUsed=0
  // _genieWishesUsed=0

  int wishes = prop_int("_genieWishesUsed");
  if (wishes >= 3) return;

  progress(wishes, 3, wrap($item[genie bottle]) + " wishes used", "blue");

}

boolean bottle_wish(string wishingfor)
{
  if (!can_wish()) return false;
  log("Using the " + wrap($item[genie bottle]) + " to " + wrap(wishingfor, COLOR_ITEM));
  cli_execute("genie " + wishingfor);
  return true;
}

boolean bottle_wish(monster mon, string max)
{
  if (!can_wish()) return false;
  log("Using the " + wrap($item[genie bottle]) + " to fight a " + wrap(mon));
  maximize(max);
  cli_execute("genie monster " + mon);
  string temp = visit_url("main.php"); // we seem to not always know we're in a fight
  run_combat("yz_consult");
  return true;
}

boolean bottle_wish(monster mon)
{
  return bottle_wish(mon, "");
}

void consume_bottle_wishes()
{
  while (can_wish())
  {

    if (!have($item[digital key])
        && !dangerous($monster[ghost])
        && creatable_amount($item[digital key]) == 0
        && quest_status("questL13Final") < 5)
    {
      bottle_wish($monster[ghost], "items");
      prep();
      continue;
    }

    if (item_amount($item[barrel of gunpowder]) < 5
        && !dangerous($monster[lobsterfrogman])
        && get_property("sidequestLighthouseCompleted") == "none"
        && quest_status("questL12War") < FINISHED
        && war_lighthouse())
    {
      bottle_wish($monster[lobsterfrogman]);
      prep();
      continue;
    }



    // if we got here, we couldn't find anything good to fight.
    log("Couldn't find anything helpful to use with our remaining wishes. Maybe ask for a pony?");

    break;
  }
}


void geniebottle()
{
// From forum as strategy:
// I used to get a Bass Clarinet from the Clan Floundry each day, which you can "drain" for 10 white pixels.
// Now, with the genie, I can wish for a ghost to fight, which drops up to 5 white pixels (with just 150% item).
// By digitizing the ghost I was able to fight six in one day, gaining 30 white pixels. I also fought
// five writing desks by wishing for one and digitizing.

// This lets me pull a Fish Hatchet from the Floundry instead of the clarinet. The Fish Hatchet gives
// 5 of each bridge building material type. So the genie is letting me save a nice handful of turns,
// since it takes somewhere around 15 adventures to get 10 of each bridge parts, and I only have to
// spend 6 adventures on the ghosts.

  if (!can_wish()) return;

  if (!have($item[blessed rustproof +2 gray dragon scale mail])
      && have_skill($skill[Torso Awaregness]))
  {
    bottle_wish("wish for a blessed rustproof +2 gray dragon scale mail");
    return;
  }

  // monsters to consider/add: lobsterfrogman, ninja snowman assassin, dirty theiving brigand?

}

void main()
{
  geniebottle();
}
