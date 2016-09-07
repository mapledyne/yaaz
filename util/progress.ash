import "util/base/quests.ash";
import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/settings.ash";

int previous_level()
{
  if (my_level() == 1)
    return 0;

  return (my_level() - 1) * (my_level() - 1) + 4;
}

int next_level()
{
  return  my_level() * my_level() + 4;
}

void level_progress()
{

  int current = my_basestat(my_primestat()) - previous_level();

  int max = (next_level() * next_level()) - (previous_level() * previous_level());
  current = my_basestat($stat[submoxie]) - (previous_level() * previous_level());

  progress(current, max, "substat progress to level " + to_string(my_level()+1));
}

int war_defeated()
{
  string prop = "hippiesDefeated";
  if (setting("war_side") == "hippy")
    prop = "fratboysDefeated";
  return (get_property(prop).to_int());
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

int evil_progress(int p)
{
	return 25-(max(0,p-25));
}


void progress_sheet()
{
  level_progress();

  if (item_amount($item[digital key]) == 0 && item_amount($item[white pixel]) > 0)
  {
    progress(item_amount($item[white pixel]), 30, "digital key");
  }
  int desks = to_int(get_property("writingDesksDefeated"));

  if (desks > 0 && desks < 5)
  {
    progress(desks, 5, "writing desks defeated");
  }


  if (quest_active("questL06Friar"))
  {
    progress(friar_things(), 3, "Friar ceremony objects");
  }

  if (quest_active("questL07Cyrptic"))
  {
    int evil = 200 - to_int(get_property("cyrptTotalEvilness"));
    progress(evil, 200, "Cyrpt progress");
    if (get_property("cyrptAlcoveEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptAlcoveEvilness").to_int()), 25, "evilness cleared in Alcove.");

    if (get_property("cyrptNicheEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptNicheEvilness").to_int()), 25, "evilness cleared in Niche.");

    if (get_property("cyrptNookEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptNookEvilness").to_int()), 25, "evilness cleared in Nook.");

    if (get_property("cyrptCrannyEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptCrannyEvilness").to_int()), 25, "evilness cleared in Cranny.");
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
        progress(100 - boo, 100, "A-Boo peak hauntedness cleared");
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

  if (quest_active("questL11MacGuffin"))
  {
    if (quest_active("questL11Black"))
      progress(get_property("blackForestProgress").to_int(), 5, "black forest progress");

    int desert = to_int(get_property("desertExploration"));
    if (desert < 100)
      progress(desert, "desert explored");

    if (quest_active("questL11Worship"))
    {
      progress(item_amount($item[stone triangle]), 4, "stone triangles from the Hidden City");

      int surgeon = to_int(get_property("hiddenHospitalProgress"));
      if (surgeon > 0 && surgeon < 6)
      {
        int s = numeric_modifier("surgeonosity");
        progress(s, 5, "surgeonosity (" + (s * 10) + "% to find protector spirit)");
      }
    }

    if (quest_active("questL11Palindome"))
    {
      if (quest_status("questL11Palindome") < 1)
      {
        progress(to_int(get_property("palindomeDudesDefeated")), 5, "Palindome dudes defeated");
        progress(palindome_items(), 5, "Palindome items found");
      }
    }

    if (quest_active("questL11Pyramid"))
    {
      progress(turners(), 10, "wheel turning things");
    }
  }

  if (quest_active("questL12War"))
  {
      if (to_boolean(setting("war_arena", "true"))
          && get_property("sidequestArenaCompleted") == "none"
          && have_flyers())
      {
        int flyerML = get_property("flyeredML").to_int() / 100;
        progress(flyerML, "flyers delivered");
      }

      if (to_boolean(setting("war_lighthouse", "true"))
          && get_property("sidequestLighthouseCompleted") == "none")
      {
        progress(item_amount($item[barrel of gunpowder]), 5, "barrels of gunpowder");
      }
      string msg = "hippies defeated";
      if (setting("war_side") == "hippy")
      {
        msg = "fratboys defeated";
      }
      progress(war_defeated(), 1000, msg);
  }
}

void main()
{
  print("Current progress in a few things:");
  progress_sheet();
}
