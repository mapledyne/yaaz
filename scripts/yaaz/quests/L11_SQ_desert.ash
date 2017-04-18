import "util/main.ash";

// Some common things we'll use here:
item compass = $item[UV-resistant compass];
location oasis = $location[The Oasis];
location desert = $location[The Arid\, Extra-Dry Desert];
effect ultrahydrated = $effect[Ultrahydrated];

boolean can_equip_compass() {
  return (my_path() != "Way of the Surprising Fist" && my_path() != "Avatar of Boris");
}

boolean pyramid_found()
{
  if (!contains_text(visit_url("questlog.php?which=1"),"Just Deserts") || contains_text(visit_url("questlog.php?which=1"),"found the little pyramid") || contains_text(visit_url("questlog.php?which=1"),"found the hidden buried pyramid"))
    return true;
  return false;
}

void get_compass()
{
  //Get the UV Compass.
  if (can_equip_compass())
  {
    if (!have(compass))
    {
      log("Getting a " + wrap(compass) + ".");
      if (!have($item[Shore Inc. Ship Trip Scrip]))
      {
        log("Going on a shore vacation to get some " + wrap($item[Shore Inc. Ship Trip Scrip]) + ".");
        adventure(1, $location[The Shore\, Inc. Travel Agency]);
      }
      cli_execute("acquire UV-resistant compass");
    }
  } else { // ! if (can_equip_compass())
    print("Skipping the " + wrap(compass) + " since you can't use it this run.");
  }
}

boolean is_oasis_open()
{
  if (contains_text(visit_url("place.php?whichplace=desertbeach"), to_url(oasis)))
    return true;
  return false;
}

boolean open_oasis()
{
  if (is_oasis_open()) return false;

  log(wrap(oasis) + " hasn't been found yet. Adventuring in " + wrap(desert) + " to open it.");

  if (can_equip_compass())
  {
    maximize("", compass);
  } else {
    maximize("");
  }

  yz_adventure(desert);
  return true;
}

boolean is_gnasir_open()
{
  if (contains_text(visit_url("place.php?whichplace=desertbeach"), "gnasir.gif"))
    return true;
  return false;
}

boolean open_gnasir()
{
  if (is_gnasir_open()) return false;

  log("Gnasir hasn't been found yet. Adventuring in " + wrap(desert) + " to open it.");

  set_property("choiceAdventure805", 1);

  if (can_equip_compass())
  {
    maximize("", compass);
  } else {
    maximize("");
  }

  if (have_effect(ultrahydrated) == 0)
  {
    log("Going to " + wrap($location[The Oasis]) + " to get " + wrap($effect[Ultrahydrated]) + ".");
    yz_adventure(oasis);
  }
  yz_adventure(desert);

  debug("This second visit to Gnasir may be unneeded now. Test and remove if so.");
  string html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
  html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
  run_choice(1); // visit_url("choice.php?whichchoice=805&option=1&pwd=");

  return true;
}

boolean L11_SQ_desert()
{

  if(my_level() < 11)
    return false;

  if (get_property("desertExploration").to_int() >= 100)
    return false;

  int turns = 0;
  int starting_adv_count = my_adventures();
  get_compass();

  // Oasis
  if (open_oasis()) return true;

  // Gnasir
  if (open_gnasir()) return true;

  string html;

  int progress = to_int(get_property("gnasirProgress"));
	if (!bit_flag(progress, 1)
      && my_path() != "Nuclear Autumn")
  {
		if (!have($item[can of black paint]) && my_meat() > 1000)
			cli_execute("acquire can of black paint");

		if (have($item[can of black paint]))
    {
      log("Gnasir wants a can of black paint.");
      log("Giving " + wrap($item[can of black paint]) + " to Gnasir.");
			html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
		} else {
      string reason = "the Black Market may not be opened yet";
      if (my_meat() < 1000) reason = "you don't have enough meat to buy it";
      log("Gnasir wants a " + wrap($item[can of black paint]) + ", but I couldn't get one, " + reason + ". Skipping for now, but this will probably cost more turns.");
    }
	} // can of black paint


	if (!bit_flag(progress, 2)) {
    maybe_pull($item[killing jar]);
		if (have($item[killing jar]))
    {
      log("Gnasir wants a killing jar.");
			log("Giving " + wrap($item[killing jar]) + " to Gnasir.");
			html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
		}
	} // killing jar

  if (have($item[desert sightseeing pamphlet]))
  {
    use_all($item[desert sightseeing pamphlet]);
    return true;
  }

  if (!bit_flag(progress, 0)
      && have($item[stone rose]))
  {
    log("Gnasir wants your stone rose.");
    html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
    html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
    html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
    html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
    return true;
  }

  if (!bit_flag(progress, 3)
      && item_amount($item[worm-riding manual page]) > 14)
  {
    log("Gnasir wants to help you ride the majestic worms.");
    html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
    html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
    html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
    html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
    return true;
  }

  if (have($item[worm-riding hooks]))
  {
    maybe_pull($item[drum machine]);
    if (have($item[drum machine]))
    {
      use(1, $item[drum machine]);
      return true;
    }

    log("We have the " + wrap($item[worm-riding hooks]) + " but don't have a " + wrap($item[drum machine]) + ". Looking for one in the " + wrap($location[The Oasis]));
    yz_adventure($location[The Oasis], "items");
    return true;
  }

  if (have_effect($effect[Ultrahydrated]) == 0)
  {
    log("Going to " + wrap($location[The Oasis]) + " to get " + wrap($effect[Ultrahydrated]) + ".");
    yz_adventure($location[The Oasis]);
  }

  if (can_equip_compass())
  {
    maximize("", compass);
  } else {
    maximize("");
  }

  yz_adventure($location[The Arid\, Extra-Dry Desert]);
  if (get_property("desertExploration").to_int() >= 100)
    log("You've discovered the pyramid in the desert!");
  return true;
}


void main()
{
  while (L11_SQ_desert());
}
