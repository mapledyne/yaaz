import "util/main.ash";
import "util/base/war_support.ash";

boolean L12_SQ_arena(string side)
{
  if (get_property("sidequestArenaCompleted") != "none") return false;

  if (quest_status("questL12War") != 1) return false;

  if (!war_arena_accessible()) return false;

  if (!have_flyers())
  {
    log("Going to get the " + wrap ("arena flyers", COLOR_ITEM) + " to distribute.");
    outfit(war_outfit());
    visit_url("/bigisland.php?place=concert");
    return true;
  }

  if (get_property("flyeredML").to_int() < 10000)
  {
    info("We're still working on the war, but the " + wrap ("arena flyers", COLOR_ITEM) + " aren't all delivered yet, so going off to do other things.");
    return false;
  }

  outfit(war_outfit());
  visit_url("/bigisland.php?place=concert");

  if (get_property("sidequestArenaCompleted") == "none")
  {
    warning("The Arena sidequest should be complete, but for some reason it isn't.");
    wait(10);
    return true;
  }

  log(wrap("Arena", COLOR_LOCATION) + " sidequest complete.");
  return true;
}

boolean L12_SQ_arena()
{
  return L12_SQ_arena(war_side());
}

void main()
{
  while (L12_SQ_arena());
}
