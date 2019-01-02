import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";

boolean can_precinct();

void precinct_progress()
{
  if (!can_precinct()) return;

  progress(to_int(get_property("_detectiveCasesCompleted")), 3, "detective cases solved", "blue");

}

boolean can_precinct()
{
  if (!be_good($item[detective school application])) return false;
  return (to_int(get_property("_detectiveCasesCompleted")) < 3 && to_boolean(get_property("hasDetectiveSchool")));
}

void precinct()
{
  if (!can_precinct())
    return;

  if (!svn_exists("Ezandora-Detective-Solver-branches-Release"))
  {
      if (!to_boolean(setting("precinct_svn_warning", "false")))
      {
        save_daily_setting("precinct_svn_warning", "true");
        warning("You have the " + wrap("Detective Precinct", COLOR_LOCATION) + " but I don't know how to automate these cases.");
        warning("If you install Ezandora's " + wrap("Detective Solver", COLOR_ITEM) + " script, I'll call it to automatically do this for you.");
        warning("In the meantime, you'll have to do this yourself, if interested.");
        wait(10);
      }
      return;
  }

  cli_execute("call Detective Solver.ash");
  log("Detective cases hopefully solved.");
}

void main()
{
  precinct();
}
