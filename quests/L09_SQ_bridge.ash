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

  visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));
  progress(to_int(get_property("chasmBridgeProgress")), 30, "bridge progress");
  if(get_property("chasmBridgeProgress").to_int() >= 30)
  {
    log("Bridge built! Going to see the " + wrap("Highland Lord", COLOR_LOCATION) + ".");
    wait(3);
    visit_url("place.php?whichplace=highlands&action=highlands_dude");
    return;
  }

  // clover it, but only if we have spare clovers
  if (item_amount($item[disassembled clover]) > 2)
  {
    dg_clover($location[the smut orc logging camp]);
    return;
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

boolean L09_SQ_bridge()
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
    wait(5);
  } else {
    if (counter == 30)
    {
      abort("Making the Chasm Bridge took too long. Aborting in case something is wrong.");
    } else {
      abort("Bridge building not complete, but I don't know why.");
    }
  }
  return true;
}

void main()
{
  L09_SQ_bridge();
}
