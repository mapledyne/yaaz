import "util/main.ash";

void do_one_market_adv()
{
  if (creatable_amount($item[reassembled blackbird]) > 0)
  {
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

  if (item_amount($item[reassembled blackbird]) == 0 && have_familiar($familiar[reassembled blackbird]))
  {
    maximize("items", $familiar[reassembled blackbird]);
  } else {
    maximize("items");
  }

  dg_adventure($location[the black forest]);
  progress(get_property("blackForestProgress"), 5, "")
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
      if (i_a($item[forged identification documents] == 0)
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

void find_market()
{

  int turns = my_adventures();

  int counter = 0;
  while (market_loop() && counter < 30)
  {
    counter += 1;
  }

  if (quest_status("questL11MacGuffin") > 1)
  {
    int total = turns - my_adventures();
    log(wrap($item[your father's macguffin diary]) + " found. It took " + total + " turns.");
  } else {
    if (counter == 30)
    {
      error("This quest took too long. Aborting.");
    } else {
      error("Black market area not complete, but I don't know why.");
    }
  }

}

void main()
{
  find_market();
}
