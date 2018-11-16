script "yaaz-progress.ash"
notify "degrassi";
since r17948;

import "util/base/yz_quests.ash";
import "util/base/yz_print.ash";
import "util/base/yz_inventory.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_war_support.ash";
import "util/base/yz_paths.ash";
import "util/base/yz_util.ash";
import "util/base/yz_locations.ash";

import "special/yz_special.ash";
import "util/yz_quests_main.ash";

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

void smoke_if_got_it(item it)
{
  if (!have(it)) return;
  if (!be_good(it)) return;

  task("You have a " + wrap(it) + ". Manually use or closet (or sell, or whatever)");
}

void progress_sheet_detail()
{
  // extra details for the sheet when requested.

  string detail = "all"; // to be removed once we get rid of do_detail

  foreach special_thing in SPECIAL_LIST
  {
    string special_progress = special_thing + "_progress";
    call special_progress();
  }

  if (smiles_remaining() > 0)
  {
    progress(5 - smiles_remaining(), total_smiles(), "smiles from your " + wrap($item[Golden Mr. Accessory]), "blue");
  }

}

void progress_sheet(boolean detailed)
{

  if (detailed)
  {
    log("Turns used this ascension: " + wrap(my_turncount(), COLOR_LOCATION) + ", over " + wrap(my_daycount(), COLOR_LOCATION) + " days.");
    string hc = "";
    if (in_hardcore()) hc = "Hardcore ";
    log("Current path: " + wrap(hc + my_path(), COLOR_LOCATION));
  }
  else
  {
    log("Turns used this ascension: " + wrap(my_turncount(), COLOR_LOCATION) + ".");
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

  foreach quest in QUEST_LIST
  {
    string quest_progress = quest + "_progress";
    call quest_progress();
  }

  if (detailed)
  {
    progress_sheet_detail();
  }

  item votedsticker = $item[9990]; // "I Voted" sticker

  if (have(votedsticker) && to_int(get_property("_voteFreeFights")) < 2)
  {
    int wait_time = voting_counter();
    if (wait_time < 4)
    {
      yz_print("Voting monster is up in " + wrap(wait_time, COLOR_MONSTER) + " turns.", COLOR_TASK);
    }

  }

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
                         resolution: be more adventurous]
  {
    smoke_if_got_it(puff);
  }

  if (detailed)
  {
    if (to_boolean(setting("do_jerk", "true"))
        && to_boolean(setting("do_heart", "true")))
    {
      foreach freepull in $items[holiday fun!,
                                 aggressive carrot,
                                 roll of toilet paper,
                                 glass of warm water]
      {
        int so_many = get_free_pulls()[freepull];
        if (so_many > 0 && be_good(freepull))
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

    if (have($item[burned government manual fragment]) && be_good($item[burned government manual fragment]))
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
  progress_sheet(false);
}

void main()
{
  print("Version: " + version);
  print("Current progress in a few things:");
  progress_sheet(true);

}
