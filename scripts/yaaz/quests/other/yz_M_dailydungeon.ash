import "util/yz_main.ash";

void M_dailydungeon_progress()
{
  if (to_boolean(get_property("dailyDungeonDone"))) return;

  if (quest_status("questL13Final") >= 5
      || hero_keys() >= 3)
  {
    if (!to_boolean(setting("always_daily_dungeon", "false"))) return;
  }

  progress(to_int(get_property("_lastDailyDungeonRoom")), 15, "daily dungeon rooms");
}

void M_dailydungeon_cleanup()
{
  if (quest_status("questL13Final") < 5)
  {
    string msg = "for the perplexing door.";
    make_if_needed($item[skeleton key], msg);
  }

  if (to_boolean(setting("always_daily_dungeon", "false"))
      || hero_keys() < 3)
  {
    if (!have($item[Pick-O-Matic lockpicks]))
    {
      make_all($item[skeleton key], "for the daily dungeon");
    }
  }

  if (quest_status("questL13Final") >= 5
      || (hero_keys() >= 3 && have($item[skeleton key])))
  {
    // don't need any more skeleton keys?
    if (!to_boolean(setting("always_daily_dungeon", "false"))
        || have($item[Pick-O-Matic lockpicks]))
    {
      sell_all($item[skeleton key], 1);
      sell_all($item[skeleton bone]);
      sell_all($item[loose teeth]);
    }

  }
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

  if (!can_adventure_with_familiar($familiar[Gelatinous Cubeling])
      && (!have($item[deck of every card]) || !be_good($item[deck of every card]))
      && my_level() > 4
      && hero_keys() < 3
      && !in_aftercore())
  {
    do_dungeon = true;
  }

  if (to_boolean(setting("always_daily_with_cubeling", "true"))
      && have_cubeling_items())
  {
    do_dungeon = true;
  }

  if (to_boolean(setting("always_daily_dungeon", "false")))
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
