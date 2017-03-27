import "util/main.ash";

void larva_task()
{
  int status = quest_status("questL02Larva");

  switch (status)
  {
    case -1:
      if (my_level() < 2)
      {
        error("You can't attempt this quest until you're level 2. Level up!");
        abort();
      }
      log("Going to the council to pick up the quest.");
      council();
      break;
    case 0:
      set_property("choiceAdventure502", 2);
      set_property("choiceAdventure505", 1);
      maximize("-combat");
      yz_adventure($location[The spooky forest]);
      break;
    case 1:
      log("Returning the " + wrap($item[mosquito larva]) + " to the council.");
      council();
      break;
    default:
      warning("Unexpected status (" + status + ") in the Larva quest.");
      break;
  }
}

boolean L02_Q_larva()
{
  if (quest_status("questL02Larva") == FINISHED)
    return false;
  if (my_level() < 2)
    return false;

  larva_task();

  return true;
}

void main()
{
  L02_Q_larva();
}
