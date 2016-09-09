import "util/base/quests.ash";
import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/settings.ash";
import "util/base/war_support.ash";


int level_substats(int level)
{
  if (level == 1)
    return 0;
  int s = (level - 1) * (level - 1) + 4;
  s = s * s;
  return s;
}

int next_substats()
{
  return level_substats(my_level() + 1) - level_substats(my_level());
}

int current_substats()
{
  stat s = $stat[submuscle];
  if (my_primestat() == $stat[mysticality])
    s = $stat[submysticality];
  if (my_primestat() == $stat[moxie])
    s = $stat[submoxie];
  return my_basestat(s) - level_substats(my_level());
}

void level_progress()
{

  progress(current_substats(), next_substats(), "substats to level " + to_string(my_level()+1));
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

  if (quest_status("questL05Goblin") < 1)
  {
    progress($location[The Outskirts of Cobb's Knob].turns_spent, 11, "turns in the Outskirts of Cobb's Knob to get the encryption key");
  }

  if (item_amount($item[digital key]) == 0 && item_amount($item[white pixel]) > 0 && quest_status("questL13Final") < 5)
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

  // TODO: Count hot wings?

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
      if (war_arena()
          && get_property("sidequestArenaCompleted") == "none"
          && have_flyers())
      {
        int flyerML = get_property("flyeredML").to_int() / 100;
        progress(flyerML, "flyers delivered");
      }

      if (war_orchard()
          && war_orchard_accessible()
          && get_property("sidequestOrchardCompleted") == "none")
      {
        int count = 0;
        if (have_effect($effect[filthworm larva stench]) > 0)
          count = 1;
        if (have_effect($effect[filthworm drone stench]) > 0)
          count = 2;
        if (have_effect($effect[filthworm guard stench]) > 0)
          count = 3;
        if (item_amount($item[heart of the filthworm queen]) > 0)
          count = 4;

        progress(count, 4, "Orchard filthworm progress");
      }

      if (war_lighthouse()
          && get_property("sidequestLighthouseCompleted") == "none")
      {
        progress(item_amount($item[barrel of gunpowder]), 5, "barrels of gunpowder");
      }

      string msg = "hippies defeated";
      if (war_side() == "hippy")
      {
        msg = "fratboys defeated";
      }

      int left = (1000 - war_defeated()) / war_multiplier();
      msg += " (" + war_multiplier() + "/turn, " + left + " turns remain)";

      progress(war_defeated(), 1000, msg);
  }

  if (quest_active("questL13Final"))
  {
    int contest = to_int(get_property("nsContestants1"));
    if (contest > 0)
      progress(10 - contest, 10, "contestants (init)");

    contest = to_int(get_property("nsContestants2"));
    if (contest > 0)
      progress(10 - contest, 10, "contestants (" + get_property("nsChallenge1") + ")");

    contest = to_int(get_property("nsContestants3"));
    if (contest > 0)
      progress(10 - contest, 10, "contestants (" + get_property("nsChallenge2") + ")");

      // TODO: Find a way to track wall of meat progress...
  }
}

void main()
{
  print("Current progress in a few things:");
  progress_sheet();
}
