import "util/main.ash";
import "special/items/deck.ash";

boolean[location] leveling_targets = $locations[the haunted pantry,
                                                the sleazy back alley,
                                                the spooky forest,
                                                a barroom brawl,
                                                the degrassi knoll gym,
                                                the degrassi knoll restroom,
                                                The Bat Hole Entrance,
                                                the degrassi knoll bakery,
                                                guano junction,
                                                the beanbat chamber,
                                                cobb's knob kitchens,
                                                the haunted conservatory,
                                                8-bit realm,
                                                the batrat and ratbat burrow,
                                                cobb's knob harem,
                                                cobb's knob treasury];


location get_leveling_location()
{
  location target = $location[none];
  foreach loc in leveling_targets
  {
    if (!location_open(loc)) continue;
    if (dangerous(loc)) return target;
    target = loc;
  }
  return target;
}


boolean do_leveling_thing()
{
  if (cheat_deck(cheat_stat(), "gain stats")) return true;

  if (quest_status("questM20Necklace") == FINISHED)
  {
    set_property("louvreDesiredGoal", 10); // prime stat
    return yz_adventure($location[the haunted gallery], "exp, ml, -combat");
  }

  maximize("ml, exp");
  location loc = get_leveling_location();
  if (loc == $location[none])
  {
    error("I don't know how to level you up in your current state.");
    error("Level up and try this script again.");
    abort();
  }

  // not optimal, but if we're leveling this early "optimal" isn't really
  // a driving force yet.
  if (to_boolean(get_property("_treasuryEliteMeatCollected"))
      && is_wearing_outfit("Knob Goblin Elite Guard Uniform"))
  {
    equip($slot[pants], $item[none]);
  }

  if (to_boolean(get_property("_treasuryHaremMeatCollected"))
      && is_wearing_outfit("Knob Goblin Harem Girl Disguise"))
  {
    equip($slot[hat], $item[none]);
  }

  warning("The kingdom is a dangerous place. Going to try to level up a bit in the " + wrap(loc) + ". Everywhere else still seems dangerous.");
  return yz_adventure(loc);
}

boolean M_level_up()
{

  int lvl = my_level();
  while(lvl == my_level())
  {
    if (!do_leveling_thing()) return true;
  }
  log("Level Up! Now let's see what else we can do.");
  council();
  return true;
}

void main()
{
  M_level_up();
}
