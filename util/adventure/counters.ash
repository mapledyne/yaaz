import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/quests.ash";
import "util/base/maximize.ash";
import "util/base/settings.ash";
import "util/base/locations.ash";


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

boolean digitized_monster_counter()
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

boolean semi_rare_window()
{
  if ((get_counters("Semirare window begin", 0, 0) == ""
      && get_counters("Semirare window end", 0, 39) == "")
      || my_fullness() >= fullness_limit())
    return false;

  log("Semirare window is upon us but we don't know the exact number.");
  log("Not optimal, but can't think of a better way to do this...");
  wait(5);
  log("Eating a " + wrap($item[fortune cookie]) + ".");
  eat(1, $item[fortune cookie]);
  return true;
}

boolean counters()
{
  if (semi_rare_window()) return true;
  if (semi_rare()) return true;
  if (dance_card()) return true;
  if (digitized_monster_counter()) return true;

  return false;
}
