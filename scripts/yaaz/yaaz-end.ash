import "util/yz_main.ash";
import "util/yaaz-progress.ash";

void day_end()
{
  log("Wrapping up for the end of the day.");
  wait(5);

  // if there are any source terminal enhances left
  consume_enhances();
  consume_cards();

  cross_streams();

  if (!prop_bool("telescopeLookedHigh")
      && get_campground() contains $item[Discount Telescope Warehouse gift certificate])
  {
    log("Looking in the telescope to get " + wrap($effect[starry-eyed]));
    cli_execute("telescope look high");
  }

  if (!prop_bool("concertVisited")
      && get_property("sidequestArenaCompleted") == "fratboy")
  {
    log("We haven't visited a concert today, let's do it.");
    cli_execute("concert elvish");
  }

  vip_shower();

  vip_fortune(to_lower_case(my_primestat()));

  if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
  {
    log("We haven't used the Friar's blessing today. Heading there.");
    cli_execute("friars familiar");
  }

  if (stills_available() > 0)
  {
    log("Using up your daily uses of " + wrap("Nash Crosby's Still", COLOR_LOCATION) + ".");
    while (stills_available() > 0)
    {
      // some nuance to add, here?
      create(1, $item[tonic water]);
      progress(10 - stills_available(), 10, wrap("Nash Crosby's Still", COLOR_LOCATION) + " uses");
    }
  }

  if (get_property("_lyleFavored") == "false")
  {
    log("Off to visit Lyle at the monorail.");
    visit_url("place.php?whichplace=monorail&action=monorail_lyle");
  }

  if (get_property("_daycareSpa") != "true"
      && get_property("daycareOpen") == "true")
  {
    log("Going to the spa for a treatment.");
    cli_execute("daycare " + to_lower_case(to_string(my_primestat())));
  }

  if (!prop_bool("_incredibleSelfEsteemCast")
      && have_skill($skill[incredible Self-Esteem])
      && be_good($skill[incredible self-esteem]))
  {
    log("Going to cast " + wrap($skill[incredible self-esteem]) + " to get some affirmations.");
    use_skill($skill[incredible self-esteem]);
  }
  prep();

  consume_bottle_wishes();

  if (hippy_stone_broken())
  {
    boolean attempt = true;

    repeat
    {
      attempt = try_consume($item[cuppa cruel tea]);
    } until (!attempt || spleen_remaining() < 4);

    repeat
    {
      attempt = try_consume($item[hatorade]);
    } until (!attempt || spleen_remaining() < 5);

  }

  pvp();

  if (get_campground() contains $item[spinning wheel]
      && !prop_bool("_spinningWheel")
      && be_good($item[spinning wheel]))
  {
    log("Spinning some meat from the " + wrap($item[spinning wheel]) + ".");
    visit_url("campground.php?action=spinningwheel");
  }



  kgb_enchant("adventures");

  log("Dressing for rollover.");
  if (hippy_stone_broken())
  {
    log("Starting nighttime outfit for better PvP.");
    pvp_rollover();
  }
  maximize("rollover");

  log("Consuming free rests.");
  while(total_free_rests() - get_property("timesRested").to_int() > 0)
  {
    prep();
    cli_execute("rest");
  }

  if (setting("pvp_protection", "true") == "true")
  {
      log("Checking your inventory to see if we should closet things to protect you from PvP thefts.");
      pvp_protection();
  }
  mall_update();
  progress_sheet(true);
  manuel_progress();

}

void main()
{
  print("Version: " + version);
	log("This script will consume resources as if you're at the end of your day.");
	log("If you want to adventure more, press " + wrap("ESC", COLOR_LOCATION) + " now.");
  log("This script will prep you for rollover, but won't make you overdrink. Do that manually.");
	wait(15);
	day_end();
  log("Yaaz complete. You should be at the end of your day with rollover clothes equipped.");
  log("Do what you'd like, then overdrink when ready.");
}
