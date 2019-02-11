import "util/yz_main.ash";

void visit_shen()
{
  // talk to Shen.
  set_property("choiceAdventure1074", 1);
  yz_adventure($location[the copperhead club], "");

}

item shen_item()
{
  return to_item(get_property("shenQuestItem"));
}

location shen_to_location(item toy)
{
  switch (toy)
  {
    default:
      debug("I don't have a Shen location for: " + wrap(toy));
      return $location[none];
    case $item[the first pizza]:
      return $location[lair of the ninja snowmen];
    case $item[The Stankara Stone]:
      return $location[The Batrat and Ratbat Burrow];
    case $item[Murphy's Rancid Black Flag]:
      return $location[The Castle in the Clouds in the Sky (Top Floor)];
    case $item[The Eye of the Stars]:
      return $location[The Hole in the Sky];
    case $item[The Lacrosse Stick of Lacoronado]:
      return $location[The Smut Orc Logging Camp];
    case $item[The Shield of Brook]:
      return $location[The VERY Unquiet Garves];
  }
}

location shen_to_location()
{
  return shen_to_location(shen_item());
}

void L11_SQ_copperhead_cleanup()
{

}

void L11_SQ_copperhead_progress()
{
  if (quest_active("questL11Shen"))
  {
    task("Find the " + wrap(shen_item()) + " in " + wrap(shen_to_location()) + " for Shen.");
  }

}

boolean L11_SQ_copperhead()
{
  if (!quest_active("questL11Shen")) return false;

  if (quest_status("questL11Shen") == STARTED)
  {
    visit_shen();
    return true;
  }

  item toy = shen_item();
  if (have(toy))
  {
    visit_shen();
    return true;
  }
  yz_adventure(shen_to_location(), "");
  return true;

}

void main()
{
  while (L11_SQ_copperhead());
}
