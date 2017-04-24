script "yaaz.ash"
notify "degrassi";

import "util/main.ash";
import "util/progress.ash";
import "yaaz/yaaz-begin.ash";

import "util/quests_main.ash";

// Note: If you want to change the order quests are run in, see quests.ash
// and edit the QUEST_LIST there.

int current_level;

boolean ascend_loop()
{
  progress_sheet();
  current_quest = "";

  if (!can_adventure()) return false;
  if (quest_status("questL13Final") >= 13) return false;

  if (current_level != my_level())
  {
    log("We've gained a level. Checking out the council to see what's new.");
    current_level = my_level();
    council();
    cli_execute("refresh inv");
    return true;
  }

  // Quests that have been converted to the new format.
  // Only move quests into this loop when they original code is adjacent to this
  // so it can preserve the quest loop ordering:

  foreach quest in QUEST_LIST
  {
    string clean = quest + "_cleanup";
    call clean();
  }
  foreach quest in QUEST_LIST
  {
    current_quest = quest;
    boolean b = call boolean quest();
    if (b) return true;
  }

  log("Ran out of things to do in this script. Maybe a quest is missing, or we're possibly in a state this script can't figure out.");
  return false;
}

void skill_warning()
{
  if (!have_skill($skill[pulverize]))
  {
    warning("This script is written assuming you have the " + wrap($skill[pulverize]) + " skill.");
    warning("It'll work without it, but be inefficient in several ways. I recommend getting");
    warning(wrap($skill[pulverize]) + " before relying on this script.");
    wait(10);
  }

}

void settings_warning()
{
  if (to_float(get_property("mpAutoRecovery")) < 0.1)
  {
    warning("Your auto restore MP settings seems to not be set.");
    warning("Setting this to something I think is reasonable, but you may want to skip out here and change yourself if desired.");
    wait(10);
    set_property("mpAutoRecoveryTarget", 0.6);
    set_property("mpAutoRecovery", 0.45);
  }
  if (to_float(get_property("hpAutoRecovery")) < 0.1)
  {
    warning("Your auto restore HP settings seem to not be set.");
    warning("Setting this to something I think is reasonable, but you may want to skip out here and change yourself if desired.");
    wait(10);
    set_property("hpAutoRecoveryTarget", 0.9);
    set_property("hpAutoRecovery", 0.6);
  }

  string mood = 'default';
  foreach x, m in get_moods()
  {
    if (m == 'yaaz') mood = m;
  }

  if (get_property("currentMood") != mood)
  {
    warning("This script doesn't use KoLMafia's mood system.");
    if (mood == 'default')
    {
      warning("If you want to add custom mood handling while running this script, create a 'yaaz'");
      warning("mood and I'll try using that instead.");
    } else {
      warning("You've created a 'yaaz' mood to add your custom mood interested. Setting your mood to that.");
    }
    wait(10);
    set_property("currentMood", mood);
  }


  if (!to_boolean(get_property("autoSatisfyWithNPCs")))
  {
    warning("In KoLMafia's preferences (General/Item Aquisition), you've set " + wrap("Buy items from NPC stores whenever needed", COLOR_ITEM) + " off.");
    warning("I'll try to work with this, but it's highly advised you set this on so I can buy things from NPCs.");
    wait(10);
  }

  if (!to_boolean(get_property("autoSatisfyWithCoinmasters")))
  {
    warning("In KoLMafia's preferences (General/Item Aquisition), you've set " + wrap("Buy items with tokens at coin masters whenever needed", COLOR_ITEM) + " off.");
    warning("I'll try to work with this, but it's highly advised you set this on so I can buy things from NPCs.");
    wait(10);
  }


  if (!hippy_stone_broken()
      && setting("no_pvp") != "true"
      && my_daycount() == 1)
  {
    warning("You haven't broken your Hippy Stone to enable PvP.");
    warning("This script can handle PvP for you if you break the stone.");
    warning("If you don't want to fight in PvP, and don't want this message,");
    log("set " + SETTING_PREFIX + "_no_pvp=true");
    warning("Otherwise, his ESC and go break that stone!");
    wait(10);
  }
}

