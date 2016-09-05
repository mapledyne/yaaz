import "util/base/util.ash";
import "util/base/settings.ash";

boolean can_precinct()
{
  return (to_int(get_property("_detectiveCasesCompleted")) < 3 && to_boolean(get_property("hasDetectiveSchool")));
}

void precinct()
{
  if (!can_precinct())
    return;

    string script = setting("detective_script");
    if (script == "")
    {
      warning("You have detective cases you can complete at the precinct.");
      warning("This isn't automated by this script.");
      warning("Set the variable '" + SETTING_PREFIX + "_detective_script' to a script to run, and we can call it automatically.");
    } else {
      cli_execute("call " + script);
      log("Detective cases hopefully solved.");
    }
}

void main()
{
  precinct();
}
