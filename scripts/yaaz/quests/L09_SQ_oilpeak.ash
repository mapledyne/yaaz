import "util/main.ash";

boolean have_crudes()
{
  if (creatable_amount($item[jar of oil]) > 0) return true;
  if (item_amount($item[jar of oil]) > 0) return true;

  int peak = get_property("twinPeakProgress").to_int();
  if(bit_flag(peak, 2)) return true; // already used the oil.

  return false;
}

boolean L09_SQ_oilpeak()
{
  if (quest_status("questL09Topping") != 2)
    return false;

  int progress = to_int(get_property("oilPeakProgress"));

  if (progress == 0
      && !contains_text($location[oil peak].noncombat_queue, "Unimpressed with Pressure"))
  {
    log("Going to light the " + wrap($location[oil peak]));
    yz_adventure($location[oil peak]);
    return true;
  }

  if (progress == 0
      && have_crudes()
      && contains_text($location[oil peak].noncombat_queue, "Unimpressed with Pressure"))
  {
    return false;
  }


  if (dangerous($location[oil peak]))
  {
    log("Skipping the " + wrap($location[oil peak]) + " for now because it's dangerous.");
    return false;
  }

  boolean b;
  repeat
  {
    b = yz_adventure($location[oil peak], "items, ml");
    progress = to_int(get_property("oilPeakProgress"));
  } until ((progress == 0 && have_crudes()) || !b);

  return true;
}

void main()
{
  L09_SQ_oilpeak();
}
