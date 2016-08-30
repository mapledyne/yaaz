import "util/base/print.ash";
import "util/base/util.ash";


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
      log("Putting " + wrap(it) + " into the closet to reduce clutter.");
      put_closet(inventory[it], it);
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

int manuel_location_max(location loc)
{
  monster[int] mons = get_monsters(loc);
  return count(mons) * 3;
}

int manuel_location(location loc)
{
  monster[int] mons = get_monsters(loc);
  int facts = manuel_location_max(loc);
  int have = 0;

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
  if (!have_manuel())
    return;

  int max = manuel_location_max(loc);
  int have = manuel_location(loc);
  if (have == max)
    return;

  progress(have, max, "Monster Manuel factoids from " + loc);
}

void manuel()
{
  maintain_avatar();
}

void main()
{
  manuel();
}
