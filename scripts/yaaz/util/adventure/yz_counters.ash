import "util/base/yz_print.ash";
import "util/base/yz_inventory.ash";
import "util/base/yz_quests.ash";
import "util/base/yz_maximize.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_locations.ash";
import "util/adventure/yz_consult.ash";

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
  adv1(loc, 0, "yz_consult");
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

monster copied_monster_next()
{
  if (get_counters("digitize monster", 0, 0) != "")
    return to_monster(get_property("_sourceTerminalDigitizeMonster"));
  if (get_counters("Enamorang Monster", 0, 0) != "")
    return to_monster(get_property("enamorangMonster"));

  return $monster[none];
}

boolean digitized_monster_counter()
{
  if (get_property("sidequestNunsCompleted") == "none"
      && prop_int("currentNunneryMeat") < 100000
      && copied_monster_next() == $monster[dirty thieving brigand])
  {
    maximize("meat");
    return adv1($location[the haunted pantry], -1, "yz_consult");
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
  // should drink a lucky lindy if not under standard restriction...
  wait(5);
  log("Eating a " + wrap($item[fortune cookie]) + ".");
  eat(1, $item[fortune cookie]);
  return true;
}

boolean counters()
{
  if (copied_monster_next() != $monster[none])
  {
    log("We're about to see a copied " + wrap(copied_monster_next()) + ".");
    wait(3);
  }

  if (semi_rare_window()) return true;
  if (semi_rare()) return true;
  if (dance_card()) return true;
  if (digitized_monster_counter()) return true;

  return false;
}
