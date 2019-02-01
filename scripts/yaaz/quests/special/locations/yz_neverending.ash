import 'util/base/yz_print.ash';
import 'util/base/yz_settings.ash';
import 'util/prep/yz_prep.ash';
import 'util/base/yz_maximize.ash';

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
  use_all($item[Unremarkable duffel bag]);
  use_all($item[van key]);

}

boolean neverending_dj()
{

  maximize("meat, moxie");
  if (my_buffedstat($stat[moxie]) >= 300)
  {
    set_property("choiceAdventure1324", "1");
    set_property("choiceAdventure1325", "4");
  } else {
    set_property("choiceAdventure1324", "5");
  }

  monster_banish = $monsters[burnout];
  yz_adventure($location[the neverending party]);
  return true;
}

boolean neverending_woots()
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
  maximize("items", $item[cosmetic football]);

  yz_adventure($location[the neverending party]);

  return true;
}

boolean neverending_free()
{
  // TODO: we should sort out choice adventures
  yz_adventure($location[The Neverending Party], "");
  return true;

}

boolean neverending_food()
{

  string progress = get_property("_questPartyFairProgress");

  if (progress == "")
  {
    set_property("choiceAdventure1324", "2");
    set_property("choiceAdventure1326", "3");
    yz_adventure($location[The Neverending Party]);
    return true;
  }

  string[int] wanted = split_string(progress, " ");
  item toy = to_item(wanted[1]);

  if (to_int(wanted[0]) > item_amount(toy))
  {
    monster_attract = $monsters[burnout];
    set_property("choiceAdventure1324", "5");
    yz_adventure($location[the neverending party], "items");
    return true;
  }

  set_property("choiceAdventure1324", "2");
  set_property("choiceAdventure1326", "4");
  yz_adventure($location[The Neverending Party]);
  return true;

}

boolean neverending_trash()
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

  yz_adventure($location[the neverending party], "items");

  return true;
}


boolean neverending_booze()
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

  if (to_int(wanted[0]) > item_amount(toy))
  {
    monster_attract = $monsters[jock];
    yz_adventure($location[the neverending party], "items");
    return true;
  }

  set_property("choiceAdventure1324", "3");
  set_property("choiceAdventure1327", "4");
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
      return neverending_booze();
    case "trash":
      return neverending_trash();
    case "dj":
      return neverending_dj();
    case "woots":
      return neverending_woots();
    case "food":
      return neverending_food();
    case "":
      return neverending_free();

  }

  return true;
}

void main()
{
  neverending();
}
