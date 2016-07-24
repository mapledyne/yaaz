import "util/print.ash";
import "util/inventory.ash";


void equip_familiar(familiar fam)
{
  if (my_familiar() == fam)
  {
    return;
  }

  if (!have_familiar(fam))
  {
    warning("Trying to switch to familiar " + wrap(fam) + " but you don't have this one.");
    warning("I don't know how this happened, so we're aborting.");
    abort();
  }
  log("Switching to familiar " + wrap(fam));
  use_familiar(fam);

}

familiar choose_familiar(string fam)
{
  familiar newbie = to_familiar(fam);

  if (newbie != $familiar[none])
  {
    equip_familiar(newbie);
    return newbie;
  }

  switch(fam)
  {
    case "init":
      foreach f in $familiars[Happy Medium, Xiblaxian Holo-Companion, Oily Woim]
      {
        if(have_familiar(f))
        {
          newbie = (f);
          break;
        }
      }
      break;
    case "items":
      foreach f in $familiars[Rockin\' Robin, Adventurous Spelunker, Grimstone Golem, Angry Jung Man, Bloovian Groose, Intergnat, Slimeling, Baby Gravy Fairy]
      {
        if(have_familiar(f))
        {
          newbie = (f);
          break;
        }
      }
      break;
    default:
      warning("Tried to choose familiar for '" + fam + "', but I don't understand that.");
  }

//  if (newbie == $familiar[none])
//    newbie = choose_familiar("stat");

  if (newbie == $familiar[none])
    newbie = choose_familiar("items");

  if (newbie == $familiar[none])
    newbie = choose_familiar("mosquito");

  equip_familiar(newbie);
  return newbie;
}

item effect_to_item(effect ef)
{
  switch(ef)
  {
    case $effect[Eau de Tortue]:  return $item[turtle pheromones];
    case $effect[Rushtacean\']:   return $item[armored prawn];
    case $effect[Sepia Tan]:      return $item[old bronzer];
    case $effect[Ticking Clock]:  return $item[cheap wind-up clock];
    default:                      return $item[none];
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

void max_default()
{
  maximize("mainstat, 0.4 hp  +effective, mp regen, +shield", false);
}

void max_ml()
{
  maximize("ml", false);
}

void max_noncombat()
{
  maximize("-combat", false);
  effect_maintain($effect[Smooth Movements]);
  effect_maintain($effect[The Sonata of Sneakiness]);
}

void max_items()
{
  maximize("items", false);
  get_accordion();
  effect_maintain($effect[Fat Leon's Phat Loot Lyric]);
}

void max_init()
{
  maximize("init", false);
  effect_maintain($effect[Sepia Tan]);
  effect_maintain($effect[Walberg\'s Dim Bulb]);
  effect_maintain($effect[Springy Fusilli]);

  // will silently skip if this can't be bought.
  effect_maintain($effect[Ticking Clock]);

  effect_maintain($effect[Song of Slowness]);
}

void max_rollover()
{
  maximize("adv, pvp fights", false);
}

void maximize(string target)
{
  switch(target)
  {
    case "":
      max_default();
      break;
    case "items":
      max_items();
      break;
    case "init":
      max_init();
      break;
    case "noncombat":
      max_noncombat();
      break;
    case "ml":
      max_ml();
      break;
    case "rollover":
      max_rollover();
      break;
    default:
      warning("Tried to maximize '" + target+ "', but I don't understand that.");
  }
}
