import "util/util.ash";
import "util/inventory.ash";
import "util/print.ash";
import "util/progress.ash";

void do_arena()
{
  if (get_property("sidequestArenaCompleted") != "none")
  {
    return;
  }
  if (quest_status("questL12War") < 1)
  {
    warning("Go start the war before starting the Arena sidequest.");
    return;
  }
  if (quest_status("questL12War") > 1)
  {
    warning("The war seems to be over. This sidequest isn't available now.");
    return;
  }

  if (!have_flyers())
  {
    outfit("Frat Warrior Fatigues");
    visit_url("/bigisland.php?place=concert");
  }
  if (get_property("flyeredML").to_int() < 10000)
  {
    warning("You have the flyers. Go and spread them around before coming back here.");
    int flyerML = get_property("flyeredML").to_int() / 100;
    progress(flyerML, "flyers delivered");
    return;
  }
  outfit("Frat Warrior Fatigues");
  visit_url("/bigisland.php?place=concert");

  if (get_property("sidequestArenaCompleted") == "none")
  {
    warning("The Arena sidequest should be complete, but for some reason it isn't.");
    return;
  }

  log(wrap("Arena", COLOR_LOCATION) + " sidequest complete.");
}

void main()
{
  do_arena();
}
