script "yaaz-manuel.ash"
notify "degrassi";
since r17948;

import "zlib.ash";

import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";
import "special/items/yz_manuel.ash";

//    monster_factoids_available($monster, cachedonly)

boolean [monster] manuel_monster_list()
{
  boolean [monster] all_monsters = all_monsters_with_id();

  foreach m in all_monsters
  {
    if ( m.attributes.index_of( "NOMANUEL" ) != -1)
    {
        remove all_monsters[m];
    }
  }
  return all_monsters;
}

void update_monster_cache()
{
  log("Updating monster factoid cache...");
  foreach p in $strings[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, x, y, z, '0']
  {
    debug("Refreshing cache on letter: '" + wrap(p, COLOR_ITEM) + "'");
    visit_url('questlog.php?which=6&vl=' + p + '&filter=0');
  }
  log("Cache updated.");
}

location[int] empty_locations()
{
  int idx = 0;
  location[int] empty;
  boolean[monster] mon_list = manuel_monster_list();

  foreach l in $locations[]
  {
    int max = 0;
    int cur = 0;
    foreach m in get_location_monsters(l)
    {
      if (mon_list contains m)
      {
        max += 3;
        cur += monster_factoids_available(m, true);
      }
    }
    if (cur == 0 && max > 0)
    {
      empty[idx] = l;
      idx++;
    }
  }
  sort empty by random(10000);
  return empty;
}

location[int] juicy_locations(int max)
{
  boolean[monster] mon_list = manuel_monster_list();

  location[int] juicy;
  foreach l in $locations[]
  {
    float max = 0;
    float cur = 0;
    foreach m in get_location_monsters(l)
    {
      if (mon_list contains m)
      {
        max += 3;
        cur += monster_factoids_available(m, true);
      }
    }
    if (max == 0) continue;
    float actual = cur/max;

    if (actual < 1)
    {
      int idx = 10000 - (actual * 10000);
      while (juicy contains idx)
      {
        idx++;
      }
      juicy[idx] = l;
    }
  }

  location[int] ret;
  int idx = 0;
  foreach loc in juicy
  {
    ret[idx] = juicy[loc];
    idx++;
    if (idx >= max) return ret;
  }
  return ret;
}

void progress_manuel_location(location loc)
{
  boolean[monster] mon_list = manuel_monster_list();
  boolean[monster] loc_mons = get_location_monsters(loc);

  monster target = $monster[none];
  int target_num = 0;
  int max = 0;
  int cur = 0;

  foreach mon in loc_mons
  {
    if (mon_list contains mon)
    {
      max += 3;
      int facts = monster_factoids_available(mon, true);
      cur += facts;
      if (facts == 3) continue;
      if (facts >= target_num)
      {
        target_num = facts;
        target = mon;
      }
    }
  }
  progress(cur, max, "Progress on factiods in " + wrap(loc) + " (consider fighting " + wrap(target) + ")");
}

void progress_manuel()
{
  int[int] fact_set;

  fact_set[0] = 0;
  fact_set[1] = 0;
  fact_set[2] = 0;
  fact_set[3] = 0;
  boolean[monster] mon_list = manuel_monster_list();

  foreach m in $monsters[]
  {
    if (mon_list contains m)
    {
      fact_set[monster_factoids_available(m, true)]++;
    }
  }

  int total = 0;
  for x from 0 to 3
  {
    total += fact_set[x];
  }

  progress(fact_set[0], total, "Monsters with no factoids");
  progress(fact_set[1], total, "Monsters with one factoids");
  progress(fact_set[2], total, "Monsters with two factoids");
  progress(fact_set[3], total, "Monsters with all factoids");
}

void main()
{
  log("A few suggestions to help fill out your " + wrap($item[monster manuel]));
  log("");
//  update_monster_cache();

  progress_manuel();

  string empty_locs;
  string juicy_locs;

  location[int] empty_list = empty_locations();
  location[int] juicy_list = juicy_locations(4);
  for x from 0 to 3
  {
    if (count(empty_list) > x)
      empty_locs = list_add(empty_locs, wrap(empty_list[x]));
  }
  log("");
  log("Some locations that you're close to having all the factoids for:");
  foreach idx, loc in juicy_list
  {
    progress_manuel_location(loc);
  }

  log("");
  log("Some locations that you have no factoids for. May have to do some research on how to get to these (click location to view wiki on them for tips): " + empty_locs);
}
