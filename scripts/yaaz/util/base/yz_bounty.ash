import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";

void update_bounties()
{
  if (to_boolean(setting("checked_bounties", "false"))) return;
  save_daily_setting("checked_bounties", "true");

  log("Updating available bounties.");
  cli_execute("bounty");

}

void check_bounty_locations()
{
  // shouldn't be needed once locations are all in location_open as appropriate.
  // Useful just to check that list.
  foreach b in $bounties[]
  {
    print(b.location + " : " + location_open(b.location));
  }
}

boolean is_bounty_location(location loc)
{
  foreach s in $strings[Easy, Hard, Special]
  {
    string prop = 'current' + s + 'BountyItem';
    bounty b = to_bounty(get_property(prop));
    if (b == $bounty[none])
    {
      prop = '_untaken' + s + 'BountyItem';
      b = to_bounty(get_property(prop));
    }
    if (b.location == loc) return true;
  }
  return false;
}

bounty take_bounty_location(location loc)
{
  foreach s in $strings[Easy, Hard, Special]
  {
    string prop = 'current' + s + 'BountyItem';
    bounty b = to_bounty(get_property(prop));
    if (b.location == loc) return b;

    if (b == $bounty[none])
    {
      prop = '_untaken' + s + 'BountyItem';
      b = to_bounty(get_property(prop));
    }
    if (b.location == loc)
    {
      cli_execute("bounty " + s);
      return b;
    }
  }
  return $bounty[none];
}

boolean is_current_bounty(location loc)
{
  foreach s in $strings[Easy, Hard, Special]
  {
    string prop = 'current' + s + 'BountyItem';
    bounty b = to_bounty(get_property(prop));
    if (b.location == loc) return true;
  }
  return false;
}

boolean is_current_bounty(monster mon)
{
  foreach s in $strings[Easy, Hard, Special]
  {
    string prop = 'current' + s + 'BountyItem';
    bounty b = to_bounty(get_property(prop));
    if (b.monster == mon) return true;
  }
  return false;
}
