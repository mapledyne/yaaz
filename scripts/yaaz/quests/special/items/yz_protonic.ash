import "util/adventure/yz_adventure.ash";
import "util/base/yz_print.ash";
import "util/base/yz_maximize.ash";

// Note: Crossing streams functions are in maximize.ash since they're only
// used at this point to maximize stats.


void protonic_progress()
{
  if (!have($item[protonic accelerator pack])) return;
  location ghostly = to_location(get_property("ghostLocation"));
  if (ghostly == $location[none]) return;

  task("defeat ghost (" + wrap(ghostly)+ ")");
}

void protonic_cleanup()
{

}

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
  string max_target = "";
  if (prot != $location[none])
  {
    log("Who ya gonna call? No one. You're going to trap the ghost in " + wrap(prot) + " and keep it for yourself.");
    wait(3);

    // If the ghost is in the peak, we need resistance
    if (prot == $location[The Icy Peak])
    {
      max_target = "cold res, 5 min, 5 max";
    }

    set_property("ghostLocation", "");

    cli_execute("checkpoint");
    maximize(max_target, $item[protonic accelerator pack]);
    yz_adventure(prot);
    cli_execute("outfit checkpoint");
    return true;
  }
  return false;
}

void main()
{
  while(protonic());
}
