import "util/yz_main.ash";

boolean upgrade_doctorbag()
{
  item bag = $item[Lil' Doctor&trade; bag];

  if (!have(bag)) return false;
  if (!be_good(bag)) return false;

  int max = to_int(setting("max_doctorbag_upgrades", "1"));
  if (in_aftercore())
  {
    max = to_int(setting("max_doctorbag_upgrades_aftercore", max));
  }
  if (to_int(setting("doctor_upgrades", "0")) >= max) return false;

  string doit = setting("upgrade_doctorbag", "aftercore");
  switch (doit)
  {
    case "false":
      return false;
    case "true":
      return true;
    case "aftercore":
      return (in_aftercore());
  }
  return false;
}

void doctorbag_cleanup()
{

}

void doctorbag_progress()
{
  if (!upgrade_doctorbag()) return;

  item bag = $item[Lil' Doctor&trade; bag];
  item cure = to_item(get_property("doctorBagQuestItem"));
  location loc = to_location(get_property("doctorBagQuestLocation"));
  if (cure == $item[none]) return;

  task("Take the " + wrap(cure) + " to " + wrap(loc) + " to upgrade your " + wrap(bag));
}


boolean doctorbag()
{
  item bag = $item[Lil' Doctor&trade; bag];
  if (!upgrade_doctorbag()) return false;

  set_property("choiceAdventure1340", "1");

  item cure = to_item(get_property("doctorBagQuestItem"));
  location loc = to_location(get_property("doctorBagQuestLocation"));

  if (cure == $item[none]) return false;

  stock_item(cure, 1);

  if (!have(cure)) return false;

  maximize("", bag);
  log("Trying to deliver our " + wrap(bag) + " cure.");
  int lights = prop_int("doctorBagQuestLights");
  yz_adventure(loc);
  if (lights != prop_int("doctorBagQuestLights"))
  {
    log("We added a light to our " + wrap(bag));
    save_daily_setting("doctor_upgrades", to_int(setting("doctor_upgrades", "0")) + 1);
  }
  return true;
}

void main()
{
  while(doctorbag());
}