void intro()
{

  log("Welcome to " + wrap(SCRIPT, COLOR_LOCATION) + ", 'Yet Another Ascension Zcript.'");
  log("Original author and maintainer: <a href='showplayer.php?who=1063113'>" + wrap("Degrassi (#1063113)", 'blue') + "</a>.");
  log("Additional wonderful contributors: <a href='showplayer.php?who=2866791'>" + wrap("Gaikotsu (#2866791)", 'blue') + "</a>.");
  log("This script takes inspiration, and bits of code, from <a href='showplayer.php?who=2866791'>" + wrap("Cheesecookie (#2355952)", 'blue') + "</a>'s ascension script.");
  boolean has_fam = false;
  foreach f in $familiars[]
  {
    if (have_familiar(f))
    {
      has_fam = true;
      break;
    }
  }

  if (!has_fam)
  {
    error("You don't have any familiars yet. This script needs to have at least one familiar. Go get one manually and try re-running this script.");
    abort();
  }

  if (!svn_exists("winterbay-mafia-wham"))
  {
    warning("While this script tries to not require other scripts, and just skips functionality in those cases,");
    warning("I can't currently function without Winterbay's excellent 'WHAM' script. Please go install that and");
    warning("then rerun this script.");
    abort();
  }

  log("This is an automated ascension script, but has some additional features.");
  log("To get more information, run the " + SCRIPT + "-help script.");
  log("Go to " + wrap("<a href='https://github.com/mapledyne/yaaz'>https://github.com/mapledyne/yaaz</a>", "blue") + " to see known issues, submit bugs, request features, etc.");
  wait(5);

  if (my_ascensions() == 0)
  {
    warning("This script is meant to help auto-ascend. You're on your first ascension. This script will do some things inefficiently. For instance, it won't take advantage of the mall when otherwise possible.");
    wait(5);
  }

  if (!in_hardcore() && my_ascensions() > 0)
  {
    warning("This script is built with Hardcore in mind. It has rudimentary Softcore support, but it may still do some things the hard way.");
    if (to_boolean(setting("no_pulls", false)))
    {
      log("You've set " + SETTING_PREFIX + "_no_pulls to true, so I won't make any pulls from Hagnk's. Make these pulls manually if you want to.");
    } else {
      log("This script will make pulls from Hangk's as it thinks is appropriate. Set " + SETTING_PREFIX + "_no_pulls=true if you want the script to not make any pulls.");
    }
  }

  if (my_ascensions() < 10
      && (!contains_text(get_property("hpAutoRecoveryItems"), "rest at your campground")
          || !contains_text(get_property("mpAutoRecoveryItems"), "rest at your campground")))
  {
    warning("Your restore options (under HP/MP Usage) you don't have 'rest at your campground' selected.");
    warning("That option takes a turn, which is sad, but I'm worried you don't have the skills and resources to be able to easily avoid it.");
    warning("I will continue without resting, but there's a high chance the script will fail with '" + wrap("Autorecovery failed", COLOR_ERROR) + "' errors.");
    warning("In those cases, you'll have to recover yourself and then rerun the script.");
    wait(10);
  }

  if (my_turncount() == 0)
  {
    familiar pet = to_familiar(setting("100familiar"));
    if (pet == $familiar[none])
    {
      log("You don't have a familiar selected to do a 100% run with. This may be correct (and I'll use the best familiar I can find for each quest), but if you want to complete a 100% run, hit ESC and set the variable before rerunning:");
      print("set yz_100familiar=mosquito");
      log("If you're not doing a tour guide run, then do nothing and I'll carry on my way.");
    } else {
      log("You have a familiar selected to do a 100% run with. I'm pausing here so you can check it in case you had it set from a previous ascension. If you want to change it, hit ESC and change the setting:");
      print("set yz_100familiar=mosquito");
      log("If you're wanting a tour guide run with your " + wrap(pet) + ", then do nothing and I'll carry on my way.");
    }
    wait(10);
  }

  if (my_path() == "One Crazy Random Summer")
  {
    warning("This script doesn't handle well some of the monster modifiers in this path (" + wrap(my_path(), COLOR_LOCATION) + "). When this happens, you can finish the fight and re-run the script to pick back up.");
    wait(5);
  }

  if (holiday() != "")
  {
    warning("Today is a holiday! If you want to celebrate " + wrap(holiday(), COLOR_LOCATION) + ", hit ESC and enjoy! Otherwise we'll continue as normal.");
    wait(10);
  }
}

void ascend()
{
  current_level = my_level();

  intro();
  skill_warning();

  settings_warning();

  day_begin();

  if (quest_status("questL13Final") >= 13)
  {
    log("You've defeated the " + wrap($monster[naughty sorceress]) + ". Hooray!");
    log("This script doesn't have much for you to do beyond that. Go do aftercore stuff,");
    log("or go and ascend and do it all over again!");

    skill_recommendation();
    return;
  }

  log("Day startup tasks complete. About to begin doing stuff.");
  wait(10);

  if (!can_adventure())
  {
    log("You're already out of adventures you can use today.");
    log("Doing cleanup actions, but skipping main quest loop.");
  }

  while(ascend_loop())
  {
    special();
    manuel_progress();
  }

  special();
  manuel_progress();

  if (quest_status("questL13Final") >= 13)
  {
    log("You've defeated the " + wrap($monster[naughty sorceress]) + ". Hooray!");
    log("This script doesn't have much for you to do beyond this. Go do aftercore stuff,");
    log("or go and ascend and do it all over again!");
    return;
  }

  if (my_adventures() < 10 && booze_full() && fullness_full())
  {
    log("It looks like you don't have much else you can do today. Consider a nightcap if you don't want to do anything else manually?");
  } else if (drunk())
  {
    log("You're drunk, so there isn't anything else this script can do for you. Come back tomorrow!");
  }
  else
  {
    log("There may be other things you can do today, but this script can't handle them.");
    log("Do those, or just try rerunning this script - there are a few times that this scripts stops where it can be just reran to pick up where it left off.");
  }

  warning("Run " + wrap(SCRIPT + "-end", COLOR_ITEM) + " if you're done for the day to perform final cleanup.");

}

void main()
{
  ascend();
}
