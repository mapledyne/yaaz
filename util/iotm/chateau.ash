import "util/print.ash";

boolean can_chateau()
{
  return to_boolean(get_property("chateauAvailable"));
}

void chateau()
{

  if (!can_chateau())
  {
    return;
  }

  if (!to_boolean(get_property("_chateauDeskHarvested")))
  {
    log("Collecting items from the " + wrap("Chateau Mantegna", COLOR_LOCATION) + " desk.");
    visit_url("place.php?whichplace=chateau&action=chateau_desk2");
  }

}

void main()
{
  log("Doing default actions with the " + wrap("Chateau Mantegna", COLOR_LOCATION) + ".");
  chateau();
}
