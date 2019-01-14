import "util/yz_main.ash";

void newyou_cleanup()
{

}

void newyou_progress()
{
  if (quest_status("questL13Final") != FINISHED) return;
  if (to_boolean(get_property("_newYouQuestCompleted"))) return;
  if (to_monster(get_property("_newYouQuestMonster")) == $monster[none]) return;

  monster mob = to_monster(get_property("_newYouQuestMonster"));
  skill attack = to_skill(get_property("_newYouQuestSkill"));
  int todo = to_int(get_property("_newYouQuestSharpensToDo"));
  int done = to_int(get_property("_newYouQuestSharpensDone"));

  progress(done, todo, "Saw sharpening complete. (Use " + wrap(attack) + " on " + wrap(mob) + ")");

}


boolean newyou()
{
  string flag = to_lower_case(setting("do_newyou", "aftercore"));

  // never to anything with the newyou:
  if (flag == "never") return false;

  if (flag == "aftercore")
  {
    if (quest_status("questL13Final") == FINISHED)
    {
      flag = "true";
    } else {
      flag = "false";
    }
  }

  if (flag == "false") return false;
  if (quest_status("questL13Final") != FINISHED) return false;
  if (to_boolean(get_property("_newYouQuestCompleted"))) return false;
  if (to_monster(get_property("_newYouQuestMonster")) == $monster[none]) return false;

  monster mob = to_monster(get_property("_newYouQuestMonster"));
  skill attack = to_skill(get_property("_newYouQuestSkill"));
  location loc = where_monster(mob);

  yz_adventure(loc, "combat, -equip [8128]"); // 8128 == fiberglass foil which can auto-kill targets
  return true;
}

void main()
{
  while(newyou());
}
