import "util/main.ash";
import "util/progress.ash";

import "quests/M_guild.ash";
import "quests/M_hidden_temple.ash";
import "quests/M_spookyraven.ash";
import "quests/M09_leaflet.ash";
import "quests/M10_star_key.ash";

import "quests/L02_Q_larva.ash";
import "quests/L03_Q_rats.ash";
import "quests/L04_Q_bats.ash";
import "quests/L05_Q_goblin.ash";
import "quests/L06_Q_friar.ash";
import "quests/L07_Q_cyrpt.ash";
import "quests/L08_Q_trapper.ash";
import "quests/L09_Q_topping.ash";
import "quests/L10_Q_Garbage.ash";
import "quests/L11_Q_macguffin.ash";
import "quests/L12_Q_war.ash";

boolean ascend_loop()
{

  if (!can_adventure())
    return false;

  // returning true here ultimately just causes us to start this
  // function over again.
  // If you do no work in one of these functions, you should
  // generally return false to let the next quest in line run.

  if (quest_status("questL02Larva") == UNSTARTED && my_level() > 1)
  {
    log("Visiting " + wrap("The Toot Oriole", COLOR_LOCATION) + " to kick things off.");
    visit_url("tutorial.php?action=toot");
  }

  // misc things we should probably just do as soon as we can:
  if (M_guild()) return true; // only opens the guild - doesn't do the full guild quest.
  if (M09_leaflet()) return true;

  // do this as soon as it's available - earlier start to the war == earlier arena fliers
  if (L12_Q_war()) return true;

  // do this one earlier since it can give us the Steel item.
  if (L06_Q_friar()) return true;

  // do a bit earlier than other order to get the Knob opened earlier.
  // earlier knob == earlier dispensary if we get a KGE outfit.
  if (L05_Q_goblin()) return true;

  // do this one earlier if only to talk to the trapper sooner.
  if (L08_Q_trapper()) return true;

  // Misc quests. More efficient for these to go later?
  if (M_hidden_temple()) return true;
  if (M_spookyraven()) return true;

  // whatever is left can be done in order:
  if (L02_Q_larva()) return true;
  if (L03_Q_rats()) return true;
  if (L04_Q_bats()) return true;
  if (L07_Q_cyrpt()) return true;
  if (L09_Q_topping()) return true;
  if (L10_Q_garbage()) return true;
  if (L11_Q_macguffin()) return true;

  // towards the end since the timing really doesn't matter much on this one.
  // keeping it here may help us level when there's no other quest to do?
  if (M10_star_key()) return true;

  log("Ran out of things to do in this script. Either a quest is missing, or maybe we should level?");
  return false;
}

void day_begin()
{
  log("Turns used this ascension: " + my_turncount() + ", over " + my_daycount() + " days.");
  log("Beginning start-of-day prep.");

  if (!in_hardcore())
  {
    warning("This script assumes you're in hardcore. If you're in softcore, it'll do a lot of things the hard way.");
  }

  log("Current progress:");
  progress_sheet();
  wait(5);

  maximize();
  prep();

  iotm();

  log("Day startup tasks complete. About to begin doing stuff.");
  wait(10);

}

void day_end()
{
  log("Wrapping up for the end of the day.");
  wait(5);

  // if there are any source terminal enhances left
  consume_enhances();
  consume_cards();

  cross_streams();

  prep();


  pvp();

  log("Dressing for rollover.");
  maximize("rollover");
  if (hippy_stone_broken())
  {
    log("Tweaking nighttime outfit for better PvP.");
    remove_non_rollover();
    pvp_rollover();
  }
  progress_sheet();
  manuel_progress();

}

void ascend()
{
  day_begin();


  if (!can_adventure())
  {
    log("You're already out of adventures you can use today.");
    log("Doing cleanup actions, but skipping main quest loop.");
  }

  while(ascend_loop())
  {
    iotm();
    manuel_progress();
    wait(5);
  }

  iotm();
  manuel_progress();
  wait(5);

  day_end();

  log("Scripted actions complete. Run this script again to continue trying to ascend.");

  if (my_adventures() < 10 && booze_full() && fullness_full())
  {
    log("It looks like you don't have much else you can do today. Consider a nightcap if you don't want to do anything else manually?");
  } else {
    log("There may be other things you can do today, but this script can't handle them. Do those, or just try rerunning this script.");
  }

}

void main()
{
  ascend();
}
