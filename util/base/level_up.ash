import "util/base/print.ash";
import "util/base/quests.ash";
import "util/iotm/deck.ash";

boolean do_leveling_thing()
{
  if (cheat_deck(cheat_stat(), "gain stats")) return true;

  if (quest_status("questM20Necklace") == FINISHED)
  {
    return dg_adventure($location[the haunted gallery], "exp, ml, -combat");
  }
  log("Unsure how to level at this, ahem, level.");
  wait(10);
  return false;
}

boolean level_up()
{
  log("Looks like we reached a point we need to level before we can do other interesting things.");
  log("Hit ESC here if you want to do something manually instead.");
  wait(10);

  int lvl = my_level();
  while(lvl == my_level())
  {
    if (!do_leveling_thing()) return true;
  }
  log("Level Up! Now let's see what else we can do.");
  return true;
}

void main()
{
  level_up();
}
