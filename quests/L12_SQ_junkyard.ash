import "util/main.ash";
import "util/base/war_support.ash";

int junkyard_progress()
{
  return i_a($item[molybdenum hammer]) + i_a($item[molybdenum crescent wrench]) + i_a($item[molybdenum pliers]) + i_a($item[molybdenum screwdriver]);
}

void get_junkyard_item()
{
  location loc = to_location(get_property("currentJunkyardLocation"));
  dg_adventure(loc, "");
  progress(junkyard_progress(), 4, "tools recovered");
}

boolean L12_SQ_junkyard(string side)
{
  if (get_property("sidequestJunkyardCompleted") != "none")
    return false;

  log("Trying to complete the " + wrap("Junkyard sidequest", COLOR_LOCATION) + "...");
  while (get_property("sidequestJunkyardCompleted") == "none")
  {
    item mol = to_item(get_property("currentJunkyardTool"));

    if (mol != $item[none] && i_a(mol) > 0)
    {
      if (junkyard_progress() == 4)
      {
        outfit(war_outfit());
      }
      visit_url("bigisland.php?action=junkman&pwd=");
      continue;
    }

    if (get_property("currentJunkyardLocation") == "Yossarian")
    {
      if (junkyard_progress() == 4)
        {
          if (outfit(war_outfit()))
            visit_url("bigisland.php?action=junkman&pwd=");
          else
          {
            abort("Trying to equip the " + wrap(war_outfit(), COLOR_ITEM) + " but couldn't for some reason. Junkyard quest should be complete - go visit Yossarian yourself.");
          }
        } else {
          log("Visiting Yossarian.");
          visit_url("bigisland.php?action=junkman&pwd=");
        }
    }
    else if (get_property("currentJunkyardLocation") == "")
    {
      abort("Unsure what to do with a blank Junkyard Location to continue on the junkyard quest.");
    } else {
      get_junkyard_item();
    }
  }
  log("Junkyard sidequest complete.");
  return true;
}

boolean L12_SQ_junkyard()
{
  return L12_SQ_junkyard(war_side());
}

void main()
{
  L12_SQ_junkyard();
}
