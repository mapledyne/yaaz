import "util/yz_main.ash";

void M_lights_out_progress();
void M_lights_out_cleanup();
location next_lights_out_location();
boolean M_lights_out();

void M_lights_out_progress()
{
  int timer = 37 - total_turns_played() % 37;
  if (timer == 37) timer = 0;
  location dark = next_lights_out_location();
  if (timer < 5 && dark != $location[none])
  {
    yz_print("Can advance the Lights Out quest in " + wrap(timer, COLOR_LOCATION) + " turns (" + wrap(dark) + ")", 'black');
  }
}

void M_lights_out_cleanup()
{

}

location next_lights_out_location()
{
  // is there a preference in how to prioritize these two quest lines?

  string one = "nextSpookyravenElizabethRoom";
  string other = "nextSpookyravenStephenRoom";

  if (i_a($item[Elizabeth's Dollie]) + storage_amount($item[Elizabeth's Dollie]) > i_a($item[Stephen's lab coat]) + storage_amount($item[Stephen's lab coat]))
  {
    one = "nextSpookyravenStephenRoom";
    other = "nextSpookyravenElizabethRoom";
  }
  location dark = to_location(get_property(one));

  if (dark == $location[none]
      || !location_open(dark)
      || (dark == $location[the haunted gallery]
          && to_boolean(setting("aggressive_optimize", "false"))))
  {
    dark = to_location(get_property(other));
  }
  if (dark != $location[none] && !location_open(dark))
  {
    return $location[none];
  }

  return dark;
}

boolean M_lights_out()
{
  if (total_turns_played() % 37 != 0) return false;

  location dark = next_lights_out_location();

  if (to_boolean(setting("aggressive_optimize", "false"))
      && (dark == $location[the haunted gallery]
          || dark == $location[the haunted laboratory]))
  {
    info("You've set 'yz_aggressive_optimize' to true, and advancing the Lights Out quest any further would take a turn, so skipping them. If you want to complete the Lights Out quest, either 'set yz_aggressive_optimize=false' or complete it manually.");
    return false;
  }

  if (dark == $location[none])
  {
    info("We're at a point where we could advance the Lights Out quest, but neither of the available rooms are open.");
    return false;
  }

  if (dark == $location[the haunted gallery]
      || dark == $location[the haunted laboratory])
  {
    log("Completing one piece of the Lights Out quest by going to " + wrap(dark));
    maximize("spooky res, hot damage, cold damage, sleaze damage, stench damage");
    yz_adventure_bypass(dark);
    return true;
  }

  log("Advancing the Lights Out quest by going to " + wrap(dark));
  yz_adventure_bypass(dark);
  return true;
}


void main()
{

}
