import "util/monsters.ash";

boolean ghost_hunting()
{
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
