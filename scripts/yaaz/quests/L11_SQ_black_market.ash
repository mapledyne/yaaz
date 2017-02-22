import "util/main.ash";


familiar bird = $familiar[reassembled blackbird];
if (my_path() == "Bees Hate You")
  bird = $familiar[reconstituted crow];

boolean do_one_market_adv()
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

  if (item_amount(bird.hatchling) == 0 && have_familiar(bird))
  {
    maximize(max, bird);
  } else {
    maximize(max);
  }
  int bee = item_amount($item[beehive]);
  boolean b = yz_adventure($location[the black forest]);
  if (bee < item_amount($item[beehive]))
    log(wrap($item[beehive]) + " found!");
  return b;
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
      return do_one_market_adv();
    case 2:
      if (item_amount($item[forged identification documents]) == 0)
      {
        if (my_path() == "Way of the Surprising Fist")
        {
          visit_url("shop.php?action=fightbmguy&whichshop=blackmarket");
          run_combat();
        } else {
          buy(1, $item[forged identification documents]);
        }
      } else {
        yz_adventure($location[The Shore\, Inc. Travel Agency]);
      }
      return true;
    default:
      return false;
  }
}

boolean L11_SQ_black_market()
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
    log(wrap($item[your father's macguffin diary]) + " found.");
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
  L11_SQ_black_market();
}
