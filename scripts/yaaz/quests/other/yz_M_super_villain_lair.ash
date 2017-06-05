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

  return yz_adventure($location[Super Villain's Lair], "-combat");
}

void main()
{
  while(M_super_villain_lair());
}
