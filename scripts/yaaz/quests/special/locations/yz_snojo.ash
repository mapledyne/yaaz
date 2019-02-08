import "util/base/yz_print.ash";
import "util/base/yz_maximize.ash";
import "util/adventure/yz_adventure.ash";

void snojo_progress()
{

  if (!be_good($item[X-32-F snowman crate])) return;

  if (prop_bool("snojoAvailable")
      && prop_int("_snojoFreeFights") < 10)
  {
    int fights = prop_int("_snojoFreeFights");
    progress(fights, 10, "free " + wrap("snojo", COLOR_LOCATION) + " fights", "blue");
  }

}

void snojo_cleanup()
{

}

boolean snojo_too_risky()
{
  // return true if we think it's worth the risk to fight a snowman.
  // this likely needs a lot more love to be accurate.

  // really, this should take a ton more into account like HP and other attack options.

  int fights = prop_int("_snojoFreeFights");
  int buff = my_buffedstat(my_primestat());

  return (25*fights) > buff;
}

int snojo_fights_remaining()
{
  return 10 - get_property("_snojoFreeFights").to_int();
}

boolean can_snojo()
{
  if (!can_adventure()) return false;

  if (snojo_too_risky()) return false;

  if (!be_good($item[X-32-F snowman crate])) return false;

  if (prop_bool("snojoAvailable") && get_property("snojoSetting") == "NONE")
  {
    log("Turning the " + wrap($location[The X-32-F Combat Training Snowman]) + " on.");
    int lever;
    switch(my_primestat())
    {
      case $stat[muscle]:
        lever = 1;
        break;
      case $stat[mysticality]:
        lever = 2;
        break;
      case $stat[moxie]:
        lever = 3;
        break;
    }
    visit_url("place.php?whichplace=snojo&action=snojo_controller");
    visit_url("choice.php?pwd=&whichchoice=1118&option=" + lever);
  }

  if (prop_bool("snojoAvailable") && get_property("_snojoFreeFights").to_int() < 10)
    return true;

  return false;
}

boolean snojo()
{
  if (!can_snojo())
  {
    return false;
  }
  log("Off to fight a " + wrap($monster[X-32-F Combat Training Snowman]) + " at the " + wrap("Snojo", COLOR_LOCATION) + ".");
  maximize("");
  return yz_adventure_bypass($location[The X-32-F Combat Training Snowman]);
}

void main()
{
  log("Doing default actions with the " + $location[The X-32-F Combat Training Snowman] + ".");
  while(snojo());
}
