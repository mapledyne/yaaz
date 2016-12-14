import "util/base/monsters.ash";
import "util/base/locations.ash";
import "util/base/quests.ash";
import "util/adventure/adventure.ash";

// Note: Crossing streams functions are in maximize.ash since they're only
// used at this point to maximize stats.

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

location protonic_loc()
{
  if (!ghost_hunting())
    return $location[none];

  location ghost_loc = ghost_location();

  return ghost_loc;
}


boolean protonic()
{
  location prot = protonic_loc();
  if (prot != $location[none])
  {
    log("Who ya gonna call? No one. You're going to trap the ghost in " + wrap(prot) + " and keep it for yourself.");
    wait(3);
    set_property("ghostLocation", "");

    maximize("", $item[protonic accelerator pack]);
    manuel_add_location(prot);
    return dg_adventure(prot);
  }
  return false;
}

void main()
{
  protonic();
}
