import "util/yz_main.ash";
import "special/items/yz_deck.ash";

void L13_Q_sorceress_progress()
{

  if (quest_status("questL06Friar") > UNSTARTED
      && !have($item[wand of nagamar])
      && my_path() != "License to Adventure"
  )
  {
    int wand = 0;
    string wand_parts = "";
    if (have($item[ruby W]) || have($item[WA]))
    {
      wand_parts = "W";
      wand++;
    }
    if (have($item[metallic a]) || have($item[WA]))
    {
      if (length(wand_parts) > 0) wand_parts += ", ";
      wand_parts += "A";
      wand++;
    }
    if (have($item[lowercase n]) || have($item[nd]))
    {
      if (length(wand_parts) > 0) wand_parts += ", ";
      wand_parts += "N";
      wand++;
    }
    if (have($item[heavy d]) || have($item[nd]))
    {
    if (length(wand_parts) > 0) wand_parts += ", ";
    wand_parts += "D";
      wand++;
    }

    if (length(wand_parts) > 0) wand_parts = " (" + wand_parts + ")";

    progress(wand, 4, "make a " + wrap($item[wand of nagamar]) + wand_parts);

  }

  if (quest_status("questL13Final") < 5
      && hero_keys() < 3)
  {
    int keys = hero_keys();
    string pete = UNCHECKED;
    string boris = UNCHECKED;
    string jarl = UNCHECKED;

    if (have($item[boris's key])) boris = CHECKED;
    if (have($item[jarlsberg's key])) jarl = CHECKED;
    if (have($item[sneaky pete's key])) pete = CHECKED;

    progress(keys, 3, "hero keys (" + boris + "Boris, " + pete + "Pete, " + jarl + "Jarlsberg)");
  }

  if (quest_status("questL13Final") < 5
      && quest_status("questL07Cyrptic") > UNSTARTED
      && !have($item[skeleton key]))
  {
    task("make skeleton key");
  }



  if (!quest_active("questL13Final")) return;

  int contest = to_int(get_property("nsContestants1"));
  if (contest > 0)
    progress(10 - contest, 10, "contestants (init)");

  contest = to_int(get_property("nsContestants2"));
  if (contest > 0)
    progress(10 - contest, 10, "contestants (" + get_property("nsChallenge1") + ")");

  contest = to_int(get_property("nsContestants3"));
  if (contest > 0)
    progress(10 - contest, 10, "contestants (" + get_property("nsChallenge2") + ")");

    // TODO: Find a way to track wall of meat progress...
}

void L13_Q_sorceress_cleanup()
{

}

boolean nagamar()
{
  if (quest_status("questL10Garbage") != FINISHED) return false;
  if (have($item[wand of nagamar])) return false;
  if (!have($item[disassembled clover])) return false;
  if (!can_adventure()) return false;
  if (my_path() == "Nuclear Autumn") return false;
  if (my_path() == "License to Adventure") return false;

  log("Going to get the pieces of the " + wrap($item[wand of nagamar]) + ".");
  boolean clove = yz_clover($location[The Castle in the Clouds in the Sky (Basement)]);
  if (clove)
  {
    log("Making a " + wrap($item[wand of nagamar]) + ".");
    create(1, $item[wand of nagamar]);
    return true;
  }
  return true;
}

boolean wall_of_skin()
{
  if (!have($item[beehive]))
  {
    abort("You're at the wall of skin without a beehive. Sad. I can't help you. Defeat it manually and rerun this script.");
  }

  yz_adventure($location[tower level 1], "");
  if (quest_status("questL13Final") == 6)
  {
    warning("Something happened. We should be past the Wall of Skin, but aren't for some reason.");
    return false;
  }
  log(wrap($monster[wall of skin]) + " defeated.");
  cli_execute("refresh inv");
  return true;
}

boolean wall_of_bones()
{
  set_property("choiceAdventure1026",2);

  if (!have($item[electric boning knife]))
  {
    log("Going to get an " + wrap($item[electric boning knife]) + " before fighting the " + wrap($monster[wall of bones]) + ".");
    location ground = $location[the castle in the clouds in the sky (ground floor)];
    yz_adventure(ground, "-combat");
    return true;
  }

  yz_adventure($location[tower level 3], "");
  if (quest_status("questL13Final") == 8)
  {
    warning("Something happened. We should be past the " + wrap($monster[wall of bones]) + ", but aren't for some reason.");
    wait(10);
    return true;
  }
  log(wrap($monster[wall of bones]) + " defeated.");
  return true;
}

boolean wall_of_meat()
{
  yz_adventure($location[tower level 2], "meat");

  if (quest_status("questL13Final") != 7)
    log(wrap($monster[wall of meat]) + " defeated.");

  return true;
}

boolean look_in_sorceress_mirror()
{
  debug("Todo: Find a good mechanic for deciding if we should look in the mirror");
  return !to_boolean(setting("aggressive_optimize", "false"));
}

boolean mirror()
{
  if (look_in_sorceress_mirror())
  {
    log("Looking in the Sorceress's mirror.");
    set_property("choiceAdventure1015", 1);
  } else {
    log("Avoiding the Sorceress's mirror.");
    set_property("choiceAdventure1015", 2);
  }

  yz_adventure($location[tower level 4]);

  if (quest_status("questL13Final") == 9)
  {
    warning("Something went wrong. We're should have moved past the mirror, but aren't.");
    wait(10);
    return true;
  }

  log("Mirror level passed.");
  return true;
}

boolean shadow()
{
  int healing_items = item_amount($item[gauze garter]) + item_amount($item[filthy poultice]);
  if (!(
    (have_skill($skill[ambidextrous funkslinging]) && healing_items >= 5) ||
    (healing_items >= 8)
  ))
  {
    warning("I don't know how to check if we can pass the shadow. I'm expecting a bunch of healing items I can't find.");
    // If we've gotten to this point, there's nothing else that's going to fix this situation, so lets abort
    abort();
  }
  yz_adventure($location[tower level 5], "");

  if (quest_status("questL13Final") == 10)
  {
    warning("Something happened. We should be past " + wrap($monster[your shadow]) + ", but aren't for some reason.");
    wait(10);
    return true;
  }
  log(wrap($monster[your shadow]) + " defeated.");
  return true;
}

boolean sorceress()
{
  maximize("");
  yz_adventure($location[the naughty sorceress' chamber]);

  if (quest_status("questL13Final") == 11)
  {
    // last stage of fight can be "won" by going anywhere, if you have the wand.
    string v = visit_url("campground.php");
  }
  log(wrap($monster[naughty sorceress]) + " defeated.");
  return true;

}

location get_challenge_loc(string challenge)
{
  switch(challenge)
  {
    case "Mysticality":
      return $location[smartest adventurer contest];
    case "Muscle":
      return $location[strongest adventurer contest];
    case "Moxie":
      return $location[smoothest adventurer contest];
    case "spooky":
      return $location[spookiest adventurer contest];
    case "cold":
      return $location[coldest adventurer contest];
    case "hot":
      return $location[hottest adventurer contest];
    case "sleaze":
      return $location[sleaziest adventurer contest];
    case "stench":
      return $location[stinkiest adventurer contest];
    default:
      error("Unsure what challenge this is: " + challenge + ".");
      abort();
  }
  return $location[none];
}

void max_contest(string max, int num)
{
  int baddies = to_int(get_property("nsContestants" + num));
  if (baddies >= 0)
    return;

  log("Heading to the Naughty Sorceress's contest. Next up, " + max + "!");
  switch (to_lower_case(max))
  {
    default:
      abort("NS Contest not automated: " + max);
    case "init":
      maximize("init");
      cheat_deck("race", "go faster, pussycat, faster");
      effect_maintain($effect[hiding in plain sight]);
      break;
    case "muscle":
      maximize("muscle");
      cheat_deck("strength", "get more muscle. Strongity strong");
      effect_maintain($effect[Phorcefullness]);
      effect_maintain($effect[hot jellied]);
      effect_maintain($effect[spooky jellied]);
      // consider oil of stability
      break;
    case "moxie":
      maximize("moxie");
      cheat_deck("fool", "get more moxie. Foolish agility");
      effect_maintain($effect[superhuman sarcasm]);
      effect_maintain($effect[spooky jellied]);
      effect_maintain($effect[sleazy jellied]);
      // consider oil of stability
      break;
    case "mysticality":
      maximize("mysticality");
      cheat_deck("magician", "get more mystically. Boosty boosty");
      effect_maintain($effect[perspicacious pressure]);
      effect_maintain($effect[cold jellied]);
      effect_maintain($effect[spooky jellied]);
      effect_maintain($effect[stench jellied]);
      // consider oil of stability
      break;
    case "cold":
      maximize("cold damage, cold spell damage");
      effect_maintain($effect[cold jellied]);
      break;
    case "sleaze":
      maximize("sleaze damage, sleaze spell damage");
      effect_maintain($effect[sleazy jellied]);
      break;
    case "hot":
      maximize("hot damage, hot spell damage");
      effect_maintain($effect[hot jellied]);
      break;
    case "stench":
      maximize("stench damage, stench spell damage");
      effect_maintain($effect[stench jellied]);
      break;
    case "spooky":
      maximize("spooky damage, spooky spell damage");
      effect_maintain($effect[spooky jellied]);
      break;
  }
  log("All dressed up and somewhere to go, the " + wrap("Registration Desk", COLOR_LOCATION) + ".");
  visit_url("place.php?whichplace=nstower&action=ns_01_contestbooth");
  visit_url("choice.php?pwd=&whichchoice=1003&option=" + num, true);
  visit_url("main.php");
  baddies = to_int(get_property("nsContestants" + num));
  if (baddies > 0)
    log("There are " + wrap(baddies, COLOR_MONSTER) + " contestants ahead of you.");
}

boolean contest_race()
{
  if (get_property("nsChallenge1") == "none" || get_property("nsChallenge2") == "none")
  {
    visit_url("place.php?whichplace=nstower&action=ns_01_contestbooth");
    return true;
  }


  if (get_property("nsContestants1").to_int() < 0 || get_property("nsContestants2").to_int() < 0 || get_property("nsContestants3").to_int() < 0)
  {
    max_contest("init", 1);
    max_contest(get_property("nsChallenge1"), 2);
    max_contest(get_property("nsChallenge2"), 3);
    return true;
  }

  if (get_property("nsContestants1").to_int() > 0)
  {
    maximize();
    yz_adventure($location[fastest adventurer contest]);
    return true;
  }

  if (get_property("nsContestants2").to_int() > 0)
  {
    location loc = get_challenge_loc(get_property("nsChallenge1"));

    maximize();
    yz_adventure(loc);
    return true;
  }

  if (get_property("nsContestants3").to_int() > 0)
  {
    location loc = get_challenge_loc(get_property("nsChallenge2"));

    maximize();
    yz_adventure(loc);
    return true;
  }
  return false;
}

boolean hedge_maze_hard_way()
{
  set_property("choiceAdventure1004", 1);
  set_property("choiceAdventure1005", 1);
  set_property("choiceAdventure1006", 1);
  set_property("choiceAdventure1007", 1);
  set_property("choiceAdventure1008", 1);
  set_property("choiceAdventure1009", 1);
  set_property("choiceAdventure1010", 1);
  set_property("choiceAdventure1011", 1);
  set_property("choiceAdventure1012", 1);

  restore_hp(my_maxhp() * 0.95);

  yz_adventure_bypass($location[the hedge maze]);

  return true;
}

boolean hedge_maze()
{
  boolean hard_way = false;

  maximize("all res");
  foreach el in $elements[hot, cold, sleaze, spooky, stench]
  {
    if (elemental_resistance(el) < 65) hard_way = true;
  }
  if (hard_way)
  {
    return hedge_maze_hard_way();
  }

  set_property("choiceAdventure1004", 1);
  set_property("choiceAdventure1005", 2);
  set_property("choiceAdventure1008", 2);
  set_property("choiceAdventure1011", 2);

  restore_hp(my_maxhp() * 0.95);

  yz_adventure_bypass($location[the hedge maze]);

  return true;
}

boolean door_keys()
{
  string collection = visit_url('place.php?whichplace=nstower_door');

  log("Unlocking the perplexing tower door.");

  if (contains_text(collection, "lock_boris.gif"))
  {
    log("Using the " + wrap($item[boris's key]));
    visit_url('place.php?whichplace=nstower_door&action=ns_lock1');
  }

  if (contains_text(collection, "lock_jarlsberg.gif"))
  {
    log("Using the " + wrap($item[jarlsberg's key]));
    visit_url('place.php?whichplace=nstower_door&action=ns_lock2');
  }

  if (contains_text(collection, "lock_pete.gif"))
  {
    log("Using the " + wrap($item[sneaky pete's key]));
    visit_url('place.php?whichplace=nstower_door&action=ns_lock3');
  }

  if (contains_text(collection, "lock_star.gif"))
  {
    log("Using the " + wrap($item[richard's star key]));
    visit_url('place.php?whichplace=nstower_door&action=ns_lock4');
  }

  if (contains_text(collection, "lock_digital.gif"))
  {
    log("Using the " + wrap($item[digital key]));
    visit_url('place.php?whichplace=nstower_door&action=ns_lock5');
  }

  if (contains_text(collection, "lock_skeleton.gif"))
  {
    log("Using the " + wrap($item[skeleton key]));
    visit_url('place.php?whichplace=nstower_door&action=ns_lock6');
  }

  visit_url('place.php?whichplace=nstower_door&action=ns_doorknob');

  return true;
}

boolean loop_tower(int level)
{
  switch(level)
  {
    case -1:
      if (my_level() < 13)
        return false;

      log("Seeing the council to start the quest.");
      council();
      return true;
    case 0:
    case 1:
      return contest_race();
    case 2:
      log("Claiming your prize.");
      visit_url('place.php?whichplace=nstower&action=ns_01_contestbooth');
      visit_url("choice.php?pwd=&whichchoice=1003&option=4");
      visit_url("main.php");
      return true;
    case 3:
      log("Attending your coronation.");
      visit_url("place.php?whichplace=nstower&action=ns_02_coronation");
      visit_url("choice.php?pwd=&whichchoice=1020&option=1");
      visit_url("choice.php?pwd=&whichchoice=1021&option=1");
      visit_url("choice.php?pwd=&whichchoice=1022&option=1");
      return true;
    case 4:
      return hedge_maze();
    case 5:
      return door_keys();
    case 6:
      return wall_of_skin();
    case 7:
      return wall_of_meat();
    case 8:
      return wall_of_bones();
    case 9:
      return mirror();
    case 10:
      return shadow();
    case 11:
      return sorceress();
    case 12:
      log("Sorceress defeated - going off to tell the council.");
      council();
      return true;
    case FINISHED:
      return false;
    default:
      warning("Trying to do the Sorceress tower but I don't know where we are in the quest.");
      warning("We're at step " + level + ", which I don't recognize.");
      return false;
  }
  return false;
}

boolean L13_Q_sorceress()
{
  if (nagamar()) return true;

  if (my_level() < 13) return false;

  if (quest_status("questL12War") != FINISHED)
    return false;
  if (quest_status("questL11MacGuffin") != FINISHED)
    return false;
  if (quest_status("questL13Final") == FINISHED)
    return false;

  while (loop_tower(quest_status("questL13Final")))
  {
    // actions in loop_tower
  }
  return true;
}

void main()
{
  while (L13_Q_sorceress());
}
