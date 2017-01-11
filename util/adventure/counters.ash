import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/quests.ash";
import "util/base/maximize.ash";

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

  if (last == $location[the haunted pantry])
  {
    return $location[the sleazy back alley];
  }
  return $location[the haunted pantry];
}


boolean semi_rare()
{
  if(get_counters("Fortune Cookie", 0, 0) == "")
    return false;

  location loc = pick_semi_rare_location();
  if (loc == $location[none])
  {
    warning("Semi-rare counter is up, but for some reason we decided not to get something.");
    wait(10);
    return false;
  }
  log("Semi-rare is up! Adventuring in " + wrap(loc) + ".");
  wait(5);
  adv1(loc, 0, "");
  return true;
}

boolean dance_card()
{
  if(get_counters("Dance Card", 0, 0) == "")
    return false;

  location loc = $location[The Haunted Ballroom];
  log("Dance card is up! Adventuring in " + wrap(loc) + ".");
  adventure(1, loc);
  if (item_amount($item[dance card]) > 0)
    use(1, $item[dance card]);
  return true;
}

boolean digitized_monster()
{
  if (get_property("sidequestNunsCompleted") == "none"
      && to_int(get_property("currentNunneryMeat")) < 100000
      && to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand]
      && get_counters("digitize monster", 0, 0) != "")
  {
    log("We're about to see a digitized " + wrap($monster[dirty thieving brigand]) + ".");
    maximize("meat");
    return adventure(1, $location[the haunted pantry]);
  }
  return false;
}

boolean counters()
{
  if (semi_rare()) return true;
  if (dance_card()) return true;
  if (digitized_monster()) return true;

  return false;
}
