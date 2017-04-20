import "util/main.ash";

void M_guild_cleanup()
{

}

boolean M_guild()
{
  if (guild_store_open()) return false;

  if (!is_guild_class()) return false;

  // no guild on this path:
  if (my_path() == "Nuclear Autumn") return false;

  log("Visiting the guild to see what they want us to do.");
  visit_url("guild.php?place=challenge");

  item it;
  location loc;
  switch(my_class())
  {
    default:
      abort("Don't know how to manage the guild path with your class. Sorry.");
    case $class[disco bandit]:
    case $class[accordion thief]:
      loc = $location[the sleazy back alley];
      it = equipped_item($slot[pants]);
      if (it == $item[none])
        return false;
    break;
    case $class[pastamancer]:
    case $class[sauceror]:
      loc = $location[the haunted pantry];
      it = $item[exorcised sandwich];
      break;
    case $class[seal clubber]:
    case $class[turtle tamer]:
      loc = $location[the outskirts of cobb's knob];
      it = $item[11-inch knob sausage];
      break;
  }

  log("Retreiving the " + wrap(it) + " from " + wrap(loc) + ".");
  if (!have(it)
      || my_primestat() == $stat[moxie])
  {
    if (my_primestat() == $stat[moxie])
    {
      maximize("", it);
    } else {
      maximize("");
    }

    yz_adventure(loc);
    if (equipped_item($slot[pants]) == $item[none]
        && my_primestat() == $stat[moxie])
    {
      log("Returning the " + wrap(it) + " to your guild leader.");
      visit_url("guild.php?place=challenge");
    }

    return true;
  }

  log("Returning the " + wrap(it) + " to your guild leader.");
  visit_url("guild.php?place=challenge");

  if (!guild_store_open())
    abort("Your guild isn't open yet for some reason. Unsure how to handle this.");

  log("Guild is now open.");
  return true;
}


void main()
{
  while(M_guild());
}
