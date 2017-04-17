import "util/base/print.ash";
import "util/base/settings.ash";
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

void add_attract(monster mon);
void remove_attract(monster mon);
void add_yellow_ray(monster mon);
void remove_yellow_ray(monster mon);
void add_duplicate(monster mon);
void remove_duplicate(monster mon);


boolean dangerous(monster mon)
{
  boolean awooga = expected_damage(mon) > my_maxhp() / 4;

  if (awooga) debug("Checking if " + wrap(mon) + " is dangerous. It is.");
  return awooga;
}

boolean dangerous(location loc)
{
  int counter = 0;
  monster[] monsters = get_monsters(loc);
  int threshold = count(monsters) / 2;
//  int threshold = 2;
  foreach i, mon in monsters
  {
    if (dangerous(mon)) counter++;
    if (counter >= threshold)
    {
      debug("Checking " + wrap(loc) + " to see if it's dangerous. It is.");
      return true;
    }
  }
  return false;
}

void add_attract(monster mon)
{
  if (mon == $monster[none])
    return;

  if (have_effect($effect[on the trail]) > 0)
  {
    if (to_monster(get_property("olfactedMonster")) != mon && item_amount($item[soft green echo eyedrop antidote]) > 0)
    {
      log("Trying to remove " + wrap($effect[on the trail]) + " since its smelling the wrong monster.");
      cli_execute("uneffect on the trail");
    }
  }
  string attract_list = vars["BatMan_attract"];

  if (contains_text(attract_list, mon))
  {
    return;
  }
  log("Adding " + wrap(mon) + " to the attract (olifact) list.");

  attract_list = list_add(attract_list, mon);

  vars["BatMan_attract"] = attract_list;
  updatevars();
}

void remove_attract(monster mon)
{
  if (mon == $monster[none])
    return;

  string attract_list = vars["BatMan_attract"];

  if (!contains_text(attract_list, mon))
  {
    return;
  }

  log("Removing " + wrap(mon) + " from the attract (olifact) list.");
  attract_list = list_remove(attract_list, mon);
  vars["BatMan_attract"] = attract_list;
  updatevars();

}
