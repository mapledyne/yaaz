import "util/main.ash";

boolean twin_adventure(string max)
{
  max += ", -combat";
  if (!contains_text(max, "items"))
    max += ", items";

  foreach m in $monsters[bearpig topiary animal,
                        elephant (meatcar?) topiary animal,
                        spider (duck?) topiary animal]
  {
    add_attract(m);
  }

  maximize(max);
  if (item_amount($item[rusty hedge trimmers]) > 0)
  {
    use(1, $item[rusty hedge trimmers]);
  } else {
    return dg_adventure($location[twin peak]);
  }
  if ($monsters[bearpig topiary animal,
                elephant (meatcar?) topiary animal,
                spider (duck?) topiary animal] contains to_monster(get_property("olfactedMonster")))
  {
    foreach m in $monsters[bearpig topiary animal,
                          elephant (meatcar?) topiary animal,
                          spider (duck?) topiary animal]
    {
      remove_attract(m);
    }
  }
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

  int status = to_int(get_property("twinPeakProgress"));

  repeat
  {
    boolean b = (twin_adventure("init"));
    if (!b)
      return true;
  } until (status != to_int(get_property("twinPeakProgress")));

  return true;
}

boolean do_twin_jar()
{
  int status = to_int(get_property("twinPeakProgress"));

  repeat
  {
    boolean b = (twin_adventure("items"));
    if (!b)
      return true;
  } until (status != to_int(get_property("twinPeakProgress")));

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

  repeat
  {
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

    boolean b = (twin_adventure("stench res"));
    if (!b)
      return true;
  } until (status != to_int(get_property("twinPeakProgress")));

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

  repeat
  {
    boolean b = (twin_adventure("items"));
    if (!b)
      return true;
  } until (status != to_int(get_property("twinPeakProgress")));

  return true;

}

boolean L09_SQ_twin()
{
	if(to_int(get_property("twinPeakProgress")) >= 15)
	{
		return false;
	}

	if(to_int(get_property("oilPeakProgress")) > 0)
	{
		return false;
	}

  set_property("choiceAdventure618", "2"); // in case we take too long, burn it down.

	if($location[twin peak].turns_spent == 0)
	{
		set_property("choiceAdventure605", "1");
		dg_adventure($location[Twin Peak]);
	}

  int peak = to_int(get_property("twinPeakProgress"));

	boolean need_stench = !bit_flag(peak, 0);
	boolean need_food = !bit_flag(peak, 1);
	boolean need_jar = !bit_flag(peak, 2);
	boolean need_init = !bit_flag(peak, 3) && !need_stench && !need_food && !need_jar;

	int attemptNum = 0;
	boolean attempt = false;
	if(need_init)
	{
    set_property("choiceAdventure606", "4");
    set_property("choiceAdventure610", "1");
    set_property("choiceAdventure1056", "1");

    if (do_twin_init())
      return true;
	}

	if(need_jar && (item_amount($item[Jar of Oil]) == 1))
	{
    set_property("choiceAdventure606", "3");
    set_property("choiceAdventure609", "1");
    set_property("choiceAdventure616", "1");
    if (do_twin_jar())
      return true;
	}

	if(need_food)
	{
    set_property("choiceAdventure606", "2");
    set_property("choiceAdventure608", "1");
    if (do_twin_food())
      return true;
	}

	if(need_stench)
	{
    set_property("choiceAdventure606", "1");
    set_property("choiceAdventure607", "1");

    if (do_twin_stench())
      return true;
	}

  if (my_level() < 12)
  {
    return false;
  }

  log("Doing the " + wrap($location[twin peak]) + " the hard way.");

  int status = to_int(get_property("twinPeakProgress"));
  repeat
  {
    boolean b = dg_adventure($location[twin peak], "");
    if (!b)
      return true;
  } until (status != to_int(get_property("twinPeakProgress")));
  return true;
}


void main()
{
  L09_SQ_twin();
}
