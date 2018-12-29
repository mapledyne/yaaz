import "util/base/yz_maximize.ash";

void gingerbread_progress()
{

}

void gingerbread_cleanup()
{

}

boolean can_gingerbread()
{
  if (!to_boolean(get_property("gingerbreadCityAvailable"))) return false;

  string doit = setting("do_gingerbread", "unk");
  switch(doit)
  {
    default:
      warning("I don't understand the setting for yz_do_gingerbread.");
      warning("Valid options are: 'true', 'false', and 'Aftercore'");
      wait(2);
      return false;
    case "unk":
      if (setting("gingerbread_warn") != "true")
      {
        log("Gingerbread City isn't automated but can be.");
        log("Set yz_do_gingerbread to one of: 'true', 'false', 'aftercore'");
        wait(5);
        save_daily_setting("gingerbread_warn", "true");
      }
      return false;
    case "false":
      return false;
    case "true":
      return true;
    case "aftercore":
      return in_aftercore();
  }
}

string gingerbread_goal()
{
  // obviously should do better than this...
  return "candy";
}

boolean gingerbread()
{
  if (!can_gingerbread()) return false;
  if (setting("did_gingerbread") == "true") return false;

  if (!svn_exists("veracity0-gingerbread"))
  {
    if (!to_boolean(setting("gingerbread_warning", "false")))
    {
      save_daily_setting("gingerbread_warning", "true");
      error("This Gingerbread script relies on Veracity's Gingerbread City script.");
      error("Install that and try again if you'd like to automate the Gingerbread City.");
    }
    return false;
  }

  maximize("sprinkles");
  cli_execute("outfit save Gingerbread City");
  cli_execute("call configureVGC.ash " + gingerbread_goal());
  cli_execute("call Gingerbread City.ash");
  save_daily_setting("did_gingerbread", "true");
  return true;
}



void main()
{
  gingerbread();
}
