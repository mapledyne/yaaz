import "util/main.ash";
import "cleanup.ash";
import "util/day_begin.ash";

void run_quest(string ash)
{
  cli_execute("call quests/" + ash +".ash");
}

boolean run_level_quest(string quest, string ash)
{
  if (quest_status(quest) == FINISHED)
    return false;

  run_quest(ash);
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
}

void warning_one_step()
{
  warning("One step completed. Rerun this to go on to the next step.");
}


void do_next_thing()
{

  if (quest_status("questL02Larva") == UNSTARTED)
  {
    log("Visiting " + wrap("The Toot Oriole", COLOR_LOCATION) + " to kick things off.");
    visit_url("tutorial.php?action=toot");
  }

  if (!guild_store_open() && is_guild_class())
  {
    cli_execute("call quests/M_guild.ash");
    warning_one_step();
    return;
  }

  if (!hidden_temple_unlocked())
  {
    cli_execute("call quests/M_hidden_temple.ash");
    warning_one_step();
    return;
  }

  switch(my_level())
  {
    default: // anything higher than 13...
    case 13:
      if (run_level_quest("questL13Final", "L13_Q_sorceress"))
        break;
    case 12:
      level_12_advice();
    case 11:
      if (run_level_quest("questL11Black", "L11_Q_black_market"))
        break;
      if (run_level_quest("questL11Desert", "L11_Q_desert"))
        break;
      if (run_level_quest("questL11Manor", "L11_Q_summoning"))
        break;
    case 10:
      // get the star key if still needed:
      if (item_amount($item[steam-powered model rocketship]) > 0) && item_amount($item[richard's star key]) == 0)
      {
        run_quest("M10_star_key");
        break;
      }

    case 9:
      print("9");
    case 8:
      print("8");
    case 7:
      if (run_level_quest("questL07Cyrptic", "L07_Q_cyrpt"))
        break;
    case 6:
      if (run_level_quest("questL06Friar", "L06_Q_friar"))
        break;
    case 5:
      print("5");
    case 4:
      if (run_level_quest("questL04Bat", "L04_Q_bats"))
        break;
    case 3:
      if (quest_status("questL02Larva") == FINISHED)
      {
        if (run_level_quest("questL03Rat", "L03_Q_rats"))
          break;
      }
    case 2:
      if (run_level_quest("questL02Larva", "L02_Q_larva"))
        break;
    case 1:
      break;
  }
  warning_one_step();
}

void main()
{
  day_begin();
  cleanup();
  do_next_thing();
  cleanup();
}
