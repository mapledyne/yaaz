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

boolean do_detail(string test, string detail)
{
  return test == detail || detail == "all";
}

void progress_sheet_detail(string detail)
{
  // extra details for the sheet when requested.


  if (do_detail("floundry", detail)
      && item_amount($item[fishin' pole]) == 0
      && !to_boolean(get_property("_floundryItemUsed")))
  {
    task("get item from the floundry");
  }

  if (do_detail("witchess", detail)
      && get_campground() contains $item[Witchess Set])
  {
    int fights = to_int(get_property("_witchessFights"));
    if (fights < 5)
    {
      progress(fights, 5, "Witchess fights", "blue");
    }
  }

  if (do_detail("snojo", detail)
      && to_boolean(get_property("snojoAvailable"))
      && to_int(get_property("_snojoFreeFights")) < 10)
  {
    int fights = to_int(get_property("_snojoFreeFights"));
    progress(fights, 10, "freesnojo fights", "blue");
  }

  if (do_detail("protonic", detail)
      && i_a($item[protonic accelerator pack]) > 0
      && to_location(get_property("ghostLocation")) != $location[none])
  {
    task("defeat ghost (" + get_property("ghostLocation")+ ")");
  }

  if (do_detail("precinct", detail)
      && to_int(get_property("_detectiveCasesCompleted")) < 3
      && to_boolean(get_property("hasDetectiveSchool")))
  {
    progress(to_int(get_property("_detectiveCasesCompleted")), 3, "detective cases solved", "blue");
  }

  if (do_detail("timespinner", detail)
      && item_amount($item[time-spinner]) > 0)
  {
    int used = to_int(get_property("_timeSpinnerMinutesUsed"));

    if (used < 10)
    {
      progress(used, 10, "Time Spinner minutes used", "blue");
      if (!to_boolean(get_property("_timeSpinnerReplicatorUsed")))
      {
        task("use Time Spinner replicator");
      }
    }
  }

  if (do_detail("deck", detail)
      &&item_amount($item[deck of every card]) > 0
      && to_int(get_property("_deckCardsDrawn")) < 15)
  {
    progress(to_int(get_property("_deckCardsDrawn")), 15, "Deck of Every Card cards drawn", "blue");
  }

  if (do_detail("numberology", detail)
      && have_skill($skill[calculate the universe])
      && to_int(get_property("_universeCalculated")) == 0)
  {
    task("Calculate the Universe");
  }

  if (do_detail("royalty", detail)
      && to_int(get_property("royalty")) > 0)
  {

    int max = to_int(setting("royalty_max", "0"));
    if (max == 0)
    {
      string roy = visit_url("museum.php?floor=4&place=royalboards");


      int index = index_of( roy , "showplayer" );
      int start = index_of( roy , "<b>" , index ) + 3;
      int end   = index_of( roy , "</b>" , start );
      string player = substring( roy , start , end );

      start = index_of( roy , "<td>" , end ) + 4;
      end   = index_of( roy , "</td>" , start );

      max = to_int(substring( roy , start , end ));
      save_daily_setting("royalty_max", max);

    }
    progress(to_int(get_property("royalty")), max, "royalty", "blue");
  }
}

void progress_sheet(string detail)
{

  if (detail != "" && detail != "all")
  {
    progress_sheet_detail(detail);
    return;
  }

  level_progress();

  if (item_amount($item[bitchin' meatcar]) == 0)
  {
    task("Build a bitchin' meatcar");
  }

  if (item_amount($item[dingy dinghy]) == 0
      && item_amount($item[bitchin' meatcar]) > 0)
  {
    if (item_amount($item[dinghy plans]) == 0)
    {
      progress(item_amount($item[Shore Inc. Ship Trip Scrip]), 3, "shore scrip for the dinghy plans");
    }
    if (item_amount($item[dingy planks]) == 0)
    {
      task("buy dinghy planks");
    }
  }

  if (quest_status("questL07Cyrptic") > UNSTARTED
      && item_amount($item[skeleton key]) == 0)
  {
    task("make skeleton key");
  }

  if (quest_status("questL13Final") < 5
      && hero_keys() < 3
      && !to_boolean(get_property("dailyDungeonDone")))
  {
    int keys = 3 - hero_keys();
    progress(to_int(get_property("_lastDailyDungeonRoom")), 15, "daily dungeon rooms - " + keys + " hero keys needed");
  }

  if (quest_status("questL05Goblin") < 1 && item_amount($item[Knob Goblin encryption key]) == 0)
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

  if (quest_status("questM21Dance") > UNSTARTED && quest_status("questM21Dance") < 3)
  {
    string shoes = UNCHECKED;
    string gown = UNCHECKED;
    string puff = UNCHECKED;
    if (item_amount($item[Lady Spookyraven's powder puff]) > 0)
      puff = CHECKED;
    if (item_amount($item[Lady Spookyraven's dancing shoes]) > 0)
      shoes = CHECKED;
    if (item_amount($item[Lady Spookyraven's finest gown]) > 0)
      gown = CHECKED;
    progress(dancing_items(), 3, "dancing things found (" + puff + " puff, " + shoes + " shoes, " + gown + " gown)");
  }

  if (quest_active("questL06Friar"))
  {
    string dodecagram = UNCHECKED;
    string candles = UNCHECKED;
    string butterknife = UNCHECKED;
    if (item_amount($item[dodecagram]) > 0)
      dodecagram = CHECKED;
    if (item_amount($item[box of birthday candles]) > 0)
      candles = CHECKED;
    if (item_amount($item[eldritch butterknife]) > 0)
      butterknife = CHECKED;

    progress(friar_things(), 3, "Friar ceremony objects (" + dodecagram + " dodecagram, " + candles + " candles, " + butterknife + " butterknife)");
  }

  // TODO: Count hot wings?

  if (quest_active("questL07Cyrptic"))
  {
    int evil = 200 - to_int(get_property("cyrptTotalEvilness"));
    progress(evil, 200, "Cyrpt progress");
    if (get_property("cyrptAlcoveEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptAlcoveEvilness").to_int()), 25, "evilness cleared in Alcove");

    if (get_property("cyrptCrannyEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptCrannyEvilness").to_int()), 25, "evilness cleared in Cranny");

    if (get_property("cyrptNicheEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptNicheEvilness").to_int()), 25, "evilness cleared in Niche");

    if (get_property("cyrptNookEvilness").to_int() > 0)
      progress(evil_progress(get_property("cyrptNookEvilness").to_int()), 25, "evilness cleared in Nook");

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

    if (quest_status("questL10Garbage") == 8)
      progress($location[The Castle in the Clouds in the Sky (Ground Floor)].turns_spent, 11, "progress to open the top floor of the castle");

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
      if (quest_active("questL11Doctor"))
      {
        int s = numeric_modifier("surgeonosity");
        progress(s, 5, "surgeonosity (" + (s * 10) + "% to find protector spirit)");
      }

      if (to_int(get_property("hiddenBowlingAlleyProgress")) < 6)
        progress(to_int(get_property("hiddenBowlingAlleyProgress")), 5, "bowling balls rolled");

      if (quest_active("questL11Curses"))
      {
        int curse = 0;
        if (have_effect($effect[once-cursed]) > 0)
          curse = 1;
        if (have_effect($effect[twice-cursed]) > 0)
          curse = 2;
        if (have_effect($effect[thrice-cursed]) > 0)
          curse = 3;
        progress(curse, 3, "curses for the penthouse");
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

      if (war_junkyard()
          && get_property("sidequestJunkyardCompleted") == "none")
      {
        progress(junkyard_items(), 4, "junkyard tools recovered");
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

  progress_sheet_detail(detail);
}

void progress_sheet()
{
  progress_sheet("");
}

void main()
{
  print("Current progress in a few things:");
  progress_sheet("all");
}
