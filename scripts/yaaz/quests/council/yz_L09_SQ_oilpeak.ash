import "util/yz_main.ash";

void L09_SQ_oilpeak_cleanup()
{

  int peak = get_property("twinPeakProgress").to_int();
  if(!bit_flag(peak, 2) && !have($item[jar of oil]))
  {
    if (creatable_amount($item[jar of oil]) > 0)
    create(1, $item[jar of oil]);
  }

  // should do keen stuff with surplus crudes...
}

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

  if (quest_status("questL09Topping") != 2) return false;

  float progress = to_float(get_property("oilPeakProgress"));

  boolean lit = to_boolean(setting("oilpeak_lit", "false"));

  if (progress == 0 && !lit)
  {
    string peaks = visit_url("place.php?whichplace=highlands");
    if (index_of(peaks, 'orcchasm/fire3.gif') < 0)
    {
      log("Going to light the " + wrap($location[oil peak]));
      yz_adventure_bypass($location[oil peak]);
    } else {
      debug("Looks like we've already lit the " + wrap($location[oil peak]) + ". I'll note this so I remember.");
    }
    save_daily_setting("oilpeak_lit", true);
    return true;
  }

  if (progress == 0 && !lit)
  {
    log("Going to light the " + wrap($location[oil peak]));
    yz_adventure($location[oil peak]);
    return true;
  }

  if (progress == 0
      && have_crudes()
      && lit)
  {
    return false;
  }

  if (dangerous($location[oil peak]))
  {
    log("Skipping the " + wrap($location[oil peak]) + " for now because it's dangerous.");
    return false;
  }

  yz_adventure($location[oil peak], "items, ml");
  return true;
}

void main()
{
  while (L09_SQ_oilpeak());
}
