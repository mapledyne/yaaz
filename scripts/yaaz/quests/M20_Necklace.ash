import "util/main.ash";

void M20_necklace_progress()
{

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
    info("Skipping " + wrap($location[The Haunted Billiards Room]) + " since we're too drunk to play effectively.");
    return false;
  }
  if (my_inebriety() < 8
      && approx_pool_skill() < 14)
  {
    info("Skipping " + wrap($location[The Haunted Billiards Room]) + " until we are a little more tipsy.");
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
