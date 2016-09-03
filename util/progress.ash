import "util/base/quests.ash";
import "util/base/print.ash";
import "util/base/inventory.ash";

int next_level()
{
  return  my_level() * my_level() + 4;
}


boolean mysterious(int progress, int c) {
 return (progress & (1 << c)) == 0;
}

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

void progress_sheet()
{
  if (my_level() < 13)
  {
    progress(my_basestat(my_primestat()), next_level(), " progress to next level (" + to_string(my_level()+1) + ")");
  }
  if (item_amount($item[digital key]) == 0 && item_amount($item[white pixel]) > 0)
  {
    progress(item_amount($item[white pixel]), 30, "digital key");
  }
  int desks = to_int(get_property("writingDesksDefeated"));

  if (desks > 0 && desks < 5)
  {
    progress(desks, 5, "writing desks defeated");
  }

  int ore = item_amount($item[asbestos ore]);
  if (quest_status("questL08Trapper") < 2 && ore > 0 && ore < 3)
  {
    progress(ore, 3, "ore for the trapper");
  }

  int cheese = item_amount($item[goat cheese]);
  if (quest_status("questL08Trapper") < 2 && cheese > 0 && cheese < 3)
  {
    progress(cheese, 3, "cheese for the trapper");
  }

  if (quest_active("questL07Cyrptic"))
  {
    int evil = 200 - to_int(get_property("cyrptTotalEvilness"));
    progress(evil, 200, "Cyrpt progress");
  }

  if(quest_active("questL09Topping"))
  {
    int bridge = to_int(get_property("chasmBridgeProgress"));
    if (bridge < 30)
    {
      progress(bridge, 30, "bridge progress");
    } else {
      float oil = to_float(get_property("oilPeakProgress"));
      if (oil > 0)
        progress(310.66 - oil, 310.66, "Oil Peak pressure");

      int boo = to_int(get_property("booPeakProgress"));
      if (boo > 0)
        progress(100 - boo, 100, "A-Boo peak hauntedness");
      int twin = twinpeak_progress();
      if (twin < 4)
        progress(twin, 4, "Twin peak progress");
    }

  }

  if (quest_active("questL10Garbage"))
  {
    if (item_amount($item[s.o.c.k.]) == 0)
      progress(immateria(), 4, "Immateria found");
  }

  if (quest_active("questL12War") && get_property("sidequestArenaCompleted") != "none")
  {
      if (have_flyers())
      {
        int flyerML = get_property("flyeredML").to_int() / 100;
        progress(flyerML, "flyers delivered");
      }
  }


}

void main()
{
  print("Current progress in a few things:");
  progress_sheet();
}
