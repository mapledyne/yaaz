import "util/print.ash";
import "util/maximize.ash";
import "util/adventure.ash";

string bailedsetting = "snojo_bailed";
string snojoday = "snojo_check";

boolean can_snojo()
{
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
  if (to_int(setting(snojoday, 0)) != my_daycount())
  {
    save_setting(snojoday, my_daycount());
    save_setting(bailedsetting, "");
  }

  if (!can_snojo())
  {
    return;
  }
  log("Heading to do some work with " + wrap($location[The X-32-F Combat Training Snowman]) + ".");

  while(can_snojo())
  {
      dg_adventure($location[The X-32-F Combat Training Snowman], "");
      if (have_effect($effect[beaten up]) > 0)
      {
        save_setting(bailedsetting, "true");
        break;
      }
      float thresh = my_maxhp() * 0.2;
      if (my_hp() < thresh)
      {
        save_setting(bailedsetting, "true");
        break;
      }
  }
}

void main()
{
  log("Doing default actions with the " + $location[The X-32-F Combat Training Snowman] + ".");
  snojo();
}
