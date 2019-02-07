import "util/yz_main.ash";

void neverending_progress()
{
  if (!to_boolean(get_property("neverendingPartyAlways"))
      || !be_good($item[Neverending Party invitation envelope]))
  {
    return;
  }
  int free = prop_int("_neverendingPartyFreeTurns");

  if (free < 10)
  {
    progress(free, 10, "free adventures in " + wrap($location[the neverending party]));
  }
  if (quest_status("_questPartyFair") == FINISHED) return;

  string progress = get_property("_questPartyFairProgress");
  int per_adv;
  int remaining;
  string approx;
  string[int] wanted;

  switch(get_property("_questPartyFairQuest"))
  {
    default:
      error("I don't know the neverending quest: " + get_property("_questPartyFairQuest"));
      break;
    case "":
      if (quest_status("_questPartyFair") == UNSTARTED)
      {
        task("Start the party at " + wrap($location[the neverending party]));
      }
      break;
    case "dj":
      int meat_left = to_int(progress);
      float meat_bonus = meat_drop_modifier() / 100;
      per_adv = 100 * (meat_bonus + 1);  // avg meat/fight is roughly 100
      remaining = meat_left / per_adv;
      approx = "(approx " + remaining + " adv remaining with +" + to_int((meat_bonus * 100)) + "% meat bonus)";
      task(wrap(meat_left, COLOR_ITEM) + " meat to claim for the dj. " + approx);
      break;
    case "trash":
      int trash_left = to_int(progress);
      float item_bonus = item_drop_modifier() - 100;
      per_adv = min(200, 45 + (item_bonus / 3));
      remaining = trash_left / per_adv;
      approx = "(approx " + remaining + " adv remaining with +" + to_int(item_bonus) + "% item bonus)";
      task(wrap(trash_left, COLOR_ITEM) + " party trash to clean up. " + approx);
      break;
    case "food":
      if (progress == "")
      {
        task("Find Geraldine and see what food she wants for the party.");
      } else {
        wanted = split_string(progress, " ");
        item snack = to_item(wanted[1]);
        progress(item_amount(snack), to_int(wanted[0]), wrap(snack) + " for Geraldine's party.");
      }
      break;
    case "booze":
      if (progress == "")
      {
        task("Find Gerald and see what booze he wants for the party.");
      } else {
        wanted = split_string(progress, " ");
        item toy = to_item(wanted[1]);
        progress(item_amount(toy), to_int(wanted[0]), wrap(toy) + " for Gerald's party.");
      }
      break;
    case "woots":
      int woot_total = to_int(progress);
      progress(woot_total, 100, "Megawoots to amp up " + wrap($location[the neverending party]));
      break;
    case "partiers":
      int partiers = to_int(progress);
      boolean hard = to_boolean(get_property("_partyHard"));
      int max = 50;
      if (hard) max = 100;
      progress(max - partiers, max, "Partiers cleared in the " + wrap($location[the neverending party]));
      break;
  }

  /*

  _partyHard = true if you started quest wearing Party HARD shirt.
  _questPartyFairQuest = today's quest, valid values are trash, booze, woots, partiers, food and dj.
  _questPartyFair = quest state, valid values:
  unstarted - you haven't yet taken quest
  started - you have taken quest, but haven't started making progress til you talk to Gerald/Geraldine (only exists on booze and food quests)
  step1 - Progressing quest objectives
  step2 - Return to get your reward
  finished - You have completed quest today
  _questPartyFairProgress - depends on quest.
  on trash quest - counts down from XXXX to 0.
  on booze quest - shows number required and item number - note, does not YET recognise quest log entry to count down - it may never count down, as you can see that from inventory.
  on woots quest - counts up from 10 to 100.
  on partiers quest - counts down from XXX to 0.
  on food quest - shows number required and item number - note, does not YET recognise quest log entry to count down - it may never count down, as you can see that from inventory.
  on dj quest - counts down from XXXX to 0.


  */
}

void neverending_cleanup()
{
  string progress = get_property("_questPartyFairProgress");
  if (progress == "") return;

  // only doing these when a quest is going prevents us from using
  // them before we know what we want (so we won't get quest specific
  // items)
  use_all($item[Unremarkable duffel bag]);
  use_all($item[van key]);

}

