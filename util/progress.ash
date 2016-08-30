import "util/util.ash";
import "util/print.ash";

void progress_sheet()
{
  print("Current progress in a few things:");
  if (my_level() < 13)
  {
    progress(my_level(), 13, "progress to level 13");
  }
  if (item_amount($item[digital key]) == 0 && item_amount($item[white pixel]) > 0)
  {
    progress(item_amount($item[white pixel]), 30, "digital key");
  }
  int desks = to_int(get_property("writingDesksDefeated"));

  if (desks > 0 && desks < 5)
  {
    progress(desks, 5, "writing desks defeated");
  }

  int ore = item_amount($item[asbestos ore]);
  if (quest_status("questL08Trapper") < 2 && ore > 0 && ore < 3)
  {
    progress(ore, 3, "ore for the trapper");
  }

  int cheese = item_amount($item[goat cheese]);
  if (quest_status("questL08Trapper") < 2 && cheese > 0 && cheese < 3)
  {
    progress(cheese, 3, "cheese for the trapper");
  }

  if (quest_status("questL07Cyrptic") < FINISHED && quest_status("questL07Cyrptic") > UNSTARTED)
  {
    int evil = 200 - to_int(get_property("cyrptTotalEvilness"));
    progress(evil, 200, "Cyrpt progress");
  }

}

void main()
{
  progress_sheet();
}
