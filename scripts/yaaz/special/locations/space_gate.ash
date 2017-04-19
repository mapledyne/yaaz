import "util/base/print.ash";


int space_gate_turns_remaining()
{
  return to_int(get_property("_spacegateTurnsLeft"));
}

boolean can_space_gate()
{
  if (space_gate_turns_remaining() > 0) return true;
  return false;
}

boolean is_space_gate_vaccine(effect vaccine)
{
  return $effects[rainbow vaccine, Broad-Spectrum Vaccine, Emotional Vaccine] contains vaccine;
}

boolean space_gate_vaccine(effect vaccine)
{
  int[effect] vaccines;

  vaccines[$effect[rainbow vaccine]] = 1;
  vaccines[$effect[Broad-Spectrum Vaccine]] = 2;
  vaccines[$effect[Emotional Vaccine]] = 3;

  if (!is_space_gate_vaccine(vaccine))
  {
    warning("Trying to use the " + wrap("Spacegate Facility", COLOR_LOCATION) + " to vaccinate for " + wrap(vaccine) + ", but that's not a vaccine.");
    return false;
  }

  if (to_boolean(get_property("_spacegateVaccine"))) return false;
  return cli_execute('spacegate vaccine ' + vaccines[vaccine]);

  return false;
}

void space_gate()
{

}

void main()
{
  space_gate();
}
