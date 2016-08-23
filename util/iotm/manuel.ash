import "util/print.ash";

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
