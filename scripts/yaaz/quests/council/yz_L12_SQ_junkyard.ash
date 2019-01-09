import "util/yz_main.ash";
import "util/base/yz_war_support.ash";

boolean get_junkyard_item()
{
  location loc = to_location(get_property("currentJunkyardLocation"));
  effect_maintain($effect[hot jellied]); // so we can banish the gremlin with Breathe Out
  monster_banish = $monsters[A.M.C. Gremlin];

  return yz_adventure(loc, "");
}

boolean L12_SQ_junkyard(string side)
{
  if (get_property("sidequestJunkyardCompleted") != "none") return false;

  if (!war_junkyard_accessible()) return false;

  log("Trying to complete the " + wrap("Junkyard sidequest", COLOR_LOCATION) + "...");

  item mol = to_item(get_property("currentJunkyardTool"));

  if (mol != $item[none] && have(mol))
  {
    if (junkyard_items() == 4)
    {
      outfit(war_outfit());
    }
    log("Visiting Yossarian at the Junkyard.");
    visit_url("bigisland.php?action=junkman&pwd=");
    return true;
  }

  if (get_property("currentJunkyardLocation") == "")
  {
    if (outfit(war_outfit()))
    {
      log("Visiting Yossarian at the Junkyard.");
      visit_url("bigisland.php?action=junkman&pwd=");
      return true;
    }
    else
    {
      abort("Trying to equip the " + wrap(war_outfit(), COLOR_ITEM) + " but couldn't for some reason. Junkyard quest should be complete - go visit Yossarian yourself.");
    }
  }

  if (get_property("currentJunkyardLocation") == "Yossarian")
  {
    if (junkyard_items() == 4)
      {
        if (outfit(war_outfit()))
        {
          log("Visiting Yossarian at the Junkyard.");
          visit_url("bigisland.php?action=junkman&pwd=");
          return true;
        }
        else
        {
          abort("Trying to equip the " + wrap(war_outfit(), COLOR_ITEM) + " but couldn't for some reason. Junkyard quest should be complete - go visit Yossarian yourself.");
        }
      } else {
        log("Visiting Yossarian.");
        visit_url("bigisland.php?action=junkman&pwd=");
        return true;
      }
  }

  if (get_property("currentJunkyardLocation") == "")
  {
    abort("Unsure what to do with a blank Junkyard Location to continue on the junkyard quest.");
  }

  get_junkyard_item();
  return true;
}

boolean L12_SQ_junkyard()
{
  return L12_SQ_junkyard(war_side());
}

void main()
{
  while (L12_SQ_junkyard());
}
