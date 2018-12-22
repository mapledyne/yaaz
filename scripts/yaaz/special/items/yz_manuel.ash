import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_inventory.ash";

boolean manuel_exclude_monster(monster mon)
{
  if ($monsters[X-32-F Combat Training Snowman] contains mon)
    return true;
  return false;
}

void manuel_add_location(location loc)
{
  string locs = setting("manuel_locations");
  locs = list_add(locs, loc, "•");
  save_daily_setting("manuel_locations", locs);
}

boolean have_manuel()
{
  boolean have;
  if (setting("have_manuel") == "")
  {
    have = (visit_url("questlog.php?which=6").contains_text( "[Monster Manuel]"));
    save_daily_setting("have_manuel", have);
  }
  else
    have = to_boolean(setting("have_manuel"));

  return have;
}

boolean lame_avatar(item it) {
    return $items[blob of acid, flayed mind, kobold kibble, Fitspiration&trade; poster, giant tube of black lipstick, punk patch, artisanal hand-squeezed wheatgrass juice, steampunk potion,
    Gearhead Goo, Enchanted Plunger, Enchanted Flyswatter, Missing Eye Simulation Device, Gnollish Crossdress, gamer slurry]
        contains it;
}

boolean is_avatar_potion( item it )
{
    return it.effect_modifier( "Effect" ).string_modifier( "Avatar" ) != "";
}

boolean has_avatar_active()
{

  if(my_path() == "Avatar of West of Loathing") return true;

  if(have_effect($effect[Juiced and Jacked]) > 0) {
      return true;
  }
  int [effect] currentEffects = my_effects(); // Array of current active effects
  foreach buff in currentEffects{
    if (buff.string_modifier( "Avatar" ) != "")
    {
      return true;
    }
  }
  return false;
}

void maintain_avatar()
{
  int[item] inventory = get_inventory() ;
  foreach it in inventory
  {
    if (is_avatar_potion(it))
    {
      if (closet_amount(it) < 5)
      {
        int qty = min(inventory[it], 5 - closet_amount(it));
        log("Putting " + qty + " " + wrap(it, qty) + " into the closet to reduce clutter.");
        put_closet(qty, it);
      } else {
        stash(it, 0);
      }
    }
  }
  // if we already have an avatar potion active, bail.
  if (has_avatar_active())
    return;

  // if we're boring and don't want to use them, bail. Boring players are boring. :)
  if (setting("no_avatar_potions") == "true")
    return;

  item[int] potions;
  int count = 0;
  foreach it in $items[]
  {
    if (is_avatar_potion(it))
    {
      if (closet_amount(it) > 0 && !lame_avatar(it))
      {
        potions[count] = it;
        count += 1;
      }
    }
  }
  if (count( potions ) == 0)
  {
    return;
  }

  item avatar_potion = $item[none];

  if (count( potions ) == 1)
  {
    avatar_potion = potions[0];
  } else {
    avatar_potion = potions[random(count(potions))];
  }

  log("Taking " + wrap(avatar_potion) + " out of the closet to play dress-up.");
  take_closet(1, avatar_potion);
  use(1, avatar_potion);

}

monster[int] manuel_monsters(location loc)
{
  monster[int] mons = get_monsters(loc);
  monster[int] cleaned;
  foreach m in mons
  {
    if (!manuel_exclude_monster(mons[m]))
      cleaned[m] = mons[m];
  }
  return cleaned;
}

int manuel_location_max(location loc)
{
  return count(manuel_monsters(loc)) * 3;
}

int manuel_location(location loc)
{
  monster[int] mons = manuel_monsters(loc);
  int facts = manuel_location_max(loc);
  int have = 0;

  if (facts == 0)
    return 0;

  if (to_int(setting("factoids_" + loc, "0")) == facts)
  {
    return facts;
  }

  foreach m in mons
  {
    have += monster_factoids_available(mons[m], false);
  }
  save_daily_setting("factoids_" + loc, have);
  return have;
}

void manuel_progress(location loc)
{
  if (loc == $location[none])
    return;
  if (!have_manuel())
    return;

  int max = manuel_location_max(loc);
  if (max == 0)
    return;

  int have = manuel_location(loc);
  if (setting("manuel_always_show_progress") != "true" && (have == max))
    return;

  progress(have, max, "Monster Manuel factoids from " + loc);
}

void manuel_progress()
{
  string[int] locs = split_string(setting("manuel_locations"), "•");
  foreach i in locs
  {
    location l = to_location(locs[i]);
    manuel_progress(l);
  }

  // clear list
  save_daily_setting("manuel_locations", "");
}

void manuel()
{
  maintain_avatar();
}

void main()
{
  manuel();
}
