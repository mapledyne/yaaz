import "util/main.ash";

string BRIDGE_URL="place.php?whichplace=orc_chasm&action=bridge21";

void do_one_bridge_adv()
{
  use_all($item[smut orc keepsake box]);

  if (item_amount($item[abridged dictionary]) + item_amount($item[dictionary]) == 0)
  {
    buy(1, $item[abridged dictionary]);
  }

  if (item_amount($item[abridged dictionary]) == 1)
  {
    cli_execute("untinker abridged dictionary");
  }

  dg_adventure($location[the smut orc logging camp], "items");
}

boolean bridge_loop()
{
  int status = quest_status("questL09Topping");

  switch (status)
  {
    case -1:
      log("Going to the council to pick up the quest.");
      council();
      return true;
    case 0:
      do_one_bridge_adv();
      return true;
    case 1:
      log("Bridge built!.");
      visit_url("place.php?whichplace=highlands&action=highlands_dude");
      return true;
    case 2:
    // quest in progress, but bridge built
      return false;
    default:
      return false;
  }
}

boolean L09_Q_bridge()
{
  if (my_level() < 9)
    return false;

  if (quest_status("questL09Topping") > 1)
    return false;

  int turns = my_adventures();

  int counter = 0;
  while (bridge_loop() && counter < 30)
  {
    counter += 1;
  }

  if (quest_status("questL09Topping") > 1)
  {
    int total = turns - my_adventures();
    log("Bridge built. It took " + total + " adventures.");
  } else {
    if (counter == 30)
    {
      abort("This quest took too long. Aborting.");
    } else {
      abort("Bridge building not complete, but I don't know why.");
    }
  }
  return true;
}

void main()
{
  L09_Q_bridge();
}
