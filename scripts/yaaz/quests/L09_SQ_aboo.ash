import "util/main.ash";

boolean L09_SQ_aboo()
{
  if (quest_status("questL09Topping") != 2)
    return false;

  if (to_int(get_property("booPeakProgress")) <= 0)
  {
    if ($location[a-boo peak].noncombat_queue.contains_text("Come On Ghosty, Light My Pyre"))
      return false;

    log("Off to light the fire at " + wrap($location[a-boo peak]) + ".");
    yz_adventure($location[a-boo peak]);
    return true;
  }

  if (item_amount($item[disassembled clover]) > 0
      && to_int(get_property("booPeakProgress")) == 100
      && item_amount($item[a-boo clue]) == 0)
  {
    if (yz_clover($location[a-boo peak])) return true;
  }

  if (dangerous($location[a-boo peak]))
  {
    log("Skipping the " + wrap($location[a-boo peak]) + " for now because it's dangerous.");
    return false;
  }


  string max = "items, hot damage, cold damage, sleaze damage, stench damage";
  if (have($item[a-boo clue]))
  {
    log("Using one " + wrap($item[a-boo clue]) + " to help with the peak.");
    use(1, $item[a-boo clue]);
    max = "cold res, spooky res";
    set_property("choiceAdventure611", "1");
  }

  yz_adventure($location[a-boo peak], max);
  return true;
}

void main()
{
  while (L09_SQ_aboo());
}
