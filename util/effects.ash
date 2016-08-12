item effect_to_item(effect ef)
{
  switch(ef)
  {
    case $effect[adorable lookout]:     return $item[giraffe-necked turtle];
    case $effect[baited hook]:          return $item[wriggling worm];
    case $effect[Eau de Tortue]:        return $item[turtle pheromones];
    case $effect[Eau d'enmity]:         return $item[perfume of prejudice];
    case $effect[ermine eyes]:          return $item[eyedrops of the ermine];
    case $effect[eye of the seal]:      return $item[seal eyeball];
    case $effect[fresh scent]:          return $item[deodorant];
    case $effect[hippy stench]:         return $item[reodorant];
    case $effect[lustful heart]:        return $item[love song of naughty innuendo];
    case $effect[ocelot eyes]:          return $item[eyedrops of the ocelot];
    case $effect[peeled eyeballs]:      return $item[knob goblin eyedrops];
    case $effect[Rushtacean\']:         return $item[armored prawn];
    case $effect[Sepia Tan]:            return $item[old bronzer];
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
