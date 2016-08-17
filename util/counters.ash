import "util/print.ash";

location pick_semi_rare_location()
{
  location last = to_location(get_property("semirareLocation"));

  // if we don't have the KGE outfit, get it for dispensary access.
  foreach key,doodad in outfit_pieces("Knob Goblin Elite Guard Uniform")
    if (i_a(doodad) == 0)
      return $location[Cobb's Knob Barracks];

  // Get some stone wool if useful:
  if (hidden_temple_unlocked() && item_amount($item[stone wool]) < 2)
  {
    if (quest_status("questL11Worship") < 3)
      return $location[The Hidden Temple];
  }



  return $location[none];
}


void semi_rare()
{
  if(get_counters("Fortune Cookie", 0, 0) == "")
    return;

  location loc = pick_semi_rare_location();
  if (loc == $location[none])
  {
    warning("Semi-rare counter is up, but for some reason we decided not to get something.");
    return;
  }
  log("Semi-rare is up! Adventuring in " + wrap(loc) + ".");
  adventure(1, loc);
}

void dance_card()
{
  if(get_counters("Dance Card", 0, 0) == "")
    return;

  location loc = $location[The Haunted Ballroom];
  log("Dance card is up! Adventuring in " + wrap(loc) + ".");
  adventure(1, loc);
  if (item_amount($item[dance card]) > 0)
    use(1, $item[dance card]);
}

void counters()
{
  semi_rare();
  dance_card();
}
