import "util/main.ash";

void do_lighthouse()
{
  if (get_property("sidequestLighthouseCompleted") != "none")
  {
    return;
  }
  if (quest_status("questL12War") < 1)
  {
    warning("Go start the war before starting the Lighthouse sidequest.");
    return;
  }
  if (quest_status("questL12War") > 1)
  {
    warning("The war seems to be over. This sidequest isn't available now.");
    return;
  }

  if (item_amount($item[barrel of gunpowder]) < 5)
  {
    warning("Find a way to get the " + wrap($item[barrel of gunpowder]) + " from the " + wrap($monster[lobsterfrogman]) + " before continuing.");
    return;
  }

  outfit("Frat Warrior Fatigues");
  visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");

  if (get_property("sidequestLighthouseCompleted") == "none")
  {
    warning("The Lighthouse sidequest should be complete, but for some reason it isn't.");
    return;
  }
  log("Collecting rewards...");
  visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");

  log(wrap("Lighthouse", COLOR_LOCATION) + " sidequest complete.");
}

void main()
{
  do_lighthouse();
}
