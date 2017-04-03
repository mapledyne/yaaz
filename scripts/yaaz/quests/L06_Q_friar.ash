import "util/main.ash";

boolean L06_Q_friar();
boolean do_friar_area(location loc, item it);

boolean do_friar_area(location loc, item it)
{
  if (i_a(it) > 0)
  {
    log("We have the " + wrap(it) + ".");
    return false;
  }
  maximize("-combat");
  max_effects("items");
  yz_adventure(loc);
  return true;
}


boolean do_neck()
{
  return do_friar_area($location[the dark neck of the woods], $item[dodecagram]);
}

boolean do_heart()
{
  return do_friar_area($location[the dark heart of the woods], $item[box of birthday candles]);
}

boolean do_elbow()
{
  return do_friar_area($location[the dark elbow of the woods], $item[eldritch butterknife]);
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

boolean L06_Q_friar()
{
  if (my_level() < 6)
    return false;
  if (quest_status("questL06Friar") == FINISHED)
    return false;


  log("Trying to complete the " + wrap("Deep Fat Friars", COLOR_LOCATION) + " quest.");
  wait(3);

  if (quest_status("questL06Friar") < 0)
  {
    log("Friar quest not started. Going to the council.");
    council();
  }

  if (dangerous($location[the dark neck of the woods])) return false;

  log("Going to get the " + wrap($item[dodecagram]) + ".");
  while (do_neck() && can_adventure())
  {
    // actions in do_neck()
  }

  if (dangerous($location[the dark heart of the woods])) return false;

  log("Going to get the " + wrap($item[box of birthday candles]) + ".");
  while (do_heart() && can_adventure())
  {
    // actions in do_heart();
  }

  if (dangerous($location[the dark elbow of the woods])) return false;

  log("Going to get the " + wrap($item[eldritch butterknife]) + ".");
  while (do_elbow() && can_adventure())
  {
    // actions in do_elbow()
  }

  while (do_stones() && can_adventure())
  {
    // actions in do_stones()
  }
  return true;
}

void main()
{
  L06_Q_friar();
}
