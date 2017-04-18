import "util/main.ash";
import "util/base/monsters.ash";
import "util/base/war_support.ash";
import "special/items/timespinner.ash";

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
  if (get_property("sidequestLighthouseCompleted") != "none") return false;

  if (quest_status("questL12War") != 1) return false;

  if (get_property("sidequestNunsCompleted") == "none"
      && to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand]
      && setting("war_nuns_trick") == "true")
  {
    log("Skipping the Lighthouse quest for now since the " + wrap($monster[dirty thieving brigand]) + " is digitized and that quest isn't complete yet.");
    return false;
  }


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

  if (time_combat($monster[lobsterfrogman], $location[sonofa beach])) return true;

  yz_adventure($location[sonofa beach], "combat");
  return true;
}

boolean L12_SQ_lighthouse()
{
  return L12_SQ_lighthouse(war_side());
}

void main()
{
  while (L12_SQ_lighthouse());
}
