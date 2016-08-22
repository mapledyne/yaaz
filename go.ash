import "util/main.ash";
import "cleanup.ash";
import "util/day_begin.ash";

import "quests/M_guild.ash";
import "quests/M_hidden_temple.ash";
import "quests/M10_star_key.ash";

import "quests/L05_Q_goblin.ash";
import "quests/L06_Q_friar.ash";
import "quests/L07_Q_cyrpt.ash";
import "quests/L08_Q_trapper.ash";
import "quests/L11_Q_black_market.ash";

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

  // do this one as soon as possible since it can give us the Steel item.
  if (L06_Q_friar()) return true;

  // do a bit earlier than other order to get the Knob opened earlier.
  if (L05_Q_goblin()) return true;

  // do this one earlier if only to talk to the trapper ASAP.
  if (L08_Q_trapper()) return true;

  // open the hidden temple
  if (M_hidden_temple()) return true;

  // whatever is left can be done in order:
  if (L07_Q_cyrpt()) return true;

  if (L11_Q_black_market()) return true;

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
