import "util/main.ash";

boolean larva_loop()
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
      return true;
    case 0:
      set_property("choiceAdventure502", 2);
      set_property("choiceAdventure505", 1);
      maximize("noncombat");
      yz_adventure($location[The spooky forest]);
      return true;
    case 1:
      log("Returning the " + wrap($item[mosquito larva]) + " to the council.");
      council();
      return true;
    default:
      return false;
  }
}

boolean L02_Q_larva()
{
  if (quest_status("questL02Larva") == FINISHED)
    return false;
  if (my_level() < 2)
    return false;

  int turns = my_adventures();

  int counter = 0;
  while (larva_loop() && counter < 25)
  {
    counter += 1;
  }

  if (quest_status("questL02Larva") == FINISHED)
  {
    int total = turns - my_adventures();
    log(wrap($item[mosquito larva]) + " collected and returned to the council. It took " + total + " turns.");
  } else {
    if (counter == 25)
    {
      abort("This quest took too long. Unsure what to do.");
    } else {
      abort(wrap($item[mosquito larva]) + " quest not complete, but I don't know why.");
    }
  }
  return true;
}

void main()
{
  L02_Q_larva();
}
