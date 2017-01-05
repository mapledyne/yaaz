import "util/main.ash";
import "util/progress.ash";

void day_end()
{
  log("Wrapping up for the end of the day.");
  wait(5);

  // if there are any source terminal enhances left
  consume_enhances();
  consume_cards();

  cross_streams();

  if (!to_boolean(get_property("telescopeLookedHigh")))
  {
    log("Looking in the telescope to get " + wrap($effect[starry-eyed]));
    cli_execute("telescope look high");
  }

  if (!to_boolean(get_property("concertVisited"))
      && get_property("sidequestArenaCompleted") == "fratboy")
  {
    log("We haven't visited a concert today, let's do it.");
    cli_execute("concert elvish");
  }

  if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
  {
    log("We haven't used the Friar's blessing today. Heading there.");
    cli_execute("friars familiar");
  }

  prep();

  if (hippy_stone_broken())
  {
    boolean attempt = true;

    repeat
    {
      attempt = try_consume($item[cuppa cruel tea]);
    } until (!attempt || spleen_remaining() < 4);

    repeat
    {
      attempt = try_consume($item[hatorade]);
    } until (!attempt || spleen_remaining() < 5);

  }

  pvp();

  if (get_campground() contains $item[spinning wheel]
      && !to_boolean(get_property("_spinningWheel")))
  {
    log("Spinning some meat from the " + wrap($item[spinning wheel]) + ".");
    visit_url("campground.php?action=spinningwheel");
  }

  log("Dressing for rollover.");
  maximize("rollover");
  if (hippy_stone_broken())
  {
    log("Tweaking nighttime outfit for better PvP.");
    remove_non_rollover();
    pvp_rollover();
  }
  progress_sheet("all");
  manuel_progress();

}

void main()
{
	warning("This script will consume resources as if you're at the end of your day.");
	warning("If you want to adventure more, press ESC now.");
  warning("This script will prep you for rollover, but won't make you overdrink. Do that manually.");
	wait(15);
	day_end();
}
