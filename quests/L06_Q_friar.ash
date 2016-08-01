import "util/main.ash";

void do_friars();
void main();
boolean do_friar_area(location loc, item it);

boolean do_friar_area(location loc, item it)
{
  if (i_a(it) > 0)
  {
    log("We have the " + wrap(it) + ".");
    return false;
  }
  maximize("noncombat");
  effect_maintain($effect[Fat Leon's Phat Loot Lyric]);
  dg_adventure(loc);
  return true;
}

boolean do_neck()
{
  return do_friar_area($location[dark neck of the woods], $item[dodecagram]);
}

boolean do_heart()
{
  return do_friar_area($location[dark heart of the woods], $item[box of birthday candles]);
}

boolean do_elbow()
{
  return do_friar_area($location[dark elbow of the woods], $item[eldritch butterknife]);
}

boolean do_stones()
{
  if (i_a($item[eldritch butterknife]) == 0 || i_a($item[box of birthday candles]) == 0 || i_a($item[dodecagram]) == 0)
  {

  } else {
    log("Performing the ritual for the Friars.");
    visit_url("friars.php?action=ritual&pwd=");
    log("Ritual complete!");
  }
  return false;
}

void do_friars()
{
  if (my_level() < 6)
  {
    error("This quest can't be started until you're level 6.");
    return;
  }

  if (quest_status("questL06Friar") < 0)
  {
    log("Quest not started. Going to the council.");
    council();
  }

  log("Trying to complete the Deep Fat Friars quest.");

  log("Going to get the " + wrap($item[dodecagram]) + ".");
  while (do_neck())
  {
    // actions in do_neck()
  }

  log("Going to get the " + wrap($item[box of birthday candles]) + ".");
  while (do_heart())
  {
    // actions in do_heart();
  }

  log("Going to get the " + wrap($item[eldritch butterknife]) + ".");
  while (do_elbow())
  {
    // actions in do_elbow()
  }

  while (do_stones())
  {
    // actions in do_stones()
  }
}

void main()
{
  do_friars();
}
