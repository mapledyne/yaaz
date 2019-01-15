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
  int free = to_int(get_property("_neverendingPartyFreeTurns"));

  if (free < 10)
  {
    progress(free, 10, "free adventures in " + wrap($location[the neverending party]));
  }

  string progress = get_property("_questPartyFairProgress");

  switch(get_property("_questPartyFairQuest"))
  {
    default:
      error("I don't know the neverending quest.");
      abort();
    case "booze":
      if (progress == "")
      {
        task("Find Gerald and see what booze he wants for the party.");
      } else {
        string[int] wanted = split_string(progress, " ");
        item toy = to_item(wanted[1]);
        progress(item_amount(toy), to_int(wanted[0]), wrap(toy) + " for Gerald's party.");
      }
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
  while(have($item[Unremarkable duffel bag]))
  {
    use(1, $item[Unremarkable duffel bag]);
  }
}

void start_party()
{
  error("We can't start the party");
  abort();
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

  if (!in_aftercore() && desire == "aftercore") desire == "free";

  if (desire == "free"
      && to_int(get_property("_neverendingPartyFreeTurns")) >= 10)
  {
    return false;
  }

  if (quest_status("_questPartyFair") == UNSTARTED)
  {
    start_party();
    return true;
  }

  switch(get_property("_questPartyFairQuest"))
  {
    default:
      error("I don't know the neverending quest.");
      abort();
    case "booze":
      return neverending_booze();

  }

  return true;
}

void main()
{
  neverending();
}
