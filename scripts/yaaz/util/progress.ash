import "util/base/quests.ash";
import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/settings.ash";
import "util/base/war_support.ash";
import "util/base/paths.ash";
import "util/base/util.ash";
import "util/base/locations.ash";

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

void smoke_if_got_it(item it)
{
  if (!have(it)) return;

  task("You have a " + wrap(it) + ". Manually use or closet (or sell, or whatever)");
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
      && have($item[fishin' pole])
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
      && have($item[protonic accelerator pack])
      && to_location(get_property("ghostLocation")) != $location[none])
  {
    task("defeat ghost (" + wrap(to_location(get_property("ghostLocation")))+ ")");
  }

  if (do_detail("precinct", detail)
      && to_int(get_property("_detectiveCasesCompleted")) < 3
      && to_boolean(get_property("hasDetectiveSchool")))
  {
    progress(to_int(get_property("_detectiveCasesCompleted")), 3, "detective cases solved", "blue");
  }

  if (do_detail("timespinner", detail)
      && have($item[time-spinner]))
  {
    int used = to_int(get_property("_timeSpinnerMinutesUsed"));

    if (used < 10)
    {
      progress(used, 10, wrap($item[time-spinner]) + " minutes used", "blue");
      if (!to_boolean(get_property("_timeSpinnerReplicatorUsed")))
      {
        task("use Time Spinner replicator");
      }
    }
  }

  if (do_detail("deck", detail)
      && have($item[deck of every card])
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

  if (do_detail("gingerbread", detail)
      && get_property("gingerbreadCityAvailable") == "true")
  {
    task(wrap("Gingerbread City", COLOR_LOCATION) + " is not automated, but you have it. Do this yourself if interested during the run.");
  }

  if (do_detail("lovetunnel", detail)
      && to_boolean(get_property("loveTunnelAvailable"))
      && !to_boolean(get_property("_loveTunnelUsed")))
  {
    task(wrap("LOVE Tunnel", COLOR_LOCATION) + " is available and hasn't been used today.");
  }

}

void progress_sheet(string detail)
{

  if (detail != "" && detail != "all")
  {
    progress_sheet_detail(detail);
    return;
  }

  if (detail == "")
  {
    log("Turns used this ascension: " + wrap(my_turncount(), COLOR_LOCATION) + ".");
  }
  if (detail == "all")
  {
    log("Turns used this ascension: " + wrap(my_turncount(), COLOR_LOCATION) + ", over " + wrap(my_daycount(), COLOR_LOCATION) + " days.");
  }

  if (quest_status("questL13Final") >= 13)
  {
    log("You've defeated the " + wrap($monster[naughty sorceress]) + ". Hooray!");
    task("Go do aftercore stuff.");
  }

  level_progress();

  int pulls = pulls_remaining();
  if (pulls > 0)
  {
    progress(20 - pulls, 20, "pulls from storage used");
  }

  if (stills_available() > 0)
  {
    progress(10 - stills_available(), 10, wrap("Nash Crosby's Still", COLOR_LOCATION) + " uses");
  }

  if (to_int(get_property("lastDesertUnlock")) < my_ascensions())
  {
    if (knoll_available())
    {
      task("Build a " + wrap($item[bitchin' meatcar]));
    } else {
      task("Buy a " + wrap($item[desert bus pass]));
    }
  }

  if (!have($item[dingy dinghy])
      && to_int(get_property("lastDesertUnlock")) >= my_ascensions())
  {
    if (!have($item[dinghy plans]))
    {
      progress(item_amount($item[Shore Inc. Ship Trip Scrip]), 3, "shore scrip for the dinghy plans");
    }
    if (!have($item[dingy planks]))
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

    if (have($item[boris's key])) boris = CHECKED;
    if (have($item[jarlsberg's key])) jarl = CHECKED;
    if (have($item[sneaky pete's key])) pete = CHECKED;

    progress(keys, 3, "hero keys (" + boris + "Boris, " + pete + "Pete, " + jarl + "Jarlsberg)");

    if (quest_status("questL07Cyrptic") > UNSTARTED
        && !have($item[skeleton key]))
    {
      task("make skeleton key");
    }

  }
  if (have($item[steam-powered model rocketship])
      && !have($item[richard's star key])
      && quest_status("questL13Final") < 5)
  {
    int star = min(item_amount($item[star]), 8);
    int line = min(item_amount($item[line]), 7);
    int chart = min(item_amount($item[star chart]), 1);
    int key_total = star + line + chart;
    string key_msg = " ("+star+ " " + wrap($item[star], star) + ", " + line + " " + wrap($item[line], line) + ", " + chart + " " + wrap($item[star chart], chart) + ")";
    progress(key_total, 16, "make " + wrap($item[richard's star key]) + key_msg);
  }

  if (quest_status("questL13Final") < 5
      && hero_keys() < 3
      && !to_boolean(get_property("dailyDungeonDone")))
  {
    int keys = 3 - hero_keys();
    progress(to_int(get_property("_lastDailyDungeonRoom")), 15, "daily dungeon rooms");
  }

  if (have_outfit("swashbuckling getup") && quest_status("questM12Pirate") == UNSTARTED)
  {
    task("Find " + wrap($item[cap'm caronch's map]));
  }
  if (quest_status("questM12Pirate") == 0)
  {
    task("Get " + wrap($item[Cap'm Caronch's nasty booty]));
  }
  if (quest_status("questM12Pirate") == 1)
  {
    task("Get " + wrap($item[orcish frat house blueprints]));
  }
  if (quest_status("questM12Pirate") == 2)
  {
    task("Get " + wrap($item[cap'm caronch's dentures]));
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
    if (have($item[mizzenmast mop]))
    {
      mop = CHECKED;
      fledge_count++;
    }
    if (have($item[ball polish]))
    {
      ball = CHECKED;
      fledge_count++;
    }
    if (have($item[rigging shampoo]))
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

  if (quest_status("questL05Goblin") < 1 && !have($item[Knob Goblin encryption key]))
  {
    progress($location[The Outskirts of Cobb's Knob].turns_spent, 11, "turns in the Outskirts of Cobb's Knob to get the encryption key");
  }

  if (!have($item[digital key])
      && have($item[continuum transfunctioner])
      && quest_status("questL13Final") < 5)
  {
    progress(item_amount($item[white pixel]), 30, "make a " + wrap($item[digital key]));
  }
  if (item_amount($item[red pixel potion]) < 5
      && have($item[continuum transfunctioner])
      && quest_status("questL13Final") < 11
      && !have_skill($skill[ambidextrous funkslinging]))
  {
    progress(item_amount($item[red pixel potion]), 5, wrap($item[red pixel potion], 5) + " for " + wrap($monster[your shadow]));
  }

  if (quest_active("questM20Necklace"))
  {
    int desks = to_int(get_property("writingDesksDefeated"));

    if (desks < 5 && have($item[ghost of a necklace]))
    {
      // sometimes mafia loses track of a desk fight, which is sad.
      desks = 5;
      set_property("writingDesksDefeated", 5);
    }

    if (desks == 0)
    {
      // not sure if we're doing the writing desk trick at this point, so
      // display as if we're not:
      switch (quest_status("questM20Necklace"))
      {
        case STARTED:
          int hot_drawers = min(4, 1 + floor(numeric_modifier("hot resistance")/3));
          int stench_drawers = min(4, 1 + floor(numeric_modifier("stench resistance")/3));
          string drawers = " (" + wrap(hot_drawers, "red") + " or " + wrap(stench_drawers, "green") + " drawers/turn)";
          progress(to_int(get_property("manorDrawerCount")), 21, "drawers searched in " + wrap($location[the haunted kitchen]) + drawers);
          break;
        case 1:
        case 2:
          int pool = approx_pool_skill();
          int max_pool = max(pool, 18);
          progress(pool, max_pool, "approx. pool skill for the " + wrap($location[the haunted billiards room]));
          break;
        case 4:
          task("Return the "+ wrap($item[ghost of a necklace]) + " to " + wrap("Lady Spookyraven", COLOR_MONSTER));
          break;
      }
    }

    if (desks > 0 && desks < 5)
    {
      progress(desks, 5, "defeated " + wrap($monster[writing desk]));
    }

  }

  if (quest_status("questM21Dance") > UNSTARTED && quest_status("questM21Dance") < 3)
  {
    string shoes = UNCHECKED;
    string gown = UNCHECKED;
    string puff = UNCHECKED;
    if (have($item[Lady Spookyraven's powder puff]))
      puff = CHECKED;
    if (have($item[Lady Spookyraven's dancing shoes]))
      shoes = CHECKED;
    if (have($item[Lady Spookyraven's finest gown]))
      gown = CHECKED;
    progress(dancing_items(), 3, "dancing things found (" + puff + " puff, " + shoes + " shoes, " + gown + " gown)");
  }

  if (quest_active("questL06Friar"))
  {
    string dodecagram = UNCHECKED;
    string candles = UNCHECKED;
    string butterknife = UNCHECKED;
    if (have($item[dodecagram]))
      dodecagram = CHECKED;
    if (have($item[box of birthday candles]))
      candles = CHECKED;
    if (have($item[eldritch butterknife]))
      butterknife = CHECKED;

    progress(friar_things(), 3, "Friar ceremony objects (" + dodecagram + " dodecagram, " + candles + " candles, " + butterknife + " butterknife)");
  }

  if (quest_active("questM10Azazel"))
  {
    progress(item_amount($item[imp air]), 5, "imp airs");
    if (!have($item[observational glasses]))
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

  if (quest_status("questL08Trapper") == 2)
  {
    int gear = 0;
    foreach x in $items[ninja carabiner,
                        ninja rope,
                        ninja crampons]
    {
      if (have(x)) gear++;
    }

    string carabiner = UNCHECKED;
    string rope = UNCHECKED;
    string crampons = UNCHECKED;

    if (have($item[ninja carabiner])) carabiner = CHECKED;
    if (have($item[ninja rope])) rope = CHECKED;
    if (have($item[ninja crampons])) crampons = CHECKED;

    progress(gear, 3, "ninja gear (" + carabiner + "carabiner, " + rope + "rope, " + crampons + "crampons), or use eXtreme slope");
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
        progress(310.66 - oil, 310.66, wrap($location[oil peak]) + " pressure");

      int boo = to_int(get_property("booPeakProgress"));
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

  }

  if (quest_active("questL10Garbage"))
  {

    if (quest_status("questL10Garbage") < 2)
    {
      if (!have($item[enchanted bean]))
        task("Get an " + wrap($item[enchanted bean]));
      else
        task("Grow the beanstalk.");
    }

    if (!have($item[s.o.c.k.]))
    {
      progress(immateria(), 4, "Immateria found");
      progress($location[the penultimate fantasy airship].turns_spent, 20, "minimum turns in the airship to find the " + wrap($item[s.o.c.k.]) + ".");
      if (immateria() == 4)
        task("Find the " + wrap($item[s.o.c.k.]));
    }

    if (quest_status("questL10Garbage") == 7)
      task("Open the " + wrap($location[The Castle in the Clouds in the Sky (Basement)]));

    if (quest_status("questL10Garbage") == 8)
      progress($location[The Castle in the Clouds in the Sky (Ground Floor)].turns_spent, 11, "progress to open the top floor of the castle");

    if (quest_status("questL10Garbage") == 9)
      task("Spin the garbage wheel");

  }
  if (quest_status("questL10Garbage") >= 9
      && !have($item[steam-powered model rocketship]))
  {
    task("Find a " + wrap($item[steam-powered model rocketship]));
  }

  if (quest_status("questM21Dance") == FINISHED
      && $location[the haunted ballroom].turns_spent < 5)
  {
    progress($location[The Haunted Ballroom].turns_spent, 5, "delay on " + wrap($location[The Haunted Ballroom]));
  }

  if (quest_active("questL11MacGuffin"))
  {
    if (quest_active("questL11Black"))
      progress(get_property("blackForestProgress").to_int(), 5, "progress through " + wrap($location[the black forest]));

    if (quest_status("questL11Black") > UNSTARTED
        && !have($item[beehive]))
    {
      task("Find a " + wrap($item[beehive]));
    }

    if (quest_active("questL11Desert"))
    {
      int desert = to_int(get_property("desertExploration"));
      progress(desert, "desert explored");
    }

    if (quest_status("questL11Worship") >= 3 && quest_status("questL11Worship") < FINISHED)
    {
      if (!have($item[antique machete])) task("Find an " + wrap($item[antique machete]));
      progress(item_amount($item[stone triangle]), 4, "stone triangles from the Hidden City");

      if (quest_status("questL11Doctor") == UNSTARTED)
        progress($location[An Overgrown Shrine (Southwest)].turns_spent, 3, "defeated southwest/hospital " + wrap($monster[dense liana]));
      if (quest_status("questL11Spare") == UNSTARTED)
        progress($location[An Overgrown Shrine (Southeast)].turns_spent, 3, "defeated southeast/bowling " + wrap($monster[dense liana]));
      if (quest_status("questL11Business") == UNSTARTED)
        progress($location[An Overgrown Shrine (Northeast)].turns_spent, 3, "defeated northeast/office " + wrap($monster[dense liana]));
      if (quest_status("questL11Curses") == UNSTARTED)
        progress($location[An Overgrown Shrine (Northwest)].turns_spent, 3, "defeated northwest/apartment " + wrap($monster[dense liana]));

      int surgeon = to_int(get_property("hiddenHospitalProgress"));
      if (quest_active("questL11Doctor"))
      {
        int s = numeric_modifier("surgeonosity");
        progress(s, 5, "surgeonosity (" + (s * 10) + "% to find protector spirit)");
      }

      if (quest_active("questL11Spare"))
      {
        progress(to_int(get_property("hiddenBowlingAlleyProgress")), 5, "bowling balls rolled");
      }

      if (quest_active("questL11Business"))
      {
        if (!have($item[McClusky file (complete)]))
        {
          if (!have($item[boring binder clip]))
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

    if (quest_active("questL11Manor"))
    {
      if (quest_status("questL11Manor") == 2)
      {
        if (!can_make_wine_bomb())
        {
          progress(scavenger_hunt_items(), 6, "manor scavenger hunt items");
        } else {
          if (!have($item[unstable fulminate]))
          {
            task("make unstable fulminate");
          } else {
            task("make wine bomb");
          }
        }
      }
    }

    if (quest_active("questL11Pyramid"))
    {
      progress(turners(), 10, "wheel turning things");
    }

    task("Recover the " + wrap("Holy MacGuffin", COLOR_ITEM) + ".");
  }


  if (quest_status("questL12War") == STARTED)
  {
    task("Start the Island War");
  }

  if (quest_active("warProgress"))
  {
      if (war_arena()
          && get_property("sidequestArenaCompleted") == "none"
          && have_flyers())
      {
        int flyerML = get_property("flyeredML").to_int() / 100;
        progress(flyerML, "flyers delivered");
      }

      if (war_nuns()
          && get_property("sidequestNunsCompleted") == "none"
          && (war_nuns_accessible() || war_nuns_trick()))
      {
        string nuns_msg = "Meat returned to the Nuns";
        float drop = 1 + (numeric_modifier("meat drop") / 100);
        float min_meat = $monster[dirty thieving brigand].min_meat * drop;
        float max_meat = $monster[dirty thieving brigand].max_meat * drop;
        int remaining = 100000 - to_int(get_property("currentNunneryMeat"));

        int max_turns = round(remaining / min_meat);
        int min_turns = round(remaining / max_meat);

        nuns_msg += " (est remaining turns: " + min_turns + "-" + max_turns + ")";
        progress(to_int(get_property("currentNunneryMeat")), 100000, nuns_msg);
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
        if (have($item[heart of the filthworm queen]))
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

      int sq_completed = 0;
      int sq_active = 0;
      string sq_msg = "";

      if (setting("war_nuns", "false") == "true"
          || get_property("sidequestNunsCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestNunsCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Nuns";
        } else {
          sq_msg += UNCHECKED + "Nuns";
        }
      }

      if (setting("war_orchard", "true") == "true"
          || get_property("sidequestOrchardCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestOrchardCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Orchard";
        } else {
          sq_msg += UNCHECKED + "Orchard";
        }
      }

      if (setting("war_lighthouse", "true") == "true"
          || get_property("sidequestLighthouseCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestLighthouseCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Lighthouse";
        } else {
          sq_msg += UNCHECKED + "Lighthouse";
        }
      }

      if (setting("war_arena", "true") == "true"
          || get_property("sidequestArenaCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestArenaCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Arena";
        } else {
          sq_msg += UNCHECKED + "Arena";
        }
      }

      if (setting("war_junkyard", "true") == "true"
          || get_property("sidequestJunkyardCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestJunkyardCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Junkyard";
        } else {
          sq_msg += UNCHECKED + "Junkyard";
        }
      }
      sq_msg = "war sidequests (" + sq_msg + ")";
      if (sq_active > 0) progress(sq_completed, sq_active, sq_msg);

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


  if (quest_status("questL06Friar") > UNSTARTED && !have($item[wand of nagamar]))
  {
    int wand = 0;
    string wand_parts = "";
    if (have($item[ruby W]) || have($item[WA]))
    {
      wand_parts = "W";
      wand++;
    }
    if (have($item[metallic a]) || have($item[WA]))
    {
      if (length(wand_parts) > 0) wand_parts += ", ";
      wand_parts += "A";
      wand++;
    }
    if (have($item[lowercase n]) || have($item[nd]))
    {
      if (length(wand_parts) > 0) wand_parts += ", ";
      wand_parts += "N";
      wand++;
    }
    if (have($item[heavy d]) || have($item[nd]))
    {
    if (length(wand_parts) > 0) wand_parts += ", ";
    wand_parts += "D";
      wand++;
    }

    if (length(wand_parts) > 0) wand_parts = " (" + wand_parts + ")";

    progress(wand, 4, "make a " + wrap($item[wand of nagamar]) + wand_parts);
  }

  progress_sheet_detail(detail);

  for x from 0 to 25
  {
    if (get_counters("Digitize monster", x, x) != "")
    {
      yz_print("Digitized monster (" + wrap(to_monster(get_property("_sourceTerminalDigitizeMonster"))) + ") coming up in " + wrap(x, COLOR_MONSTER) + " turns.", COLOR_TASK);
    }

    if (get_counters("Enamorang Monster", x, x) != "")
    {
      yz_print("Enamoranged Monster (" + wrap(to_monster(get_property("enamorangMonster"))) + ") coming up in " + wrap(x, COLOR_MONSTER) + " turns.", COLOR_TASK);
    }

    string last_rare = "";
    if (to_location(get_property("semirareLocation")) != $location[none])
    {
      last_rare = " (previous: " + wrap(to_location(get_property("semirareLocation")));
      last_rare += ", next: " + wrap(pick_semi_rare_location()) +  ")";
    } else {
      last_rare = " (next: " + wrap(pick_semi_rare_location()) +  ")";
    }

    if (get_counters("Fortune Cookie", x, x) != "")
    {
      yz_print("Semirare in " + wrap(x, COLOR_MONSTER) + " turns." + last_rare, COLOR_TASK);
    }

    if (get_counters("Semirare window begin", x, x) != "")
    {
      yz_print("Semirare window begins in " + wrap(x, COLOR_MONSTER) + " turns. " + last_rare, COLOR_TASK);
    }

    if (get_counters("Semirare window end", x, x) != "")
    {
      yz_print("Semirare window ends in " + wrap(x, COLOR_MONSTER) + " turns.", COLOR_TASK);
    }

  }

  foreach puff in $items[cuppa uncertain tea,
                         cuppa gill tea,
                         cuppa royal tea,
                         cuppa sobrie tea,
                         cuppa voraci tea,
                         mojo filter,
                         instant karma,
                         invisible string,
                         resolution: be more adventurous]
  {
    smoke_if_got_it(puff);
  }

  if (detail == "all")
  {
    foreach toy in $items[special edition batfellow comic]
    {
      if (have(toy))
      {
        task("Consider using your " + wrap(toy) + ".");
      }
    }

    if (to_boolean(setting("do_jerk", "true"))
        && to_boolean(setting("do_heart", "true")))
    {
      foreach freepull in $items[holiday fun!,
                                 aggressive carrot,
                                 roll of toilet paper,
                                 glass of warm water]
      {
        int so_many = get_free_pulls()[freepull];
        if (so_many > 0)
        {
          if (!have(freepull))
          {
            // don't mention if we already have some to reduce progress() clutter
            task("Hangk is storing " + so_many + " "  + wrap(freepull, so_many) + ". They're free pulls, so consider taking them out.");
          }
        }
      }

    }

    foreach freepull in $items[special edition batfellow comic,
                               arrowgram]
    {
      int so_many = get_free_pulls()[freepull];
      if (so_many > 0)
      {
        if (!have(freepull))
        {
          // don't mention if we already have some to reduce progress() clutter
          task("Hangk is storing " + so_many + " "  + wrap(freepull, so_many) + ". They're free pulls, so consider taking them out.");
        }
      }
    }

    if (have($item[burned government manual fragment]))
    {
      task("Consider using your " + wrap($item[burned government manual fragment]) + " (they'll disappear after ascension)");
    }

    // get new familiars as you find them:
    foreach f in $familiars[]
    {
      if (!have_familiar(f) && have(f.hatchling))
      {
        task("You have a " + wrap(f.hatchling) + " which can hatch into a " + wrap(f) + ", which you don't have.");
      }
    }


  }

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
