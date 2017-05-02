import "util/base/yz_print.ash";

void update_bounties()
{
  if (to_bounty(get_property("currentEasyBountyItem")) == $bounty[none]
      && to_bounty(get_property("_untakenEasyBountyItem")) == $bounty[none])
  {
    log("Updating available bounties.");
    cli_execute("bounty");
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
