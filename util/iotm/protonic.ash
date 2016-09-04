import "util/base/monsters.ash";
import "util/base/locations.ash";
import "util/base/quests.ash";

boolean ghost_hunting()
{
  // need better logic here to decide if we're going to hunt a ghost.
  if (my_hp() < 200)
    return false;
   if (get_property("questPAGhost") == STARTED || get_property("ghostLocation") != "")
    return true;
  return false;
}

location ghost_location()
{
  return to_location(get_property("ghostLocation"));
}

location protonic()
{
  if (!ghost_hunting())
    return $location[none];

  location ghost_loc = ghost_location();

  return ghost_loc;
}

void cross_streams(string player)
{
  if (i_a($item[protonic accelerator pack]) == 0)
    return;

  if (to_boolean(get_property("_streamsCrossed")))
    return;

  log("Crossing streams with " + wrap(player, COLOR_MONSTER) + ".");
  cli_execute("crossstreams " + player);
}

void cross_streams()
{
  string p = get_property("streamCrossDefaultTarget");
  cross_streams(p);
}

void main()
{
  protonic();
}
