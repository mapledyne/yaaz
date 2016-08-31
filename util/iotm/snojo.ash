import "util/base/print.ash";
import "util/base/maximize.ash";
import "util/adventure/adventure.ash";

boolean snojo_too_risky()
{
  // return true if we think it's worth the risk to fight a snowman.
  // this likely needs a lot more love to be accurate.

  // really, this should take a ton more into account like HP and other attack options.

  int fights = to_int(get_property("_snojoFreeFights"));
  int buff = my_buffedstat(my_primestat());

  return (25*fights) > buff;
}

int snojo_fights_remaining()
{
  return 10 - get_property("_snojoFreeFights").to_int();
}

boolean can_snojo()
{
  if (!can_adventure())
    return false;

  if (snojo_too_risky())
    return false;

  if (to_boolean(get_property("snojoAvailable")) && get_property("_snojoFreeFights").to_int() < 10)
    return true;

  if (to_boolean(get_property("snojoAvailable")) && get_property("snojoSetting") == "NONE")
  {
    warning(wrap($location[The X-32-F Combat Training Snowman]) + " is available but not set up. Hit a control button!");
    wait(10);
  }
  return false;
}

void snojo()
{
  while(can_snojo())
  {
    log("Off to fight a " + wrap($monster[X-32-F Combat Training Snowman]) + " at the " + wrap("Snojo", COLOR_LOCATION) + ". You have " + snojo_fights_remaining() + " fights remaining.");
    dg_adventure($location[The X-32-F Combat Training Snowman], "");
  }
}

void main()
{
  log("Doing default actions with the " + $location[The X-32-F Combat Training Snowman] + ".");
  snojo();
}
