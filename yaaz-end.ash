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

  prep();

  if (hippy_stone_broken())
  {
    boolean attempt = true;
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
	warning("If you want to adventure more, press ESC now. This script can cause you to overdrink!");
	wait(15);
	day_end();
}
