import "util/monsters.ash";

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

boolean protonic()
{
  if (!ghost_hunting())
    return false;

  maximize("", $item[protonic accelerator pack]);
  adv1(ghost_location(), -1, "");
  return true;
}

void main()
{

}
