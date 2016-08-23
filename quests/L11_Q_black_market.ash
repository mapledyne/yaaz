import "util/main.ash";

void do_one_market_adv()
{
  if (creatable_amount($item[reassembled blackbird]) > 0)
  {
    log("Making a " + wrap($item[reassembled blackbird]) + " to help with exploration.");
    create(1, $item[reassembled blackbird]);
  }

  set_property("choiceAdventure923", 1);
  if (item_amount($item[beehive]) == 0)
  {
    set_property("choiceAdventure924", 3);
    set_property("choiceAdventure1018", 1);
    set_property("choiceAdventure1019", 1);
  } else {
    set_property("choiceAdventure924", 1);
  }

  string max = "items";
  if (item_amount($item[beehive]) > 0)
  {
    max = "combat, 0.2 items";
  }

  if (item_amount($item[reassembled blackbird]) == 0 && have_familiar($familiar[reassembled blackbird]))
  {
    maximize(max, $familiar[reassembled blackbird]);
  } else {
    maximize(max);
  }
  int bee = item_amount($item[beehive]);
  dg_adventure($location[the black forest]);
  progress(get_property("blackForestProgress").to_int(), 5, "forest progress");
  if (bee < item_amount($item[beehive]))
    log(wrap($item[beehive]) + " found!");
}

boolean market_loop()
{
  int status = quest_status("questL11Black");

  switch (status)
  {
    case -1:
      if (my_level() < 11)
      {
        error("You can't attempt this quest until you're level 11. Level up!");
        abort();
      }
      log("Going to the council to pick up the quest.");
      council();
      return true;
    case 0:
    case 1:
      do_one_market_adv();
      return true;
    case 2:
      if (i_a($item[forged identification documents]) == 0)
      {
        buy(1, $item[forged identification documents]);
      } else {
        dg_adventure($location[The Shore\, Inc. Travel Agency]);
      }
      return true;
    default:
      return false;
  }
}

boolean L11_Q_black_market()
{

  if (quest_status("questL11Black") == FINISHED)
    return false;

  if (my_level() < 11)
    return false;

  int turns = my_adventures();

  int counter = 0;
  while (market_loop() && counter < 30)
  {
    counter += 1;
  }

  if (quest_status("questL11Black") == FINISHED)
  {
    int total = turns - my_adventures();
    log(wrap($item[your father's macguffin diary]) + " found. It took " + total + " turns.");
    return true;
  } else {
    if (counter == 30)
    {
      error("This quest took too long. Aborting.");
    } else {
      error("Black market area not complete, but I don't know why.");
    }
    abort("I got stuck trying to solve the Black Market subquest, sorry.");
  }
  return true;
}

void main()
{
  L11_Q_black_market();
}
