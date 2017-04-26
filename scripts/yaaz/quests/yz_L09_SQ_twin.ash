import "util/yz_main.ash";

void L09_SQ_twin_cleanup()
{
  if (!bit_flag(get_property("twinPeakProgress").to_int(), 2))
  {
    make_if_needed($item[jar of oil], "for the " + wrap($location[twin peak]) + ".");
  }
}

boolean twin_adventure(string max)
{
  max += ", -combat";
  if (!contains_text(max, "items"))
    max += ", items";

  maximize(max);
  maybe_pull($item[rusty hedge trimmers]);
  if (have($item[rusty hedge trimmers]))
  {
    use(1, $item[rusty hedge trimmers]);
  }
  return yz_adventure($location[twin peak]);
  return true;
}

boolean do_twin_init()
{
  maximize("init");
  if(initiative_modifier() < 40.0)
  {
    log("You need to have more initiative to succeed at the " + wrap($location[twin peak]) + ". Will try later.");
    return false;
  }

  twin_adventure("init");
  return true;
}

boolean do_twin_jar()
{
  twin_adventure("items");
  return true;
}

boolean do_twin_stench()
{
  maximize("stench res");
  int possibleGain = 0;
  if(item_amount($item[Polysniff Perfume]) > 0)
  {
    possibleGain += 2;
  }
  if(item_amount($item[Pec Oil]) > 0)
  {
    possibleGain += 2;
  }
  if(item_amount($item[Oil of Parrrlay]) > 0)
  {
    possibleGain += 1;
  }

  if((elemental_resistance($element[stench]) + possibleGain) < 4)
  {
    log("We can't find enough stench resistance. Will come back to the " + wrap($location[twin peak]) + " later.");
    return false;
  }

  int status = to_int(get_property("twinPeakProgress"));

  if(elemental_resistance($element[stench]) < 4)
  {
    effect_maintain($effect[Neutered Nostrils]);
  }
  if(elemental_resistance($element[stench]) < 4)
  {
    effect_maintain($effect[Oiled-Up]);
  }
  if(elemental_resistance($element[stench]) < 4)
  {
    effect_maintain($effect[Well-Oiled]);
  }

  twin_adventure("stench res");
  return true;
}

boolean do_twin_food()
{
  maximize("items");
  float food_drop = item_drop_modifier();
  food_drop -= numeric_modifier(my_familiar(), "Item Drop", familiar_weight(my_familiar()), equipped_item($slot[familiar]));

  if((food_drop < 50) && (food_drop >= 20))
  {
    if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
    {
      cli_execute("friars food");
    }
  }

  if(have_effect($effect[Brother Flying Burrito\'s Blessing]) > 0)
  {
    food_drop = food_drop + 30;
  }

  if (food_drop < 50)
  {
    log("Couldn't get enough food bonus for the " + wrap($location[twin peak]) + ". Trying later.");
    return false;
  }
  int status = to_int(get_property("twinPeakProgress"));

  twin_adventure("items");
  return true;
}

boolean L09_SQ_twin()
{
  L09_SQ_twin_cleanup();

	if(to_int(get_property("twinPeakProgress")) >= 15) return false;

  int peak = to_int(get_property("twinPeakProgress"));

	boolean need_stench = !bit_flag(peak, 0);
	boolean need_food = !bit_flag(peak, 1);
	boolean need_jar = !bit_flag(peak, 2);
	boolean need_init = !bit_flag(peak, 3) && !need_stench && !need_food && !need_jar;

  // should we do a calculation to see if there's no good way to get the wedding ring,
  // and just forge ahead without the jar since we'll just burn it down anyway?
  if (need_jar && !have($item[jar of oil])) return false;

  if (dangerous($location[Twin Peak]))
  {
    log("Skipping the " + wrap($location[Twin Peak]) + " for now because it's dangerous.");
    return false;
  }

  set_property("choiceAdventure618", "2"); // in case we take too long, burn it down.

	if($location[twin peak].turns_spent == 0)
	{
		set_property("choiceAdventure605", "1");
		yz_adventure($location[Twin Peak]);
    return true;
	}


	int attemptNum = 0;
	boolean attempt = false;

	if (need_jar && have($item[Jar of Oil]))
	{
    set_property("choiceAdventure606", "3");
    set_property("choiceAdventure609", "1");
    set_property("choiceAdventure616", "1");
    return do_twin_jar();
	}

	if (need_food)
	{
    set_property("choiceAdventure606", "2");
    set_property("choiceAdventure608", "1");
    return do_twin_food();
	}

	if (need_stench)
	{
    set_property("choiceAdventure606", "1");
    set_property("choiceAdventure607", "1");

    return do_twin_stench();
	}

  if (need_init)
	{
    set_property("choiceAdventure606", "4");
    set_property("choiceAdventure610", "1");
    set_property("choiceAdventure1056", "1");

    return do_twin_init();
	}

  // Wait until later, to up our odds of one of the above working,
  // and/or to use for flyers.
  if (my_level() < 12) return false;

  log("Doing the " + wrap($location[twin peak]) + " the hard way.");

  yz_adventure($location[twin peak], "");
  return true;
}


void main()
{
  while (L09_SQ_twin());
}
