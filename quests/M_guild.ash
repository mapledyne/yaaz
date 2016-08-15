import "util/main.ash";

void open_guild()
{
  if (guild_store_open())
  {
    log("Guild store already available to you.");
    return;
  }

  if (!is_guild_class())
  {
    warning(wrap(my_class()) + " isn't a guild class.");
    return;
  }

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
      it = $item[old sweatpants];
    break;
    case $class[seal clubber]:
    case $class[turtle tamer]:
      loc = $location[the outskirts of cobb's knob];
      it = $item[11-inch knob sausage];
      break;
  }

  log("Retreiving the " + wrap(it) + " from " + wrap(loc) + ".");
  while(item_amount(it) == 0 || my_primestat() == $stat[moxie])
  {
    if (my_primestat() == $stat[moxie])
    {
      maximize("", $item[old sweatpants]);
    } else {
      maximize();
    }
    dg_adventure(loc);
    if (equipped_item($slot[pants]) == $item[none] && my_primestat() == $stat[moxie])
      break;
  }

  log("Returning the " + wrap(it) + " to your guild leader.");
  visit_url("guild.php?place=challenge");

  if (!guild_store_open())
  {
    warning("Your guild isn't open yet for some reason.");
    return;
  }
  log("Guild is now open.");
}


void main()
{
  open_guild();
}
