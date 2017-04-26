import "util/yz_main.ash";

void L09_SQ_bridge_cleanup()
{

  if (have($item[abridged dictionary]))
  {
    cli_execute("untinker abridged dictionary");
  }

  if (get_property("chasmBridgeProgress").to_int() < 20)
  {
    maybe_pull($item[smut orc keepsake box]);
  }

  if (get_property("chasmBridgeProgress").to_int() < 30
      && quest_status("questL09Topping") == STARTED)
  {
    use_all($item[smut orc keepsake box]);
    visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));
  }

  // bridge built
  if (quest_status("questL09Topping") > 1)
  {
    sell_all($item[orc wrist]);
  }
}

void do_one_bridge_adv()
{

  visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));

  if(get_property("chasmBridgeProgress").to_int() >= 30)
  {
    log("Bridge built! Going to see the " + wrap("Highland Lord", COLOR_LOCATION) + ".");
    wait(3);
    visit_url("place.php?whichplace=highlands&action=highlands_dude");
    return;
  }

  // clover it, but only if we have spare clovers
  if (item_amount($item[disassembled clover]) > 1)
  {
    yz_clover($location[the smut orc logging camp]);
    return;
  }
  yz_adventure($location[the smut orc logging camp], "items");
}

boolean L09_SQ_bridge()
{

  L09_SQ_bridge_cleanup();

  if (my_level() < 9) return false;

  if (quest_status("questL09Topping") > 1) return false;

  if (!can_adventure())
    return false;

  int status = quest_status("questL09Topping");

  switch (status)
  {
    case UNSTARTED:
      log("Going to the council to pick up the quest.");
      council();
      return true;
    case STARTED:
      do_one_bridge_adv();
      return true;
    case 1:
      log("Bridge built!. Visiting the Highland Lord");
      visit_url("place.php?whichplace=highlands&action=highlands_dude");
      return true;
    case 2:
    // quest in progress, but bridge built
      return false;
    default:
      return false;
  }
  return false;
}

void main()
{
  while (L09_SQ_bridge());
}
