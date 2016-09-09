import "util/main.ash";

boolean L09_SQ_aboo()
{
  if (quest_status("questL09Topping") != 2)
    return false;

  if (to_int(get_property("booPeakProgress")) == 0)
  {
    if ($location[a-boo peak].noncombat_queue.contains_text("Come On Ghosty, Light My Pyre"))
      return false;

    log("Off to light the fire at " + wrap($location[a-boo peak]) + ".");
    dg_adventure($location[a-boo peak]);
    return true;
  }



  if (get_property("warProgress") == "unstarted")
  {
    log("We're waiting a bit to complete A-Boo peak in case it's helpful for the flyers and such.");
    return false;
  }

  if (item_amount($item[disassembled clover]) > 0
      && to_int(get_property("booPeakProgress")) == 100
      && item_amount($item[a-boo clue]) == 0)
  {
    dg_clover($location[a-boo peak]);
  }
  while (to_int(get_property("booPeakProgress")) > 0
         && can_adventure())
  {
    string max = "items";
    if (item_amount($item[a-boo clue]) > 0)
    {
      log("Using one " + wrap($item[a-boo clue]) + " to help with the peak.");
      use(1, $item[a-boo clue]);
      max = "cold res, spooky res";
    }
    boolean b = dg_adventure($location[a-boo peak], max);
    if (!b)
      return true;
  }
  return true;
}

void main()
{
  L09_SQ_aboo();
}
