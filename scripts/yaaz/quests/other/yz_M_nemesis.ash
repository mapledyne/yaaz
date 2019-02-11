import "util/yz_main.ash";

boolean[class] nemesis_classes = $classes[Seal Clubber,
                                          Turtle Tamer,
                                          Pastamancer,
                                          Sauceror,
                                          Disco Bandit,
                                          Accordion Thief];

monster my_nemesis()
{
  switch (my_class())
  {
    case $class[seal clubber]:
      return $monster[Gorgolok, the Infernal Seal (inner sanctum)];
    case $class[Turtle Tamer]:
      return $monster[Stella, the Turtle Poacher (inner sanctum)];
    case $class[Pastamancer]:
      return $monster[Spaghetti Elemental (inner sanctum)];
    case $class[Sauceror]:
      return $monster[Lumpy, the Sinister Sauceblob (inner sanctum)];
    case $class[Disco Bandit]:
      return $monster[Spirit of New Wave (inner sanctum)];
    case $class[Accordion Thief]:
      return $monster[Somerset Lopez, Dread Mariachi (inner sanctum)];

  }
  return $monster[none];
}

skill nemesis_cave_skill()
{
  switch(my_class())
  {
    case $class[seal clubber]:
      return $skill[Wrath of the Wolverine];
    case $class[Turtle Tamer]:
      return $skill[Amphibian Sympathy];
    case $class[Pastamancer]:
      return $skill[Entangling Noodles];
    case $class[Sauceror]:
      return $skill[stream of sauce];
    case $class[Disco Bandit]:
      return $skill[Disco State of Mind];
    case $class[Accordion Thief]:
      return $skill[Accordion Bash];
  }
  return $skill[none];
}

boolean nemesissing()
{
  if (!(nemesis_classes contains my_class())) return false;
  string option = setting("do_nemesis", "false");
  switch(option)
  {
    default:
      if (setting("nemesis_warning", "false") == "true") return false;
      error("I don't understand the setting for " + wrap("yz_nemesis", COLOR_ITEM) + ": " + wrap(option, COLOR_ITEM) + ". Options are: aftercore, true, false. Defaulting to false.");
      wait(10);
      save_daily_setting("nemesis_warning", "true");
      return false;
    case "aftercore":
      return in_aftercore();
    case "false":
    case "weapon":
    case "aftercore-weapon":
      return false;
    case "true":
      return true;
  }
}


void M_nemesis_progress()
{
  if (!nemesissing()) return;

  if (my_basestat(my_primestat()) < 23) return;
  if (!have(my_legendary_epic_weapon())) return;

  switch (quest_status("questG04Nemesis"))
  {
    case 10:
    case 11:
      if (!have_skill(nemesis_cave_skill()))
      {
          task("Buy your class skill " + wrap(nemesis_cave_skill()) + " to help enter the " + wrap("The Dark and Dank and Sinister Cave", COLOR_LOCATION));
      }
      break;
    case 12:
    case 13:
    case 14:
      int qty = item_amount($item[fizzing spore pod]);
      if (qty < 6)
      {
        progress(qty, 6, wrap($item[fizzing spore pod], 2) + " for the nemesis cave wall.");
      } else {
        task ("Blow up the " + wrap("impassable rubble", COLOR_LOCATION) + " in the nemesis cave.");
      }
      break;
    case 1000:
      if (!have($item[secret tropical island volcano lair map]))
      {
        task("Find the " + wrap($item[secret tropical island volcano lair map]));
      }

      if ($location[The Nemesis' Lair].turns_spent > 0)
      {
          if (my_class() == $class[disco bandit])
              task("Fight daft punk, then your nemesis face to face.");
          else
              task("Fight goons, then your nemesis.");
      } else {

        switch(my_class())
        {
          case $class[accordion thief]:
            int keys = item_amount($item[hacienda key]);
            if (keys < 5)
            {
              progress(keys, 5, wrap($item[hacienda key], item_amount($item[hacienda key])) + " collected.");
            } else {
              task (wrap($item[Hacienda key], 5) + " collected.");
            }

            break;

        }

      }
      break;

  }

}

void M_nemesis_cleanup()
{

}

boolean nemesis_spore_pod()
{
  log("Going to try to collect a " + wrap($item[fizzing spore pod]) + " from the " + wrap($location[The Fungal Nethers]));
  monster_attract = $monsters[Angry mushroom guy];
  monster_banish = $monsters[armored mushroom guy,
                             dancing mushroom guy,
                             fiery mushroom guy,
                             freaked-out mushroom guy,
                             muscular mushroom guy,
                             wailing mushroom guy,
                             wizardly mushroom guy];
  return yz_adventure($location[The Fungal Nethers], "items");
}

boolean M_nemesis()
{
  if (my_basestat(my_primestat()) < 12) return false;
  if (!have(my_legendary_epic_weapon())) return false;
  
  if (!nemesissing()) return false;

  switch (quest_status("questG04Nemesis"))
  {
    case 9:
      log("Going to the clan to open " + wrap("The Dark and Dank and Sinister Cave", COLOR_LOCATION));
      visit_url('guild.php?place=scg');
      return true;
    case 10:
    case 11:
      if (!have_skill(nemesis_cave_skill())) return false;
      log("Entering " + wrap("The Dark and Dank and Sinister Cave", COLOR_LOCATION) + " to have a look around.");
      visit_url('place.php?whichplace=mountains&action=mts_caveblocked');
  		cli_execute("choice-goal");
      return true;
    case 12:
    case 13:
    case 14:
      if (item_amount($item[fizzing spore pod]) < 6)
      {
        nemesis_spore_pod();
        return true;
      } else {
        log("Going to blow up the " + wrap("impassable rubble", COLOR_LOCATION));
        visit_url('place.php?whichplace=nemesiscave&action=nmcave_rubble');
        visit_url('choice.php?whichchoice=1088&option=1');
        return true;
      }
    case 15:
      // The final (?) showdown!

      maximize();
      log("Off to defeat your nemesis (" + wrap(my_nemesis()) + ") in " + wrap("The Final (?) Showdown", COLOR_LOCATION));
      visit_url('place.php?whichplace=nemesiscave&action=nmcave_boss');
      run_combat();
      return true;
    case 16:
      log("Going to tell the guild you defeated your nemesis, " + wrap(my_nemesis()));
      visit_url('guild.php?place=scg');
      visit_url('guild.php?place=scg'); // Sometimes requires two visits. Sometimes not. Maybe figure out why?
      return true;
    case 17:
      // waiting for nemesis assassins
      return false;
    case 18:
    case 19:
      // waiting for assassins
      return false;

  }
  return false;
}
