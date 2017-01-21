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
  int max_adv = 10;
  int adv_spent = 0;
  while ( adv_spent < max_adv && !is_oasis_open() )
  {
    if (can_equip_compass())
    {
      maximize("", compass);
    } else {
      maximize("");
    }
    boolean b = yz_adventure(desert);
    if (!b) return true;
    adv_spent += 1;
  }
  return true;
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
      if (can_equip_compass())
      {
        maximize("", compass);
      } else {
        maximize("");
      }

      if (have_effect(ultrahydrated) == 0)
      {
        yz_adventure(oasis);
        adv_spent += 1;
      }
      yz_adventure(desert);
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
  if (!is_oasis_open())
  {
    log(wrap(oasis) + " hasn't been found yet. Adventuring in " + wrap(desert) + " to open it.");
    if (open_oasis()) return true;
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

	if (contains_text(html, "can of black paint") && my_path() != "Nuclear Autumn")
  {
		log("Gnasir wants a can of black paint.");
		if (i_a($item[can of black paint]) == 0 && my_meat() > 1000) {
			cli_execute("acquire can of black paint");
		}
		if (i_a($item[can of black paint]) > 0) {
      log("Giving " + wrap($item[can of black paint]) + " to Gnasir.");
			html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
			html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
		} else {
      string reason = "the Black Market may not be opened yet";
      if (my_meat() < 1000)
        reason = "you don't have enough meat to buy it";
      log("Gnasir wants a " + wrap($item[can of black paint]) + ", but I couldn't get one, " + reason + ". Skipping for now, but this will probably cost more turns.");
    }
	} // can of black paint


	if (contains_text(html, "killing jar")) {
		log("Gnasir wants a killing jar.");
		if (i_a($item[killing jar]) > 0) {
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

  while (get_property("desertExploration").to_int() < 100)
  {
    if (i_a($item[desert sightseeing pamphlet]) > 0)
    {
      use_all($item[desert sightseeing pamphlet]);
      continue;
    }

    if (i_a($item[stone rose]) > 0) {
      log("Gnasir wants your stone rose.");
      html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      continue;
    }

    if (i_a($item[worm-riding manual page]) > 14) {
      log("Gnasir wants to help you ride the majestic worms.");
      html = visit_url("place.php?whichplace=desertbeach&action=db_gnasir");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=2&pwd=");
      html = visit_url("choice.php?whichchoice=805&option=1&pwd=");
      continue;
    }
    else if (i_a($item[worm-riding hooks]) > 0) {
      if (i_a($item[drum machine]) > 0) {
        use(1, $item[drum machine]);
      }
      else {
        log("We have the " + wrap($item[worm-riding hooks]) + " but don't have a " + wrap($item[drum machine]) + ". Looking for one in the " + wrap($location[The Oasis]));
        wait(1);
        int count = 0;
        while (!have($item[drum machine]))
        {
          count = count + 1;
          yz_adventure($location[The Oasis], "combat,  0.5 items");
          if (count > 10 && !have($item[drum machine]))
          {
            error ("Took too long finding the " + wrap($item[drum machine]) + ". Aborting so we can find out why.");
            abort();
          }
        }
      }
      continue;
    }

    if (have_effect($effect[Ultrahydrated]) == 0) {
      yz_adventure($location[The Oasis]);
      continue;
    }

    if (can_equip_compass())
    {
    log("COMPASS!");
      maximize("", compass);
    } else {
      maximize("");
    }

wait(5);
    yz_adventure($location[The Arid\, Extra-Dry Desert]);
  }

  int count = starting_adv_count - my_adventures();
  log("You've discovered the pyramid in the desert!");
  return true;
}


void main()
{
  L11_SQ_desert();
}
