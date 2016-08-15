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
      put_closet(inventory[it], it);
    }
  }
  // if we already have an avatar potion active, bail.
  if (has_avatar_active())
  {
    return;
  }

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

  take_closet(1, avatar_potion);
  use(1, avatar_potion);

}

item effect_to_item(effect ef)
{
  switch(ef)
  {
    case $effect[adorable lookout]:     return $item[giraffe-necked turtle];
    case $effect[baited hook]:          return $item[wriggling worm];
    case $effect[balls of ectoplasm]:   return $item[ectoplasmic orbs];
    case $effect[black tongue]:         return $item[black snowcone];
    case $effect[blue tongue]:          return $item[blue snowcone];
    case $effect[Eau de Tortue]:        return $item[turtle pheromones];
    case $effect[Eau d'enmity]:         return $item[perfume of prejudice];
    case $effect[ermine eyes]:          return $item[eyedrops of the ermine];
    case $effect[eye of the seal]:      return $item[seal eyeball];
    case $effect[fresh scent]:          return $item[deodorant];
    case $effect[green tongue]:         return $item[green snowcone];
    case $effect[high colognic]:        return $item[musk turtle];
    case $effect[hippy stench]:         return $item[reodorant];
    case $effect[lustful heart]:        return $item[love song of naughty innuendo];
    case $effect[ocelot eyes]:          return $item[eyedrops of the ocelot];
    case $effect[orange tongue]:        return $item[orange snowcone];
    case $effect[peeled eyeballs]:      return $item[knob goblin eyedrops];
    case $effect[purple tongue]:        return $item[purple snowcone];
    case $effect[red tongue]:           return $item[red snowcone];
    case $effect[Rushtacean\']:         return $item[armored prawn];
    case $effect[Sepia Tan]:            return $item[old bronzer];
    case $effect[Spiro Gyro]:           return $item[programmable turtle];
    case $effect[Ticking Clock]:        return $item[cheap wind-up clock];
    case $effect[tortious]:             return $item[mocking turtle];
    case $effect[withered heart]:       return $item[love song of disturbing obsession];
    default:                            return $item[none];
  }
}

skill effect_to_skill(effect ef)
{
  return to_skill(ef);
}

void effect_maintain(effect ef)
{
  if (have_effect(ef) > 0)
    return;

  item it = effect_to_item(ef);
  skill sk = effect_to_skill(ef);

  if (sk == $skill[none] && it == $item[none])
  {
    error("Trying to maintain an effect (" + wrap(ef) + ") and can't find an appropriate skill or item.");
    return;
  }

  if (sk != $skill[none])
  {
    if (have_skill(sk))
    {
      log("Keeping up " + wrap(ef) + " by casting " + wrap(sk) + ".");
      use_skill(1, sk);
      return;
    }
  }

  if (it != $item[none])
  {
    // buy one if we need it and can afford it:
    if (item_amount(it) == 0)
    {
      if (is_npc_item(it))
      {
        int price = npc_price(it);
        if (price > 0 && price < my_meat()*10)
        {
          log("Buying " + wrap(it) + " to maintain " + wrap(ef));
          buy(1, it);
        }
      }
    }

    if (item_amount(it) > 0)
    {
      log("Keeping up " + wrap(ef) + " by using " + wrap(it) + ".");
      use(1, it);
      return;
    }
  }
}
