import "quests/L09_SQ_bridge.ash";
import "quests/L09_SQ_oilpeak.ash";
import "quests/L09_SQ_aboo.ash";
import "quests/L09_SQ_twin.ash";

void L09_Q_topping_cleanup()
{

}

boolean L09_Q_topping()
{

  if (quest_status("questL09Topping") == FINISHED)
    return false;
  if (my_level() < 9)
    return false;

  if (L09_SQ_bridge()) return true;
  if (L09_SQ_oilpeak()) return true;
  if (L09_SQ_twin()) return true;
  if (L09_SQ_aboo()) return true;

  if (to_int(get_property("booPeakProgress")) > 0)
    return false;

  if (to_int(get_property("oilPeakProgress")) > 0)
    return false;

  if (to_int(get_property("twinPeakProgress")) < 15)
    return false;

  log("The peaks are lit. Going to the Highland Lord.");
  visit_url("place.php?whichplace=highlands&action=highlands_dude");

  return true;
}

void main()
{
  while (L09_Q_topping());
}