boolean neverending_partiers(item shirt)
{

  if (!have($item[intimidating chainsaw]))
  {
    set_property("choiceAdventure1324", "4");
    set_property("choiceAdventure1328", "3");
  }
  else if (have($item[jam band bootleg]) && !to_boolean(setting("bootleg_used", "false")))
  {
    set_property("choiceAdventure1324", "1");
    set_property("choiceAdventure1325", "3");
  }
  else if (have($item[Purple Beast energy drink]) && !to_boolean(setting("purple_used", "false")))
  {
    set_property("choiceAdventure1324", "3");
    set_property("choiceAdventure1327", "5");
  }
  else
  {
    set_property("choiceAdventure1324", "5");
  }

  int bootleg = item_amount($item[jam band bootleg]);
  int purple = item_amount($item[Purple Beast energy drink]);

  string max = "items";
  if (shirt != $item[none])
  {
    max += ", equip [" + to_int(shirt) + "]";
  }
  maximize(max, $item[intimidating chainsaw]);

  log("Heading to " + wrap($location[The Neverending Party]) + " to help clear the partiers");

  yz_adventure($location[the neverending party]);

  if (bootleg > item_amount($item[jam band bootleg])) save_daily_setting("booleg_used", "true");

  if (purple > item_amount($item[Purple Beast energy drink])) save_daily_setting("purple_used", "true");

  return true;
}


boolean neverending_dj(item shirt)
{

  maximize("meat, moxie", shirt);
  if (my_buffedstat($stat[moxie]) >= 300)
  {
    set_property("choiceAdventure1324", "1");
    set_property("choiceAdventure1325", "4");
  } else {
    set_property("choiceAdventure1324", "5");
  }

  monster_banish = $monsters[burnout];
  log("Heading to " + wrap($location[The Neverending Party]) + " to help pay the DJ");

  yz_adventure($location[the neverending party]);
  return true;
}

boolean neverending_woots(item shirt)
{
/*
Amp up the party
You start with 10 Megawoots.
You need to reach 100 Megawoots.
Each monster killed will add 3-4 Megawoots, or 1-2 in hard mode.
Having a cosmetic football equipped sets Megawoot gain to 5-6 per fight, in both normal and hard mode.
Throwing a very small red dress on a lamp adds 20 Megawoots. Occurs Upstairs.
Modifying the living room lights with an electronics kit adds 20 Megawoots. Occurs in the Basement.
*/

  if (have($item[very small red dress]))
  {
    set_property("choiceAdventure1324", "1"); // upstairs
    set_property("choiceAdventure1325", "5"); // dress
  }
  else if (have($item[electronics kit]))
  {
    set_property("choiceAdventure1324", "4"); // downstairs
    set_property("choiceAdventure1325", "4"); // electronics kit
  }
  else
  {
    set_property("choiceAdventure1324", "5"); // fight.
  }
  string max = "items";
  if (shirt != $item[none])
  {
    max += ", equip [" + to_int(shirt) + "]";
  }
  maximize(max, $item[cosmetic football]);
  log("Heading to " + wrap($location[The Neverending Party]) + " to woot it up. Woot!");

  yz_adventure($location[the neverending party]);

  return true;
}

boolean neverending_free(item shirt)
{
  // IMPROVE: do something besides fight?
  set_property("choiceAdventure1324", "5");

  maximize("", shirt);
  log("Heading to " + wrap($location[The Neverending Party]) + " since the adventures are free");
  yz_adventure($location[The Neverending Party]);
  return true;

}

boolean neverending_food(item shirt)
{

  string progress = get_property("_questPartyFairProgress");

  if (progress == "")
  {
    set_property("choiceAdventure1324", "2");
    set_property("choiceAdventure1326", "3");
    maximize("", shirt);
    yz_adventure($location[The Neverending Party]);
    return true;
  }

  string[int] wanted = split_string(progress, " ");
  item toy = to_item(wanted[1]);
  int want = to_int(wanted[0]);

  if (want > item_amount(toy) && can_interact())
  {
      int qty = want - item_amount(toy);
      log("Trying to buy " + qty + " " + wrap(toy, qty) + " for the Neverending Party.");
      stock_item(toy, qty);
      if (want >= item_amount(toy)) return true;
  }

  if (want > item_amount(toy))
  {
    monster_attract = $monsters[burnout];
    set_property("choiceAdventure1324", "5");
    maximize("items", shirt);
    yz_adventure($location[the neverending party]);
    return true;
  }

  set_property("choiceAdventure1324", "2");
  set_property("choiceAdventure1326", "4");

  maximize("", shirt);
  log("Heading to " + wrap($location[The Neverending Party]) + " to get some food (" + wrap(toy) + ")");
  yz_adventure($location[The Neverending Party]);
  return true;

}

