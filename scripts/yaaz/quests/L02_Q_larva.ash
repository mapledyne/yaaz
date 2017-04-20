import "util/main.ash";

void L02_Q_larva_cleanup()
{

}

boolean L02_Q_larva()
{
  int status = quest_status("questL02Larva");

  if (status == FINISHED) return false;
  if (my_level() < 2) return false;

  switch (status)
  {
    case UNSTARTED:
      log("Going to the council to pick up the quest.");
      council();
      break;
    case STARTED:
      set_property("choiceAdventure502", 2);
      set_property("choiceAdventure505", 1);
      yz_adventure($location[The spooky forest], "-combat");
      break;
    case 1:
      log("Returning the " + wrap($item[mosquito larva]) + " to the council.");
      council();
      break;
    default:
      warning("Unexpected status (" + status + ") in the Larva quest.");
      break;
  }

  return true;
}

void main()
{
  while (L02_Q_larva());
}
