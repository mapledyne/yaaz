import "util/base/yz_maximize.ash";

boolean can_gingerbread()
{
  if (!to_boolean(get_property("gingerbreadCityAvailable"))) return false;

  return true;
}

boolean gingerbread()
{
  if (!can_gingerbread()) return false;

  if (!svn_exists("veracity0-gingerbread"))
  {
    error("This Gingerbread script relies on Veracity's Gingerbread City script.");
    error("Install that and try again if you'd like to automate the Gingerbread City.");
    abort();
  }

  if (!can_interact())
  {
    warning("The Gingerbread script is built solely with Aftercore in mind.");
    warning("doing it at other times may not produce optimal results (we optimize solely for sprinkles)");
    warning("If you want to do it manually, hit ESC now, otherwise we'll continue.");
    wait(10);
  }

  maximize("sprinkles");
  visit_url("inv_equip.php?which=2&action=customoutfit&outfitname=Gingerbread City");
  cli_execute("call Gingerbread City.ash");
  return true;
}



void main()
{
  gingerbread();
}
