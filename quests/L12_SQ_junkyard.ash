import "util/main.ash";

int junkyard_progress()
{
  return i_a($item[molybdenum hammer]) + i_a($item[molybdenum crescent wrench]) + i_a($item[molybdenum pliers]) + i_a($item[molybdenum screwdriver]);
}

void get_junkyard_item()
{
  location loc = to_location(get_property("currentJunkyardLocation"));
  maximize("");
  dg_adventure(loc);
  progress(junkyard_progress(), 4, "tools recovered");
}

void do_junkyard()
{
  if (get_property("sidequestJunkyardCompleted") != "none")
  {
    return;
  }

  log("Trying to complete the junkyard...");
  while (get_property("sidequestJunkyardCompleted") == "none")
  {
    item mol = to_item(get_property("currentJunkyardTool"));

    if (mol != $item[none] && i_a(mol) > 0)
    {
      if (junkyard_progress() == 4)
      {
        outfit("frat warrior fatigues");
      }
      visit_url("bigisland.php?action=junkman&pwd=");
      continue;
    }

    if (get_property("currentJunkyardLocation") == "Yossarian")
    {
      if (junkyard_progress() == 4)
        {
          if (outfit("frat warrior fatigues"))
            visit_url("bigisland.php?action=junkman&pwd=");
          else
          {
            error("Trying to equip the Frat Warrior outfit but couldn't for some reason. Junkyard quest should be complete - go visit Yossarian.");
            return;
          }
        } else {
          log("Visiting Yossarian.");
          visit_url("bigisland.php?action=junkman&pwd=");
        }
    }
    else if (get_property("currentJunkyardLocation") == "")
    {
      warning("Unsure what to do with a blank Junkyard Location.");
      return;
    } else {
      get_junkyard_item();
    }
  }
  log("Junkyard sidequest complete.");

}

void main()
{
  do_junkyard();
}
