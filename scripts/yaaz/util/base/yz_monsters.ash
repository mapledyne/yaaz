import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";
import <zlib.ash>;

boolean[monster] ghosts = $monsters[the ghost of ebenoozer screege,
                                     The ghost of Lord Montague Spookyraven,
                                     The ghost of Waldo the Carpathian,
                                     The Icewoman,
                                     The ghost of Jim Unfortunato,
                                     the ghost of Sam McGee,
                                     Emily Koops\, a spooky lime,
                                     the ghost of Monsieur Baguelle,
                                     the ghost of Vanillica "Trashblossom" Gorton,
                                     the ghost of Oily McBindle,
                                     boneless blobghost,
                                     The ghost of Richard Cockingham,
                                     The Headless Horseman];


boolean[monster] monster_attract;
boolean[monster] monster_banish;
boolean[monster] monster_grab;

// Note: These dangerous() functions I think are key to optimizing this script overall.
// Once it can ascend fully, making this function smarter on when we should skip a
// monster or area will really make this script smarter.
boolean dangerous(monster mon)
{
  boolean awooga = expected_damage(mon) > my_hp() / 4;

  // reduce threshold a bit for bosses since they often have trickier attacks and defenses:
  if (mon.boss)
  {
    awooga = expected_damage(mon) > my_hp() / 8;
  }

  if (awooga) debug("Checking if " + wrap(mon) + " is dangerous. It is.");
  return awooga;
}

boolean dangerous(location loc)
{
  int counter = 0;
  monster[int] monsters = get_monsters(loc);
  float threshold = 0.55;
  foreach i, mon in monsters
  {
    if (dangerous(mon)) counter++;
    if (to_float(counter)/count(monsters) >= threshold)
    {
      debug("Checking " + wrap(loc) + " to see if it's dangerous. It is.");
      return true;
    }
  }
  return false;
}

boolean is_bounty_monster(monster mon)
{
  foreach hardness in $strings[Easy, Hard, Special]
  {
    string prop = "current" + hardness + "BountyItem";
    prop = get_property(prop);
    if (prop == "") continue;

    string[2] bounty_parts = split_string(prop, ":");
    bounty b = to_bounty(bounty_parts[0]);
    if (mon == b.monster) return true;
  }
  return false;
}

location where_monster(monster mob)
{
  foreach loc in $locations[]
  {
    monster [int] mob_list = get_monsters(loc);
    foreach m in mob_list
    {
      if (mob_list[m] == mob) return loc;
    }
  }
  return $location[none];
}
