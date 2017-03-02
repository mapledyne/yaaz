import "util/base/print.ash";
import "util/base/maximize.ash";

// Note: Crossing streams functions are in maximize.ash since they're only
// used at this point to maximize stats.

boolean ghost_hunting()
{
  // need better logic here to decide if we're going to hunt a ghost.
  if (my_hp() < 200)
    return false;
   if (get_property("questPAGhost") == "started" || get_property("ghostLocation") != "")
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
  if (my_adventures() < 3) return false;
  if (my_inebriety() > inebriety_limit()) return false;

  location prot = protonic_loc();
  if (prot != $location[none])
  {
    log("Who ya gonna call? No one. You're going to trap the ghost in " + wrap(prot) + " and keep it for yourself.");
    wait(3);
    set_property("ghostLocation", "");

    cli_execute("checkpoint");
    maximize("", $item[protonic accelerator pack]);
    adv1(prot, -1, "");
    cli_execute("outfit checkpoint");
    return true;
  }
  return false;
}

void main()
{
  protonic();
}
