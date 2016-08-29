import "util/print.ash";
import "util/maximize.ash";
import "util/adventure.ash";

boolean can_snojo()
{
  if (!can_adventure())
    return false;

  if (to_boolean(get_property("snojoAvailable")) && get_property("_snojoFreeFights").to_int() < 10)
  {
    return true;
  }

  if (to_boolean(get_property("snojoAvailable")) && get_property("snojoSetting") == "NONE")
  {
    warning(wrap($location[The X-32-F Combat Training Snowman]) + " is available but not set up. Hit a control button!");
    wait(10);
  }
  return false;
}

void snojo()
{

  if (!can_snojo())
  {
    return;
  }
  log("Heading to do some work with " + wrap($location[The X-32-F Combat Training Snowman]) + ".");

  while(can_snojo())
  {
    if (expected_damage($monster[The X-32-F Combat Training Snowman]) > (my_hp()/2))
      break;

    dg_adventure($location[The X-32-F Combat Training Snowman], "");
    float thresh = my_maxhp() * 0.2;
    if (have_effect($effect[beaten up]) > 0 || my_hp() < thresh)
    {
      save_daily_setting("snojo_bailed", "true");
      break;
    }
  }
}

void main()
{
  log("Doing default actions with the " + $location[The X-32-F Combat Training Snowman] + ".");
  snojo();
}
