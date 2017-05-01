import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";

boolean can_spacegate();

void spacegate_progress()
{

  if (!can_spacegate()) return;

  progress(20 - to_int(get_property("_spacegateTurnsLeft")), 20, wrap("Spacegate", COLOR_LOCATION) + " energy. This is not automated. Do this yourself if interested during the run.");

}

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

//  debug("Todo: Check Space Gate status. Are we out of energy or just haven't dialed a planet today?");
  if (spacegate_turns_remaining() > 0) return true;
  return false;
}

boolean is_spacegate_vaccine(effect vaccine)
{
  return $effects[rainbow vaccine, Broad-Spectrum Vaccine, Emotional Vaccine] contains vaccine;
}

boolean spacegate_vaccine(effect vaccine)
{
  int[effect] vaccines;

  vaccines[$effect[rainbow vaccine]] = 1;
  vaccines[$effect[Broad-Spectrum Vaccine]] = 2;
  vaccines[$effect[Emotional Vaccine]] = 3;

  if (!is_spacegate_vaccine(vaccine))
  {
    warning("Trying to use the " + wrap("Spacegate Facility", COLOR_LOCATION) + " to vaccinate for " + wrap(vaccine) + ", but that's not a vaccine.");
    return false;
  }

  if (to_boolean(get_property("_spacegateVaccine"))) return false;
  return cli_execute('spacegate vaccine ' + vaccines[vaccine]);

  return false;
}

void spacegate()
{

}

void main()
{
  spacegate();
}
