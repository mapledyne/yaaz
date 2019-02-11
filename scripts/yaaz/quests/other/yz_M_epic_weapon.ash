import "util/yz_main.ash";

int clownosity_total()
{
  int total = 0;
  if (have($item[polka-dot bow tie])) total += 3;
   
  foreach c in $items[clown wig,
                      clown whip,
                      clownskin buckler,
                      clownskin harness,
                      balloon sword]
  {
    if (have(c)) total += 2;
  }

  foreach c in $items[balloon helmet,
                      foolscap fool's cap,
                      bloody clown pants,
                      clown shoes,
                      big red clown nose]
  {
    if (have(c)) total += 1;
  }

  return total;
}

boolean do_epic_weapon()
{
  if (my_basestat(my_primestat()) < 12) return false;

  string do_it = setting("do_nemesis", "unk");

  switch(do_it)
  {
    case "unk":
      if (setting("nemesis_warn") != "true")
      {
        log("If you want to do the epic weapon quest or the nemesis quest, set 'yz_do_nemesis' to one of:");
        log("true, false, aftercore, weapon, aftercore-weapon. ('aftercore' will skip this until aftervore, 'weapon' will stop at the legendary epic weapon stage)");
        wait(5);
        save_daily_setting("nemesis_warn", "true");
      }
      return false;
    case "true":
    case "weapon":
      return true;
    case "false":
      return false;
    case "aftercore":
    case "aftercore-weapon":
      if (in_aftercore()) return true;
      return false;
  }
  return false;
}

void M_epic_weapon_progress()
{
  if (!do_epic_weapon()) return;
  if (have(my_legendary_epic_weapon())) return;
  if (!have(my_starter_weapon()) && !have(my_epic_weapon()) && !have(my_legendary_epic_weapon()))
  {
    task("Go get your starter weapon (" + wrap(my_starter_weapon()) + ")");
  }
  else if (!have(my_epic_weapon()))
  {
      task("Recover your epic weapon (" + wrap(my_epic_weapon()) + ") from " + wrap($location[The Unquiet Garves]));
  }
}



void M_epic_weapon_cleanup()
{
  if (quest_status("questG04Nemesis") == 5)
  {
    foreach toy in $items[clown wig,
                          clown whip,
                          clownskin buckler,
                          clownskin belt,
                          clownskin harness,
                          balloon sword]
    {
      if (have(toy)) continue;
      if (creatable_amount(toy) == 0) return;
      
      // wait on the helmet until after the sword since it's > clownosity
      if (toy == $item[balloon helmet] && !have($item[balloon sword])) continue;
      log("Making a " + wrap(toy) + " to help with our clownosity level.");
      create(1, toy);
    }
  }

  if (!have(my_legendary_epic_weapon()) && creatable_amount(my_legendary_epic_weapon()) > 0)
  {
    log("Going to craft our legendary epic weapon: " + wrap(my_legendary_epic_weapon()));
    create(1, my_legendary_epic_weapon());
  }
}

boolean M_epic_weapon()
{
  if (my_basestat(my_primestat()) < 12) return false;
  if (!do_epic_weapon()) return false;

  if (have(my_legendary_epic_weapon()) && quest_status("questG04Nemesis") == 8)
  {
    log("Taking our " + wrap(my_legendary_epic_weapon()) + " to show the clan.");
    visit_url('guild.php?place=scg');
    return true;
  }

  if (have(my_legendary_epic_weapon())) return false;
  if (!have(my_starter_weapon()))
  {
    if (npc_price($item[chewing gum on a string]) == 0) return false;
    while(!have(my_starter_weapon()) && my_meat() > 500)
    {
      log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap(my_starter_weapon()) + ".");
      stock_item($item[chewing gum on a string]);
      use(1, $item[chewing gum on a string]);
    }
  }

  if (!have(my_starter_weapon())) return false;

  switch (quest_status("questG04Nemesis"))
  {
      default:
        debug("Unsure what the nemesis progress is for the epic weapon quest: " + wrap(get_property("questG04Nemesis"), COLOR_ITEM));
        return false;
      case UNSTARTED:
        log("Going to the guild to start the quest for your epic weapon.");
        visit_url('guild.php?place=scg');
        // quest doesn't seem to get updated, so check the log to update:
        visit_url('questlog.php?which=7');
        return true;
      case STARTED:

        log("Off to the " + wrap($location[The Unquiet Garves]) + " to get the " + wrap(my_epic_weapon()));
        maximize("-combat");
        yz_adventure($location[The Unquiet Garves]);
        return true;
      case 4:
        log("Checking in with the clan and opening " + wrap($location[The "Fun" House]));
        visit_url('guild.php?place=scg');
        return true;
      case 5:
        string max = "items";
        set_property("choiceAdventure151", "2");
        if (clownosity_total() >= 4)
        {
          set_property("choiceAdventure151", "1");
          max = "4 clownosity, -tie";
          log("Going to get try to defeat " + wrap($monster[The Clownlord Beelzebozo]));
        } else {
          log("Still scouting for items to give us more clownosity.");
        }
        maximize(max);
        monster_attract = $monsters[shaky clown, scary clown, creepy clown];
        monster_banish = $monsters[bugbear-in-the-box, disease-in-the-box, lemon-in-the-box];
        yz_adventure($location[The "Fun" House]);
        return true;
        
      case 6:
        // should be able to make the legendary epic weapon at this point.
        return false;

  }
  return false;
}
