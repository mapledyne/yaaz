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
      dg_adventure($location[The spooky forest]);
      return true;
    case 1:
      log("Returning the " + wrap($item[mosquito larva]) + " to the council.");
      council();
      return true;
    default:
      return false;
  }
}

void collect_larva()
{

  int turns = my_adventures();

  int counter = 0;
  while (larva_loop() && counter < 15)
  {
    counter += 1;
  }

  if (quest_status("questL02Larva") > 10)
  {
    int total = turns - my_adventures();
    log(wrap($item[mosquito larva]) + " collected and returned to the council. It took " + total + " turns.");
  } else {
    if (counter == 15)
    {
      error("This quest took too long. Aborting.");
    } else {
      error("Mosquito quest not complete, but I don't know why.");
    }
  }

}

void main()
{
  collect_larva();
}
