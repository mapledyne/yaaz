import "quests/council/yz_L09_SQ_bridge.ash";
import "quests/council/yz_L09_SQ_oilpeak.ash";
import "quests/council/yz_L09_SQ_aboo.ash";
import "quests/council/yz_L09_SQ_twin.ash";


int twinpeak_progress()
{

  int peak = get_property("twinPeakProgress").to_int();

  int progress = 0;
  if(bit_flag(peak, 0))
    progress += 1; // 4 Stench Resistance
  if(bit_flag(peak, 1))
    progress += 1; // +50% Item Drop
  if(bit_flag(peak, 2))
    progress += 1; // Jar of Oil
  if(bit_flag(peak, 3))
    progress += 1; // +40% initiative

  return progress;
}

void L09_Q_topping_progress()
{
  if (!quest_active("questL09Topping")) return;

  int bridge = prop_int("chasmBridgeProgress");
  if (bridge < 30)
  {
    progress(bridge, 30, "bridge progress");
    return;
  }

  float oil = to_float(get_property("oilPeakProgress"));
  if (oil > 0)
    progress(310.66 - oil, 310.66, wrap($location[oil peak]) + " pressure");

  int boo = prop_int("booPeakProgress");
  if (boo > 0)
    progress(100 - boo, 100, wrap($location[a-boo peak]) + " hauntedness cleared");
  int twin = twinpeak_progress();
  if (twin < 4)
    progress(twin, 4, wrap($location[twin peak]) + " progress");

  int peak = get_property("twinPeakProgress").to_int();
  if(!bit_flag(peak, 2)
     && item_amount($item[jar of oil]) == 0)
  {
    progress(item_amount($item[bubblin' crude]), 12, wrap($item[bubblin' crude], 12) + " needed for a " + wrap($item[jar of oil]));
  }

}

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

  if (prop_int("booPeakProgress") > 0)
    return false;

  if (prop_int("oilPeakProgress") > 0)
    return false;

  if (prop_int("twinPeakProgress") < 15)
    return false;

  log("The peaks are lit. Going to the Highland Lord.");
  visit_url("place.php?whichplace=highlands&action=highlands_dude");

  return true;
}

void main()
{
  while (L09_Q_topping());
}
