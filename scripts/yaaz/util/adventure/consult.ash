import "util/base/inventory.ash";
import "util/base/monsters.ash";
import "special/locations/terminal.ash";
import "util/base/monsters.ash";
import "util/base/war_support.ash";

string maybe_digitize(monster foe)
{
  if (!have_skill($skill[digitize])) return "";
  if (digitize_remaining() < 1) return "";

  monster digitized = to_monster(get_property("_sourceTerminalDigitizeMonster"));

  int copiesmade = to_int(get_property("_sourceTerminalDigitizeMonsterCount"));

  switch (foe)
  {
    default:
      return "";
    case $monster[dirty thieving brigand]:
      if (to_int(get_property("currentNunneryMeat")) < 94000)
      {
        return "";
      }
      break;
    case $monster[ninja snowman assassin]:
      break;
    case $monster[writing desk]:
    case $monster[lobsterfrogman]:
      int thingwanted = item_amount($item[barrel of gunpowder]);
      if (foe == $monster[writing desk])
      {
        thingwanted = to_int(get_property("writingDesksDefeated"));
      }
      boolean digizap = digitized != foe;
      if (digitized == foe && copiesmade > 2) digizap = true;

      // we want 5, but if we have 4 already then defeating one more will give us 5,
      // so only looking for 3 or less of the things we want.
      if (thingwanted >= 4) digizap = false;

      if (!digizap) return "";
      break;
  }

  return "skill digitize";
}

string maybe_duplicate(monster foe)
{
  if (!have_skill($skill[duplicate])) return "";
  int dupes = to_int(get_property("_sourceTerminalDuplicateUses"));
  int max_dupes = 1;
  if (my_path() == "The Source") max_dupes = 5;

  if (dupes >= max_dupes) return "";

  // bail if the monster is likely to kill us.
  if (expected_damage(foe) > my_hp() / 2) return "";

  switch (foe)
  {
    default:
      return "";
    case $monster[gaudy pirate]:
      if (have($item[Talisman o' Namsilat])) return "";
      if (have($item[snakehead charrrm])) return "";
      break;
  }

  return "skill duplicate";
}

string maybe_extract(monster foe)
{
  if (have_skill($skill[extract jelly]))
  {
    if (foe.attack_element != $element[none])
      return "skill extract jelly";
  }
  return "";
}

string maybe_trap_ghost(monster foe)
{
  if (!(ghosts contains foe)) return "";

  if (have_skill($skill[shoot ghost]))
  {
    if (expected_damage(foe) < (my_hp() / 2))
    {
      return "skill shoot ghost";
    }
  }

  if (have_skill($skill[trap ghost]))
  {
      return "skill trap ghost";
  }
  return "";
}

string maybe_shadow(monster foe)
{
  // this could obviously use some much better finesse.
  if (foe != $monster[your shadow]) return "";

  if (have_skill($skill[Ambidextrous Funkslinging]))
  {
    return "item gauze garter, gauze garter";
  }
  abort("Combat with Your Shadow without the skill Ambidextrous Funkslinging isn't yet supported. Handle this battle yourself.");
  return "";
}

string maybe_yellow_ray(monster foe)
{
  if (have_effect($effect[everything looks yellow]) > 0) return "";

  item yr = yellow_ray_item();
  if (yr == $item[none]) return "";

  switch (foe)
  {
    default:
      return "";
    case $monster[frat warrior drill sergeant]:
    case $monster[war pledge]:
    case $monster[War Frat 151st Infantryman]:
      if (war_side() != "fratboy") return "";
      if (have_outfit(war_outfit())) return "";
      break;
    case $monster[war hippy drill sergeant]:
    case $monster[war hippy (space) cadet]:
      if (war_side() != "hippy") return "";
      if (have_outfit(war_outfit())) return "";
      break;
  }
  return "item " + yr;
}

string yz_consult(int round, string mob, string text)
{
  monster foe = to_monster(mob);

  string maybe = maybe_extract(foe);
  if (maybe != "") return maybe;

  maybe = maybe_trap_ghost(foe);
  if (maybe != "") return maybe;

  maybe = maybe_digitize(foe);
  if (maybe != "") return maybe;

  maybe = maybe_duplicate(foe);
  if (maybe != "") return maybe;

  maybe = maybe_yellow_ray(foe);
  if (maybe != "") return maybe;

  maybe = maybe_shadow(foe);
  if (maybe != "") return maybe;

  return "consult WHAM.ash";
}
