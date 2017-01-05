import "util/base/quests.ash";
import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/settings.ash";
import "util/base/war_support.ash";
import "util/base/paths.ash";
import "util/base/util.ash";

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

  if (do_detail("smiles", detail)
      && smiles_remaining() > 0)
  {
    progress(5 - smiles_remaining(), total_smiles(), "smiles from your Golden Mr. Accessory", "blue");
  }

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
    progress(fights, 10, "free snojo fights", "blue");
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
      progress(used, 10, wrap($item[time spinner]) + " minutes used", "blue");
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

  if (do_detail("goodwill", detail)
       && my_path() == "Way of the Surprising Fist")
  {
    int charity = to_int(get_property("totalCharitableDonations"));
    if (charity < 1000000)
    {
      progress(charity, 1000000, "Good Will Hunting trophy", "blue");
    }
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

  if (quest_status("questL13Final") < 5
      && hero_keys() < 3)
  {
    int keys = hero_keys();
    string pete = UNCHECKED;
    string boris = UNCHECKED;
    string jarl = UNCHECKED;

    if (item_amount($item[boris's key]) > 0) boris = CHECKED;
    if (item_amount($item[jarlsberg's key]) > 0) jarl = CHECKED;
    if (item_amount($item[sneaky pete's key]) > 0) pete = CHECKED;

    progress(keys, 3, "hero keys (" + boris + "Boris, " + pete + "Pete, " + jarl + "Jarlsberg)");

    if (quest_status("questL07Cyrptic") > UNSTARTED
        && item_amount($item[skeleton key]) == 0)
    {
      task("make skeleton key");
    }

  }

  if (quest_status("questL13Final") < 5
      && hero_keys() < 3
      && !to_boolean(get_property("dailyDungeonDone")))
  {
    int keys = 3 - hero_keys();
    progress(to_int(get_property("_lastDailyDungeonRoom")), 15, "daily dungeon rooms");
  }

  if (quest_status("questM12Pirate") > 0 && quest_status("questM12Pirate") < 5)
  {
    int current = pirate_insults();
    progress(current, 8, "pirate insults (" + pirate_insult_success() + "% chance)");
  }

  if (quest_status("questM12Pirate") == 5)
  {

    string mop = UNCHECKED;
    string ball = UNCHECKED;
    string shampoo  = UNCHECKED;
    int fledge_count = 0;
    if (item_amount($item[mizzenmast mop]) > 0)
    {
      mop = CHECKED;
      fledge_count++;
    }
    if (item_amount($item[ball polish]) > 0)
    {
      ball = CHECKED;
      fledge_count++;
    }
    if (item_amount($item[rigging shampoo]) > 0)
    {
      shampoo = CHECKED;
      fledge_count++;
    }

    progress(fledge_count, 3, wrap($location[The F'c'le]) + " items (" + mop + "Mop, " + ball + "Polish, " + shampoo + "Shampoo)");

  }

  if (quest_active("questL02Larva"))
  {
    task("Find the " + wrap($item[mosquito larva]));
  }

  if (quest_active("questL04Bat"))
  {
    int walls = quest_status("questL04Bat");
    if (walls < 4)
    {
      progress(walls, 3, "walls destroyed in the " + wrap("Bat Hole", COLOR_LOCATION));
    } else {
      task("Defeat the " + wrap($monster[boss bat]));
    }
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

  if (quest_active("questM10Azazel"))
  {
    progress(item_amount($item[imp air]), 5, "imp airs");
    if (i_a($item[observational glasses]) == 0)
    {
      task("Find the " + wrap($item[observational glasses]) + ".");
    }

    progress(item_amount($item[bus pass]), 5, "bus passes");
    string band = "";
    if (jim() != $item[none])
    {
      band += "Jim";
    }
    if (flargwurm() != $item[none])
    {
      if (band != "")
        band += ", ";
      band += "Flargwurm";
    }
    if (bognort() != $item[none])
    {
      if (band != "")
        band += ", ";
      band += "Bognort";
    }
    if (stinkface() != $item[none])
    {
      if (band != "")
        band += ", ";
      band += "Stinkface";
    }

    if (length(band) > 0)
    {
      band = " (" + band + ")";
    }

    progress(backstage_items(), 4, "backstage items" + band);

  }

  if (quest_status("questL06Friar") > UNSTARTED
      && quest_status("questM12Pirate") < 3
      && item_amount($item[hot wing]) < 3)
  {
    progress(item_amount($item[hot wing]), 3, wrap($item[hot wing], 3) + " for use with the " + wrap($item[orcish frat house blueprints]));
  }

  if (quest_active("questL07Cyrptic"))
  {
    int evil = 200 - to_int(get_property("cyrptTotalEvilness"));
    progress(evil, 200, "Cyrpt progress");
    if (get_property("cyrptAlcoveEvilness").to_int() > 0 && get_property("cyrptAlcoveEvilness").to_int() < 50)
      progress(evil_progress(get_property("cyrptAlcoveEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled alcove]));

    if (get_property("cyrptCrannyEvilness").to_int() > 0 && get_property("cyrptCrannyEvilness").to_int() < 50)
      progress(evil_progress(get_property("cyrptCrannyEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled cranny]));

    if (get_property("cyrptNicheEvilness").to_int() > 0 && get_property("cyrptNicheEvilness").to_int() < 50)
      progress(evil_progress(get_property("cyrptNicheEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled niche]));

    if (get_property("cyrptNookEvilness").to_int() > 0 && get_property("cyrptNookEvilness").to_int() < 50)
      progress(evil_progress(get_property("cyrptNookEvilness").to_int()), 25, "evilness cleared in " + wrap($location[the defiled nook]));

  }

  if (quest_status("questL08Trapper") == 1)
  {
    item ore_wanted = to_item(get_property("trapperOre"));
    if (ore_wanted != $item[none])
    {
      int ore = item_amount(ore_wanted);
      progress(ore, 3, wrap(ore_wanted) + " for the trapper");

      int cheese = item_amount($item[goat cheese]);
      progress(cheese, 3, wrap($item[goat cheese]) + " for the trapper");
    }

  }

  if (quest_status("questL08Trapper") == 3
      || quest_status("questL08Trapper") == 4)
  {
    progress($location[mist-shrouded peak].turns_spent, 3, "yetis killed");
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

  if (quest_status("questM21Dance") == FINISHED
      && $location[the haunted ballroom].turns_spent < 5)
  {
    progress($location[The Haunted Ballroom].turns_spent, 5, "delay on The Haunted Ballroom");
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

      if (quest_active("questL11Business"))
      {
        if (item_amount($item[McClusky file (complete)]) == 0)
        {
          if (item_amount($item[boring binder clip]) == 0)
          {
            task("get boring binder clip");
          }
          progress(mcclusky_items(), 5, "McClusky file pages");
        } else {
          task("fight the Protector Spirit in the Office Building");
        }
      }

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

  if (quest_active("questL11Manor"))
  {
    if (quest_status("questL11Manor") == 2)
    {
      if (!can_make_wine_bomb())
      {
        progress(scavenger_hunt_items(), 6, "manor scavenger hunt items");
      } else {
        if (i_a($item[unstable fulminate]) == 0)
        {
          task("make unstable fulminate");
        } else {
          task("make wine bomb");
        }
      }
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
