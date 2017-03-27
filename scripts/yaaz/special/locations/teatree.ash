import "util/base/print.ash";

void teatree()
{
  if (!(get_campground() contains $item[potted tea tree]))
    return;
  if (to_boolean(get_property("_pottedTeaTreeUsed")))
    return;
  log("Shaking your " + wrap($item[potted tea tree]) + ".");
  set_property("choiceAdventure1104", 1);
  visit_url("campground.php?action=teatree");
  visit_url("choice.php?pwd&whichchoice=1104&option=1");
}

void main()
{
  teatree();
}
