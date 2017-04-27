import "util/yz_main.ash";

void M20_necklace_progress()
{
  if (!quest_active("questM20Necklace")) return;

  int desks = to_int(get_property("writingDesksDefeated"));

  if (desks < 5 && have($item[ghost of a necklace]))
  {
    // sometimes mafia loses track of a desk fight, which is sad.
    desks = 5;
    set_property("writingDesksDefeated", 5);
  }

  if (desks == 0)
  {
    // not sure if we're doing the writing desk trick at this point, so
    // display as if we're not:
    switch (quest_status("questM20Necklace"))
    {
      case STARTED:
        int hot_drawers = min(4, 1 + floor(numeric_modifier("hot resistance")/3));
        int stench_drawers = min(4, 1 + floor(numeric_modifier("stench resistance")/3));
        string drawers = " (" + wrap(hot_drawers, "red") + " or " + wrap(stench_drawers, "green") + " drawers/turn)";
        progress(to_int(get_property("manorDrawerCount")), 21, "drawers searched in " + wrap($location[the haunted kitchen]) + drawers);
        break;
      case 1:
      case 2:
        int pool = approx_pool_skill();
        int max_pool = max(pool, 18);
        if (pool >= 0)
        {
          progress(pool, max_pool, "approx. pool skill for the " + wrap($location[the haunted billiards room]));
        }
        break;
      case 4:
        task("Return the "+ wrap($item[ghost of a necklace]) + " to " + wrap("Lady Spookyraven", COLOR_MONSTER));
        break;
    }
  }

  if (desks > 0 && desks < 5)
  {
    progress(desks, 5, "defeated " + wrap($monster[writing desk]));
  }

}


void M20_necklace_cleanup()
{

}

boolean writing_desk_trick()
{
  if (!to_boolean(get_property("chateauAvailable"))) return false;
  if (!(to_monster(get_property("chateauMonster")) == $monster[writing desk])) return false;
  if (!(get_campground() contains $item[source terminal])) return false;

  return true;
}

boolean get_billiards_key()
{
  if (have($item[Spookyraven billiards room key])) return false;

  yz_adventure($location[The Haunted Kitchen], "hot resistance, stench resistance");
  return true;
}

boolean get_library_key()
{
  if (have($item[[7302]Spookyraven library key])) return false;

  if (my_inebriety() > 10
      && approx_pool_skill() < 14)
  {
    log("Skipping " + wrap($location[The Haunted Billiards Room]) + " since we're too drunk to play effectively.");
    return false;
  }
  if (my_inebriety() < 8
      && approx_pool_skill() < 14)
  {
    log("Skipping " + wrap($location[The Haunted Billiards Room]) + " until we are a little more tipsy.");
    return false;
  }

  if (dangerous($location[The Haunted Billiards Room]))
  {
    log(wrap($location[The Haunted Billiards Room]) + " seems dangerous. Will try it later.");
    return false;
  }

  maximize("items, -combat, pool skill, hot damage, stench damage");

  if (my_primestat() == $stat[mysticality]
      && element_damage_bonus($element[spooky]) < 10)
  {
    warning(wrap($monster[chalkdust wraith]) + " will be difficult with low bonus elemental damage.");
  }

  if (approx_pool_skill() < 14)
  {
    set_property("choiceAdventure875", 2);
  } else {
    set_property("choiceAdventure875", 1);
  }
  yz_adventure($location[The Haunted Billiards Room]);

  return true;

}

void set_manor_skill_option()
{
  if (!have($item[english to a. f. u. e. dictionary]))
  {
    set_property("choiceAdventure888", 4); // skip
    return;
  }

  if (my_class() == $class[pastamancer] && !have_skill($skill[fearful fettucini]))
  {
    set_property("choiceAdventure888", 3); // complete manor skill quest
    return;
  }

  if (my_class() == $class[sauceror] && !have_skill($skill[scarysauce]))
  {
    set_property("choiceAdventure888", 3); // complete manor skill quest
    return;
  }

  set_property("choiceAdventure888", 4); // skip
  return;
}

boolean get_necklace()
{
  if (have($item[Lady Spookyraven's necklace])) return false;
  if (!have($item[[7302]Spookyraven library key])) return false;
  if (dangerous($location[the haunted library]))
  {
    log(wrap($location[the haunted library]) + " seems dangerous. Will try it later.");
    return false;
  }


  set_manor_skill_option();

  set_property("choiceAdventure889", 4);

  yz_adventure($location[the haunted library], "");
  return true;
}

boolean M20_necklace()
{

  if (quest_status("questM20Necklace") == FINISHED && quest_status("questM21Dance") < 1)
  {
    log("Talking to " + wrap("Lady Spookyraven", COLOR_MONSTER) + " to see about dancing.");
    visit_url("place.php?whichplace=manor2&action=manor2_ladys");
    return true;
  }

  if (!quest_active("questM20Necklace")) return false;

  if (quest_status("questM20Necklace") < 4
      && writing_desk_trick())
  {
    return false;
  }

  switch (quest_status("questM20Necklace"))
  {
    case STARTED:
      // get key from kitchen
      return get_billiards_key();
    case 1:
    case 2:
      // get key from billiards
      return get_library_key();
    case 3:
      // get necklace from writing desk
      return get_necklace();
    case 4:
      log("Returning " + wrap($item[lady spookyraven's necklace]) + " to " + wrap("Lady Spookyraven", COLOR_MONSTER) + ".");
      visit_url("place.php?whichplace=manor1&action=manor1_ladys");
      return true;
  }
  warning("Quest status for the necklace quest that I don't understand: " + quest_status("questM20Necklace") + ".");
  return true;
}


void main()
{
  while(M20_necklace());
}
