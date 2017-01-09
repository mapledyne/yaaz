import "util/main.ash";

boolean M_dailydungeon()
{
  if (to_boolean(get_property("dailyDungeonDone")))
  {
    return false;
  }

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

  while (!to_boolean(get_property("dailyDungeonDone")))
  {
    maximize("", $item[ring of detect boring doors]);
    boolean b = dg_adventure($location[the daily dungeon]);
    if (!b)
      return true;
  }
  return true;
}


void main()
{
  M_dailydungeon();
}
