import "util/main.ash";
import "util/iotm/deck.ash";

boolean wall_of_skin()
{
  if (item_amount($item[beehive]) == 0)
  {
    warning("You're at the wall of skin without a beehive. Sad. I can't help you.");
    return false;
  }

  maximize("");
  dg_adventure($location[tower level 1]);
  if (quest_status("questL13Final") == 6)
  {
    warning("Something happened. We should be past the Wall of Skin, but aren't for some reason.");
    return false;
  }
  log(wrap($monster[wall of skin]) + " defeated.");
  return true;
}

boolean wall_of_bones()
{
  set_property("choiceAdventure1026",2);
  if (item_amount($item[electric boning knife]) == 0)
  {
    log("First, going to get an " + wrap($item[electric boning knife]) + ".");
  }
  while (item_amount($item[electric boning knife]) == 0)
  {
    location ground = $location[the castle in the clouds in the sky (ground floor)];
    maximize("noncombat");
    dg_adventure(ground);
  }

  maximize("");
  dg_adventure($location[tower level 3]);
  if (quest_status("questL13Final") == 8)
  {
    warning("Something happened. We should be past the " + wrap($monster[wall of bones]) + ", but aren't for some reason.");
    return false;
  }
  log(wrap($monster[wall of bones]) + " defeated.");
  return true;
}

boolean wall_of_meat()
{
  int counter = 0;
  while (quest_status("questL13Final") == 7 && counter < 10)
  {
    maximize("meat, +effective");
    dg_adventure($location[tower level 2]);
    counter += 1;
  }

  if (quest_status("questL13Final") == 7)
  {
    warning("Something went wrong. We're not clear of the " + wrap($monster[wall of meat]) + ", but should be.");
    return false;
  }

  log(wrap($monster[wall of meat]) + " defeated.");
  return true;
}

boolean mirror()
{
  set_property("choiceAdventure1015", 1);
  dg_adventure($location[tower level 4]);

  if (quest_status("questL13Final") == 9)
  {
    warning("Something went wrong. We're should have moved past the mirror, but aren't.");
    return false;
  }

  log("Mirror level passed.");
  return true;
}

boolean shadow()
{
  if (item_amount($item[gauze garter]) + item_amount($item[filthy poultice]) < 8)
  {
    warning("I don't know how to check if we can pass the shadow. I'm expecting a bunch of healing items I can't find.");
    return false;
  }
  maximize("");
  dg_adventure($location[tower level 5]);

  if (quest_status("questL13Final") == 10)
  {
    warning("Something happened. We should be past " + wrap($monster[your shadow]) + ", but aren't for some reason.");
    return false;
  }
  log(wrap($monster[your shadow]) + " defeated.");
  return true;
}

boolean sorceress()
{

  maximize("");
  dg_adventure($location[the naughty sorceress' chamber]);

  if (quest_status("questL13Final") == 11)
  {
    warning("Something happened. We should be past " + wrap($monster[naughty sorceress]) + ", but aren't for some reason.");
    return false;
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

  log("Heading to the Naught Sorceress's contest. Next up, " + max + "!");
  switch (to_lower_case(max))
  {
    default:
      abort("NS Contest not automated: " + max);
    case "init":
      maximize("init");
      cheat_deck("race", "go faster, pussycat, faster");
      effect_maintain($effect[hiding in plain sight]);
      break;
    case "mysticality":
      maximize("mysticality");
      cheat_deck("magician", "get more mystically. Boosty boosty");
      effect_maintain($effect[perspicacious pressure]);
      break;
    case "cold":
      maximize("cold damage, cold spell damage");
      break;
  }
  log("All dressed up and somewhere to go, the Registration Desk.");
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
    dg_adventure($location[fastest adventurer contest]);
    return true;
  }

  if (get_property("nsContestants2").to_int() > 0)
  {
    location loc = get_challenge_loc(get_property("nsChallenge1"));

    maximize();
    dg_adventure(loc);
    return true;
  }

  if (get_property("nsContestants3").to_int() > 0)
  {
    location loc = get_challenge_loc(get_property("nsChallenge2"));

    maximize();
    dg_adventure(loc);
    return true;
  }
  return false;
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
      log("Hedge Maze is not yet automated.");
      return false;
    case 5:
      log("Perplexing door keys not yet automated.");
      return false;
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
    default:
      warning("Trying to do the Sorceress tower but I don't know where we are in the quest.");
      warning("We're at step " + level + ", which I don't recognize.");
      return false;
  }
  return false;
}

boolean L13_Q_sorceress()
{

  // TODO: Get the Wand if you don't have it (it should clover automatically,
  // but we should adventure for it if we don't have it at a certain point).
  if (my_level() < 13)
    return false;

  if (quest_status("questL12War") != FINISHED)
    return false;
  if (quest_status("questL11MacGuffin") != FINISHED)
    return false;


  while (loop_tower(quest_status("questL13Final")))
  {
    // actions in loop_tower
  }
  return true;
}

void main()
{
  L13_Q_sorceress();
}
