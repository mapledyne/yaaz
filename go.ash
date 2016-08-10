import "util/main.ash";
import "cleanup.ash";

boolean run_level_quest(string quest, string ash)
{
  if (quest_status(quest) == FINISHED)
    return false;

  cli_execute("call quests/" + ash +".ash");
  return true;
}

void level_12_advice()
{
  switch(get_property("questL12War"))
  {
    case "unstarted":
      advice("War quest not started. Visit the council.");
      break;
    case "started":
      advice("Go start the Mysterious Island War.");
      break;
    case "step1":
      advice("War started.");
      int frat = get_property("fratboysDefeated").to_int();
      int hippy = get_property("hippiesDefeated").to_int();
      if (frat + hippy == 0)
      {
        advice("No one killed on the battlefield yet.");
        break;
      }
      string msg = "fratboys defeated";
      int total = frat;
      if (frat < hippy)
      {
        total = hippy;
        msg = "hippies defeated";
      }
      progress(total, 100, msg);
      break;
    case "finished":
      break;
    default:
      error("I don't know what our status is with the War quest. Status: " + get_property("questL12War"));
      break;

  }
}

void level_13_advice()
{
  if (get_property("questL13Final") != "finished")
  {
    advice("Naughty Sorceress quest progress:");
    progress(quest_status("questL13Final") + 1, 12);
  }

  switch(get_property("questL13Final"))
  {
    case "unstarted":
      advice("Up next: Go see the council to start the Naughty Sorceress quest.");
      break;
    case "started":
      advice("Up next: Go check out the contest booth to see what entries are available.");
      break;
    case "step1":
      advice("Up next: Attend the coronation ceremony.");
      break;
    case "step2":
      advice("Up next: Go through the hedge maze.");
      break;
    case "step3":
      advice("Up next: Open the tower door.");
      break;
    case "step4":
      advice("Up next: Defeat the " + wrap($monster[wall of skin]) + ".");
      break;
    case "step5":
      advice("Up next: Defeat the " + wrap($monster[wall of meat]) + ".");
      break;
    case "step6":
      advice("Up next: Defeat the " + wrap($monster[wall of bones]) + ".");
      if (item_amount($item[electric boning knife]) == 0)
      {
        advice("Get the " + wrap($item[electric boning knife]) + " from " + wrap($location[the castle in the clouds in the sky (ground floor)]) +  ".");
      }
      break;
    case "step7":
      advice("Up next: Gaze into the mirror (or don't).");
      break;
    case "step8":
      advice("Up next: Defeat your shadow.");
      break;
    case "step11":
      advice("Up next: Defeat " + $monster[naughty sorceress] + ".");
      break;
    case "step12":
      advice("Up next: Break the prism.");
      break;
    case "finished":
      aftercore_advice();
      break;
    default:
      error("I don't know what our status is with the Sorceress quest. Status: " + get_property("questL13Final"));
      break;
  }
}

void do_next_thing()
{
  if (!guild_store_open() && is_guild_class())
  {
    cli_execute("call quests/M_guild.ash");
  }

  switch(my_level())
  {
    default: // anything higher than 13...
    case 13:
      level_13_advice();
    case 12:
      level_12_advice();
    case 11:
      print("11");
    case 10:
      print("10");
    case 9:
      print("9");
    case 8:
      print("8");
    case 7:
      if (run_level_quest("questL07Cyrptic", "L07_Q_cyrpt"))
        break;
    case 6:
      if (run_level_quest("questL06Friar", "L07_Q_friar"))
        break;
    case 5:
      print("5");
    case 4:
      print("4");
    case 3:
      if (run_level_quest("questL03Rat", "L03_Q_rats"))
        break;
    case 2:
      if (run_level_quest("questL02Larva", "L02_Q_larva"))
        break;
    case 1:
      break;
  }
  warning("One step completed. Rerun this to go on to the next step.");
}

void main()
{
  cleanup();
  do_next_thing();
  cleanup();
}
