import "util/main.ash";

// Some common things we'll use here:
item compass = $item[UV-resistant compass];
location oasis = $location[The Oasis];
location desert = $location[The Arid\, Extra-Dry Desert];
effect ultrahydrated = $effect[Ultrahydrated];

boolean can_equip_compass() {
  return (my_path() != "Way of the Surprising Fist" && my_path() != "Avatar of Boris");
}

void desert_progress()
{
  progress(to_int(get_property("desertExploration")), "desert explored");
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
  if (can_equip_compass()) {
    if (i_a(compass) == 0) {
      log("Getting a " + wrap(compass) + ".");
      if (i_a("Shore Inc. Ship Trip Scrip") == 0) {
        log("Going on a shore vacation to get some " + wrap($item[Shore Inc. Ship Trip Scrip]) + ".");
        adventure(1, $location[The Shore\, Inc. Travel Agency]);
      }
      cli_execute("acquire UV-resistant compass");
      if (weapon_hands(equipped_item($slot[weapon])) > 1)
      {
        error("You're wielding a 2-handed weapon so can't use the compass currently. Aborting.");
        abort();
      }
      equip($item[UV-resistant compass]);
    } else { // ! if (i_a(compass) == 0)
      if (weapon_hands(equipped_item($slot[weapon])) > 1)
      {
        error("You're wielding a 2-handed weapon so can't use the compass currently. Aborting.");
        abort();
      }
      equip(compass);
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

int open_oasis()
{
  int max_adv = 10;
  int adv_spent = 0;
  while ( adv_spent < max_adv && !is_oasis_open() )
  {
    dg_adventure(desert);
    adv_spent += 1;
  }
  if (!is_oasis_open())
  {
    log("Could not open " + wrap(oasis) + " for some reason. Try adventuring in " + wrap(desert) + " manually to open it.");
    abort();
  }
  log_adv(adv_spent, "to open " + wrap(oasis) + ".");
  return adv_spent;
}

boolean is_gnasir_open()
{
  if (contains_text(visit_url("place.php?whichplace=desertbeach"), "gnasir.gif"))
    return true;
  return false;
}

int open_gnasir()
{
  int max_adv = 15;
  int adv_spent = 0;

  set_property("choiceAdventure805", 1);

    while ( adv_spent < max_adv && !is_gnasir_open() )
    {
      if (have_effect(ultrahydrated) == 0)
      {
        dg_adventure(oasis);
        adv_spent += 1;
      }
      dg_adventure(desert);
      desert_progress();
      adv_spent += 1;
    }
    if (!is_gnasir_open())
    {
      log("Could not open Gnasir for some reason. Try adventuring in " + wrap(desert) + " (while " + wrap(ultrahydrated) + ") manually to open it.");
      abort();
    }
    log_adv(adv_spent, "to open " + wrap(oasis) + ".");
    return adv_spent;
}

void find_pyramid()
{

  if(my_level() < 11)
  {
    error('Cannot adventure here yet. Get to level 11!');
    return;
  }

  int turns = 0;
  int starting_adv_count = my_adventures();
  get_compass();

  // Oasis
  if (!is_oasis_open())
  {
    log(wrap(oasis) + " hasn't been found yet. Adventuring in " + wrap(desert) + " to open it.");
    turns += open_oasis();
  }

  // Gnasir
  if (!is_gnasir_open())
  {
    log("Gnasir hasn't been found yet. Adventuring in " + wrap(desert) + " to open it.");
    turns += open_gnasir();
  }

  string html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
  html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
  run_choice(1); // visit_url("choice.php?whichchoice=805&option=1&pwd=");

	if (contains_text(html, "can of black paint"))
  {
		log("Gnasir wants a can of black paint.");
		if (i_a("can of black paint") == 0 && my_meat() > 1000) {
			cli_execute("acquire can of black paint");
		}
		if (i_a("can of black paint") > 0) {
      log("Giving " + wrap($item[can of black paint]) + " to Gnasir.");
			html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
		} else {
      string reason = "the Black Market may not be opened yet";
      if (my_meat() < 1000)
        reason = "you don't have enough meat to buy it";
      error("Gnasir wants a " + wrap($item[can of black paint]) + ", but I couldn't get one, " + reason + ". Aborting.");
      abort();
    }
	} // can of black paint


	if (contains_text(html, "killing jar")) {
		log("Gnasir wants a killing jar.");
		if (i_a("killing jar") > 0) {
			log("Giving " + wrap($item[killing jar]) + " to Gnasir.");
			html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
		}
	} // killing jar

	if (contains_text(html, "stone rose")) {
		log("Gnasir wants a stone rose.");
	}
	if (contains_text(html, "worm-riding manual")) {
		log("Gnasir wants a worm-riding manual.");
	}

  while (my_adventures() > 0 && get_property("desertExploration").to_int() < 100)
  {
    if (i_a("desert sightseeing pamphlet") > 0)
    {
      use_all($item[desert sightseeing pamphlet]);
      continue;
    }

    if (i_a("stone rose") > 0) {
      log("Gnasir wants your stone rose.");
      html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      continue;
    }

    if (i_a("worm-riding manual page") > 14) {
      log("Gnasir wants to help you ride the majestic worms.");
      html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      continue;
    }
    else if (i_a("worm-riding hooks") > 0) {
      if (i_a("drum machine") > 0) {
        use(1, $item[drum machine]);
      }
      else {
        log("We have the " + wrap($item[worm-riding hooks]) + " but don't have a " + wrap($item[drum machine]) + ". Looking for one in the " + wrap($location[The Oasis]));
        wait(1);
        int count = 0;
        while (item_amount($item[drum machine]) == 0)
        {
          count = count + 1;
          dg_adventure($location[The Oasis], "combat,  0.5 items");
          desert_progress();
          if (count > 10)
          {
            error ("Took too long finding the " + wrap($item[drum machine]) + ". Aborting so we can find out why.");
            abort();
          }
        }
      }
      continue;
    }

    if (have_effect($effect[Ultrahydrated]) == 0) {
      dg_adventure($location[The Oasis]);
      continue;
    }

    dg_adventure($location[The Arid\, Extra-Dry Desert]);
    desert_progress();
  }
  if (get_property("desertExploration").to_int() < 100)
  {
    error("You ran out of adventures while exploring the desert. Explore some more tomorrow.");
    abort();
  }

  int count = starting_adv_count - my_adventures();
  log("It took you " + count + " adventures, but you've discovered the pyramid in the desert!");
}


void main()
{
  find_pyramid();
}
