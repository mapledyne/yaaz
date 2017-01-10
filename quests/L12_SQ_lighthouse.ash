import "util/main.ash";
import "util/base/monsters.ash";
import "util/base/war_support.ash";

void return_gunpowder()
{
  outfit(war_outfit());
  log("Turning in the five " + wrap($item[barrel of gunpowder], 5) + " for the lighthouse sidequest...");
  visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");

  if (get_property("sidequestLighthouseCompleted") == "none")
  {
    warning("The Lighthouse sidequest should be complete, but for some reason it isn't.");
    return;
  }
  log("Collecting rewards from the lighthouse sidequest...");
  visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");

  log(wrap("Lighthouse", COLOR_LOCATION) + " sidequest complete.");
}

boolean L12_SQ_lighthouse(string side)
{
  if (get_property("sidequestLighthouseCompleted") != "none")
    return false;

  if (quest_status("questL12War") < 1)
    return false;

  if (quest_status("questL12War") > 1)
    return false;

  if (item_amount($item[barrel of gunpowder]) >= 5)
  {
    return_gunpowder();
    return true;
  }

  if (to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[lobsterfrogman])
  {
    log("We're working on the lighthouse sidequest for the war, but we have the " + wrap($monster[lobsterfrogman]) + " digitized, so going to collect some of the barrels that way. Going off to do other things in the meantime.");
    return false;
  }

  add_digitize($monster[lobsterfrogman]);
  while(to_monster(get_property("_sourceTerminalDigitizeMonster")) != $monster[lobsterfrogman]
        && can_adventure()
        && item_amount($item[barrel of gunpowder]) < 5)
  {
    // we'll bail out if we digitize the lobsterfrogman but otherwise try to get all the barrels
    boolean b = yz_adventure($location[sonofa beach], "combat");
    if (!b)
      return true;
  }
  remove_digitize($monster[lobsterfrogman]);
  return true;
}

boolean L12_SQ_lighthouse()
{
  return L12_SQ_lighthouse(war_side());
}

void main()
{
  L12_SQ_lighthouse();
}
