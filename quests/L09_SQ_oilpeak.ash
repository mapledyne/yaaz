import "util/main.ash";

boolean L09_SQ_oilpeak()
{
  if (quest_status("questL09Topping") != 2)
    return false;

  int progress = to_int(get_property("oilPeakProgress"));
  if (progress == 0)
    return false;

  log("Off to light the " + wrap($location[oil peak]) + ".");

  boolean b;
  repeat
  {
    b = dg_adventure($location[oil peak], "items, ml");
    progress = to_int(get_property("oilPeakProgress"));
  } until (progress == 0 || !b);

  return true;
}

void main()
{
  L09_SQ_oilpeak();
}