boolean neverending_trash(item shirt)
{
  string progress = get_property("_questPartyFairProgress");

  set_property("choiceAdventure1324", "2");

  if (have($item[gas can]))
  {
    set_property("choiceAdventure1326", "5");
  }
  else if (my_primestat() == $stat[muscle])
  {
    set_property("choiceAdventure1326", "2");
  }
  else
  {
    set_property("choiceAdventure1326", "1");
  }

  monster_attract = $monsters[biker];

  maximize("items", shirt);
  log("Heading to " + wrap($location[The Neverending Party]) + " to pick up some trash.");

  yz_adventure($location[the neverending party]);

  return true;
}


boolean neverending_booze(item shirt)
{

  string progress = get_property("_questPartyFairProgress");

  if (progress == "")
  {
    set_property("choiceAdventure1324", "3");
    set_property("choiceAdventure1327", "3");
    yz_adventure($location[The Neverending Party]);
    return true;
  }

  string[int] wanted = split_string(progress, " ");
  item toy = to_item(wanted[1]);
  int want = to_int(wanted[0]);

  if (want > item_amount(toy) && can_interact())
  {
      int qty = want - item_amount(toy);
      log("Trying to buy " + qty + " " + wrap(toy, qty) + " for the Neverending Party.");
      stock_item(toy, qty);
      if (want >= item_amount(toy)) return true;
  }

  if (want > item_amount(toy))
  {
    monster_attract = $monsters[jock];
    maximize("items", shirt);
    yz_adventure($location[the neverending party]);
    return true;
  }

  set_property("choiceAdventure1324", "3");
  set_property("choiceAdventure1327", "4");
  maximize("", shirt);
  log("Heading to " + wrap($location[The Neverending Party]) + " to find some booze (" + wrap(toy) + ")");
  yz_adventure($location[The Neverending Party]);
  return true;
}

boolean neverending()
{
  if (!to_boolean(get_property("neverendingPartyAlways"))) return false;

  if (!be_good($item[Neverending Party invitation envelope])) return false;

  if (quest_status("_questPartyFair") == FINISHED) return false;

  string desire = setting("partyfair", "aftercore");

  if (desire == "false") return false;

  if (!in_aftercore() && desire == "aftercore") desire = "free";

  if (desire == "free"
      && prop_int("_neverendingPartyFreeTurns") >= 10)
  {
    return false;
  }

  if (get_property("_questPartyFair") == ""
      && prop_int("_neverendingPartyFreeTurns") >= 10)
  {
    return false;
  }

  boolean partyhard = to_boolean(setting("partyhard", "true"));
  if (!in_aftercore()) partyhard = false;
  if (!have($item[PARTY HARD T-shirt])) partyhard = false;
  if (!have_skill($skill[Torso Awaregness])) partyhard = false;
  item shirt = $item[none];
  if (partyhard) shirt = $item[PARTY HARD T-shirt];

  if (quest_status("_questPartyFair") == UNSTARTED)
  {
    if (desire == "free")
    {
      // reject quest
      set_property("choiceAdventure1322", "2");
    } else {
      // accpet quest
      set_property("choiceAdventure1322", "1");
    }

    maximize("", shirt);
    if (shirt != $item[none])
    {
      log("Starting the " + wrap("Neverending Party", COLOR_LOCATION) + " in hard mode.");
    }
    yz_adventure($location[the neverending party]);
    return true;
  }

  switch(get_property("_questPartyFairQuest"))
  {
    default:
      error("I don't know the neverending quest.");
      wait(5);
      return false;
    case "booze":
      return neverending_booze(shirt);
    case "trash":
      return neverending_trash(shirt);
    case "dj":
      return neverending_dj(shirt);
    case "woots":
      return neverending_woots(shirt);
    case "food":
      return neverending_food(shirt);
    case "partiers":
      return neverending_partiers(shirt);
    case "":
      return neverending_free(shirt);
  }

  return true;
}

void main()
{
  neverending();
}
