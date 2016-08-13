import "util/print.ash";
import "util/maximize.ash";
import "util/adventure.ash";

string bailedsetting = "snojo_bailed";

boolean can_snojo()
{
  if (!can_adventure())
    return false;

  if (setting(bailedsetting) == "true")
  {
    return false;
  }

  if (to_boolean(get_property("snojoAvailable")) && get_property("_snojoFreeFights").to_int() < 10)
  {
    return true;
  }


  if (to_boolean(get_property("snojoAvailable")) && get_property("snojoSetting") == "NONE")
  {
    warning(wrap($location[The X-32-F Combat Training Snowman]) + " is available but not set up. Hit a control button!");
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
      dg_adventure($location[The X-32-F Combat Training Snowman], "");
      float thresh = my_maxhp() * 0.2;
      if (have_effect($effect[beaten up]) > 0 || my_hp() < thresh)
      {
        save_daily_setting(bailedsetting, "true");
        break;
      }
  }
}

void main()
{
  log("Doing default actions with the " + $location[The X-32-F Combat Training Snowman] + ".");
  snojo();
}
