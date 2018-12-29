import "util/yz_main.ash";


int spacegate_turns_remaining()
{
  return to_int(get_property("_spacegateTurnsLeft"));
}

boolean can_spacegate()
{
  string check = setting("spacegate_check", "unk");

  if (check == "unk")
  {
    if (!visit_url("place.php?whichplace=spacegate").contains_text("Secret Underground Spacegate Facility"))
    {
      check = "false";
    } else {
      check = "true";
    }
    save_daily_setting("spacegate_check", check);
  }

  boolean has_gate = to_boolean(check);

  if (!has_gate) return false;

  return true;
}

void spacegate_cleanup()
{

}

void spacegate_progress()
{

  if (!can_spacegate()) return;
  int left = to_int(get_property("_spacegateTurnsLeft"));
  if (left == 0) return;
  progress(20 - left, 20, wrap("Spacegate", COLOR_LOCATION) + " energy used.");

}

string spacegate_goal()
{
  if (!have_skill($skill[Object Quasi-Permanence])
      && !have($item[Peek-a-Boo!])) return "space baby";

  if (!have_skill($skill[5-D Earning Potential])
      && !have($item[Non-Euclidean Finance])) return "procrastinator";

  if (!have_skill($skill[Quantum Movement])
      && !have($item[Space Pirate Astrogation Handbook])) return "space pirate";

  error("Nothing decided yet here in spacegate_goal().");
  wait(10);
  return "rocks";
}

boolean spacegate()
{
  if (!can_spacegate()) return false;

  string doit = setting("do_spacegate", "unk");
  boolean did_spacegate = to_boolean(setting("did_spacegate", "false"));
  if (did_spacegate) return false;

  switch (doit)
  {
    default:
      warning("I don't understand this setting for 'yz_do_spacegate': " + doit);
      warning("Please set it to 'true', 'false', or 'aftercore'");
    case 'unk':
      log("Set 'yz_do_spacegate' to 'true' or 'aftercore' if you'd like this to be automated.");
      return false;
    case 'false':
      return false;
    case 'true':
      break;
    case 'aftercore':
      if (!in_aftercore()) return false;
      break;
  }

  if (!svn_exists("veracity0-spacegate")
      && setting("spacegate_warning") != "true")
  {
    warning("You have a spacegate, but don't have Veracity's spacegate script.");
    warning("To automate the spacegate, please install this:");
    log("svn checkout https://svn.code.sf.net/p/veracity0/code/spacegate");
    wait(10);
    save_daily_setting("spagegate_warn", "true");
  }

  string goal = spacegate_goal();
  log("About to head to the spacegate to attept to get: " + wrap(goal, COLOR_ITEM));
  save_daily_setting("did_spacegate", "true");
  cli_execute("call VeracitySpacegate.ash visit " + goal);
  return true;

}

void main()
{
  spacegate();
}
