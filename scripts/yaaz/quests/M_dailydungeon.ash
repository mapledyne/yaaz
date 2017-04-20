import "util/main.ash";

void M_dailydungeon_cleanup()
{

}

boolean M_dailydungeon()
{
  if (to_boolean(get_property("dailyDungeonDone")))
  {
    return false;
  }

  if (dangerous($location[The Daily Dungeon])) return false;

  boolean do_dungeon = false;

  if (have_cubeling_items()
      && quest_status("questL13Final") < 3
      && hero_keys() < 3)
  {
    do_dungeon = true;
  }

  if (have_cubeling_items()
      && quest_status("questL13Final") == FINISHED)
  {
    do_dungeon = true;
  }

  if (!have_familiar($familiar[Gelatinous Cubeling])
      && !have($item[deck of every card])
      && my_level() > 4
      && hero_keys() < 3)
  {
    do_dungeon = true;
  }

  if (to_boolean(setting("always_daily_with_cubeling"))
      && have_cubeling_items())
  {
    do_dungeon = true;
  }

  if (!do_dungeon)
  {
    return false;
  }

  if (have($item[eleven-foot pole]))
  {
    set_property("choiceAdventure693", 2);
  } else {
    set_property("choiceAdventure693", 1);
  }
  if (have($item[ring of detect boring doors]))
  {
    set_property("choiceAdventure690", 2);
    set_property("choiceAdventure691", 2);
  } else {
    set_property("choiceAdventure690", 1);
    set_property("choiceAdventure691", 1);
  }

  if (have($item[pick-o-matic lockpicks]))
  {
    set_property("choiceAdventure692", 3);
  }
  else if (item_amount($item[skeleton key]) > 1)
  {
    set_property("choiceAdventure692", 2);
  } else if (my_buffedstat(my_primestat()) >= 30)
  {
  //[20:14] Gaikotsu: [237] The Daily Dungeon (Room 2) Encounter: I Wanna Be a Door Requested choice (5) for choice #692 is not currently available. choice 1: Try the doorknob (suffer trap effects) choice 6: Sneak past it (bypass trap with moxie) choice 8: Leave the way ...
  //[20:14] Gaikotsu: ... you came in. (leave, no turn spent) Click here to continue in the relay browser.

    switch(my_primestat())
    {
      case $stat[muscle]:
        set_property("choiceAdventure692", 4);
        break;
      case $stat[mysticality]:
        set_property("choiceAdventure692", 5);
        break;
      case $stat[moxie]:
        set_property("choiceAdventure692", 6);
        break;
    }
  } else {
    set_property("choiceAdventure692", 1);
  }

  maximize("", $item[ring of detect boring doors]);
  yz_adventure($location[the daily dungeon]);
  return true;
}


void main()
{
  while(M_dailydungeon());
}
