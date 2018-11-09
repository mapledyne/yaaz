import "special/items/yz_deck.ash";
import "util/yz_main.ash";

void M_super_villain_lair_progress()
{

  if (my_path() != "License to Adventure") {
    return;
  }

  int lair_progress = get_property("_villainLairProgress").to_int();

  if (lair_progress == 999) {
    return;
  }
  progress(lair_progress, 65, "minions killed in the lair");

}

void M_super_villain_lair_cleanup()
{

}

boolean acquire_spy_items()
{
  boolean ret;

  if (
    !have($item[Knob Goblin firecracker])
    && !get_property("_villainLairFirecrackerUsed").to_boolean()
  )
  {
    ret = time_combat($monster[Sub-Assistant Knob Mad Scientist], $location[The Outskirts of Cobb's Knob]);
    if (ret) return true;
  }

  if (
    !have($item[spider web])
    && !get_property("_villainLairWebUsed").to_boolean()
  )
  {
    ret = time_combat($monster[big creepy spider], $location[the sleazy back alley]);
    if (ret) return true;
    ret = time_combat($monster[completely different spider], $location[the sleazy back alley]);
    if (ret) return true;
  }

  if (
    !have($item[razor-sharp can lid])
    && !get_property("_villainLairCanLidUsed").to_boolean()
  )
  {
    ret = time_combat($monster[possessed can of tomatoes], $location[The Haunted Pantry]);
    if (ret) return true;
    ret = time_combat($monster[fiendish can of asparagus], $location[The Haunted Pantry]);
    if (ret) return true;
  }

  return false;
}

boolean M_super_villain_lair()
{

  if (my_path() != "License to Adventure") {
    return false;
  }

  if (get_property("_villainLairProgress").to_int() == 999) {
    return false;
  }

  // Do we want to use a key or not?
  // If we have at least 3 keys, and a tower card spare (so we can recover the key easily)
  if (can_deck("tower") && hero_keys() >= 3) {
    set_property("choiceAdventure1261", 2);
  } else {
    set_property("choiceAdventure1261", 1);
  }

  // Wait until we've definitely opened the lair
  if (get_property("_villainLairProgress").to_int() > 0) {
    // Use Minions-Be-Gone
    use_all($item[can of Minions-Be-Gone]);
  }

  // Acquire lair shortening items.
  // If an item reduces lair by 3, and we can (hopefully) get the item in 1
  // that's a net gain of 2 adventures per item
  if (acquire_spy_items()) {
    return true;
  }

  return yz_adventure($location[Super Villain's Lair], "-combat");
}

void main()
{
  while(M_super_villain_lair());
}
