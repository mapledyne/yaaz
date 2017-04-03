script "yaaz.ash"
notify "degrassi";

import "util/main.ash";
import "util/progress.ash";
import "yaaz/yaaz-begin.ash";

import "quests/M_misc.ash";
import "quests/M_dailydungeon.ash";
import "quests/M_guild.ash";
import "quests/M_hidden_temple.ash";
import "quests/M_8bit.ash";
import "quests/M_pirates.ash";
import "quests/M_spookyraven.ash";
import "quests/M_untinker.ash";
import "quests/M06_pandemonium.ash";
import "quests/M09_leaflet.ash";
import "quests/M10_star_key.ash";

import "quests/L02_Q_larva.ash";
import "quests/L03_Q_rats.ash";
import "quests/L04_Q_bats.ash";
import "quests/L05_Q_goblin.ash";
import "quests/L06_Q_friar.ash";
import "quests/L07_Q_cyrpt.ash";
import "quests/L08_Q_trapper.ash";
import "quests/L09_Q_topping.ash";
import "quests/L10_Q_Garbage.ash";
import "quests/L11_Q_macguffin.ash";
import "quests/L12_Q_war.ash";
import "quests/L13_Q_sorceress.ash";

import "quests/M_level_up.ash";

int current_level;

boolean ascend_loop()
{

  if (!can_adventure())
    return false;

  if (quest_status("questL13Final") >= 13) return false;

  if (current_level != my_level())
  {
    log("We've gained a level. Checking out the council to see what's new.");
    current_level = my_level();
    council();
  }

  // returning true here ultimately just causes us to start this
  // function over again.
  // If you do no work in one of these functions, you should
  // generally return false to let the next quest in line run.

  // misc things we should probably just do as soon as we can:
  if (M_misc()) return true;
  if (M_guild()) return true; // only opens the guild - doesn't do the full guild quest.
  if (M_untinker()) return true;
  if (M06_pandemonium()) return true; // steel items
  if (M09_leaflet()) return true;
  if (M_pirates()) return true;
  if (M_dailydungeon()) return true;

  // do a bit earlier than other order to get the Knob opened earlier.
  // earlier knob == earlier dispensary if we get a KGE outfit.
  if (L05_Q_goblin()) return true;

  // do this one earlier since it opens the pandemonium.
  if (L06_Q_friar()) return true;

  // do this as soon as it's available - earlier start to the war == earlier arena fliers
  if (L12_Q_war()) return true;

  // do this one earlier if only to talk to the trapper sooner.
  if (L08_Q_trapper()) return true;

  // Misc quests. More efficient for these to go later?
  if (M_hidden_temple()) return true;
  if (M_spookyraven()) return true;

  // whatever is left can be done in order:
  if (L02_Q_larva()) return true;
  if (L03_Q_rats()) return true;
  if (L04_Q_bats()) return true;
  if (L07_Q_cyrpt()) return true;
  if (L09_Q_topping()) return true;
  if (L10_Q_garbage()) return true;
  if (L11_Q_macguffin()) return true;

  // towards the end since the timing really doesn't matter much on this one.
  // keeping it here may help us level when there's no other quest to do?
  if (M_8bit()) return true;
  if (M10_star_key()) return true;

  if (L13_Q_sorceress()) return true;

  warning("Ran out of quest things to do in this script. Adventuring (and leveling) until we can do something better.");
  if (M_level_up()) return true;

  log("Ran out of things to do in this script. Either a quest is missing, or maybe we should level?");
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

  if (!have_skill($skill[Ambidextrous Funkslinging]))
  {
    warning("This script is written assuming you have the " + wrap($skill[Ambidextrous Funkslinging]) + " skill.");
    warning("It'll work without it, but will be inefficient fighting " + wrap($monster[your shadow]) + ".");
    warning("Get " + wrap($skill[Ambidextrous Funkslinging]) + " to really utilize this script.");
    if (my_class() == $class[disco bandit])
      warning("Because you're a " + wrap(my_class()) + ", we'll try to pick up " + wrap($skill[Ambidextrous Funkslinging]) + " as we go.");
    wait(10);
  }

}

void settings_warning()
{
  if (to_float(get_property("mpAutoRecovery")) < 0.1)
  {
    warning("Your auto restore MP settings seems to not be set.");
    warning("Set it to what you think is right for you in the 'HP/MP Usage' tab.");
    warning("(A reasonable default is to restore at 50%, recovering up to 60%)");
    abort('Rerun this script once this setting is changed.');
  }
  if (to_float(get_property("hpAutoRecovery")) < 0.1)
  {
    warning("Your auto restore HP settings seem to not be set.");
    warning("Set it to what you think is right for you in the 'HP/MP Usage' tab.");
    warning("(A reasonable default is to restore at 60%, recovering up to 90%)");
    abort('Rerun this script once this setting is changed.');
  }

  if (!to_boolean(get_property("autoSatisfyWithNPCs")))
  {
    warning("In KoLMafia's preferences (General/Item Aquisition), you've set " + wrap("Buy items from NPC stores whenever needed", COLOR_ITEM) + " off.");
    warning("I'll try to work with this, but it's highly advised you set this on so I can buy things from NPCs.");
    wait(10);
  }

  if (!to_boolean(get_property("autoSatisfyWithNPCs")))
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

  if (setting("no_intro") != "true")
  {
    log("This is an automated ascension script, but has some additional features.");
    string help = "To get more information, run the " + SCRIPT + "-help.ash script.";
    log(help);
    log("To remove this messages: set " + SETTING_PREFIX + "_no_intro=true");
    wait(5);
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
