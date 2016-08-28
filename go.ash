import "util/main.ash";
import "cleanup.ash";
import "util/day_begin.ash";

import "quests/M_guild.ash";
import "quests/M_hidden_temple.ash";
import "quests/M10_star_key.ash";

import "quests/L02_Q_larva.ash";
import "quests/L03_Q_rats.ash";
import "quests/L04_Q_bats.ash";
import "quests/L05_Q_goblin.ash";
import "quests/L06_Q_friar.ash";
import "quests/L07_Q_cyrpt.ash";
import "quests/L08_Q_trapper.ash";
import "quests/L09_Q_bridge.ash";
// MacGuffin quest should be more self contained like the war one. For now:
import "quests/L11_Q_black_market.ash";
import "quests/L11_Q_desert.ash";
import "quests/L11_Q_summoning.ash";
import "quests/L11_Q_palindome.ash";
import "quests/L11_Q_hidden_city.ash";

import "quests/L12_Q_war.ash";


boolean ascend_loop()
{
  // returning true here ultimately just causes us to start this
  // function over again.
  // If you do no work in one of these functions, you should
  // generally return false to let the next quest in line run.

  if (quest_status("questL02Larva") == UNSTARTED)
  {
    log("Visiting " + wrap("The Toot Oriole", COLOR_LOCATION) + " to kick things off.");
    visit_url("tutorial.php?action=toot");
  }

  // open our guild store and trainer:
  if (M_guild()) return true;

  // do this as soon as it's available - earlier start to the war == earlier arena fliers
  if (L12_Q_war()) return true;

  // do this one earlier since it can give us the Steel item.
  if (L06_Q_friar()) return true;

  // do a bit earlier than other order to get the Knob opened earlier.
  // earlier knob == earlier dispensary if we get a KGE outfit.
  if (L05_Q_goblin()) return true;

  // do this one earlier if only to talk to the trapper sooner.
  if (L08_Q_trapper()) return true;

  // open the hidden temple
  if (M_hidden_temple()) return true;

  // whatever is left can be done in order:
  if (L02_Q_larva()) return true;
  if (L03_Q_rats()) return true;
  if (L04_Q_bats()) return true;
  if (L07_Q_cyrpt()) return true;
  if (L09_Q_bridge()) return true;

  // macguffin quest
  if (L11_Q_black_market()) return true;
  if (L11_Q_palindome()) return true;
  if (L11_Q_desert()) return true;
  if (L11_Q_summoning()) return true;
  if (L11_Q_hidden_city()) return true;

  // towards the end since the timing really doesn't matter much on this one.
  // keeping it here may help us level when there's no other quest to do?
  if (M10_star_key()) return true;

  return false;
}

void ascend()
{
  day_begin();
  cleanup();

  if (quest_status("questL02Larva") == UNSTARTED)
  {
    log("Visiting " + wrap("The Toot Oriole", COLOR_LOCATION) + " to kick things off.");
    visit_url("tutorial.php?action=toot");
  }

  while(ascend_loop())
  {
    wait(5);
    cleanup();
  }
  wait(5);
  cleanup();
  log("Wrapping up for the end of the day.");
  cli_execute("call util/day_end.ash");
}

void main()
{
  ascend();
}
