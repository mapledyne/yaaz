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

familiar choose_familiar_from_list(boolean[familiar] fams)
{
  foreach f in fams
  {
    if(have_familiar(f))
    {
      return f;
    }
  }
  return $familiar[none];
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
    case "":
    case "rollover":
    case "stats":
      newbie = choose_familiar_from_list($familiars[rockin\' robin, hovering sombrero, blood-faced volleyball, penguin goodfella, ancient yuletide troll, baby bugged bugbear, smiling rat, happy medium, lil\' barrel mimic]);
      break;
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
      error("Tried to choose familiar for '" + fam + "', but I don't understand that.");
  }

  if (newbie == $familiar[none] && fam != "stats")
    newbie = choose_familiar("stats");

  if (newbie == $familiar[none] && fam != "items")
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

void do_maximize(string target, string outfit, item it)
{
  string max = target;
  if (outfit != "")
  {
    if (max != "")
    {
      max = max + ", ";
    }
    max = max + "outfit " + outfit;
  }

  if (it != $item[none])
  {
    if (max != "")
    {
      max = max + ", ";
    }
    max = max + "+equip " + it;
  }

  maximize(max, false);
}

void max_default(string outfit, item it)
{
  do_maximize("mainstat, 0.4 hp  +effective, mp regen, +shield", outfit, it);
}

void max_ml(string outfit, item it)
{
  do_maximize("ml", outfit, it);
}

void max_noncombat(string outfit, item it)
{
  do_maximize("-combat", outfit, it);
  effect_maintain($effect[Smooth Movements]);
  effect_maintain($effect[The Sonata of Sneakiness]);
}

void max_items(string outfit, item it)
{
  do_maximize("items", outfit, it);
  get_accordion();
  effect_maintain($effect[Fat Leon's Phat Loot Lyric]);
}

void max_init(string outfit, item it)
{
  do_maximize("init", outfit, it);
  effect_maintain($effect[Sepia Tan]);
  effect_maintain($effect[Walberg\'s Dim Bulb]);
  effect_maintain($effect[Springy Fusilli]);
  effect_maintain($effect[Song of Slowness]);

  // will silently skip if this can't be bought.
  effect_maintain($effect[Ticking Clock]);
}

void max_rollover(string outfit, item it)
{
  do_maximize("adv, pvp fights", outfit, it);
}

void maximize(string target, string outfit, item it, familiar fam)
{
  if (fam != $familiar[none])
    equip_familiar(fam);
  else
    choose_familiar(target);


  switch(target)
  {
    case "":
      max_default(outfit, it);
      break;
    case "items":
      max_items(outfit, it);
      break;
    case "init":
      max_init(outfit, it);
      break;
    case "noncombat":
      max_noncombat(outfit, it);
      break;
    case "ml":
      max_ml(outfit, it);
      break;
    case "rollover":
      max_rollover(outfit, it);
      break;
    default:
      warning("Tried to maximize '" + target+ "', but I don't understand that.");
  }
}

void maximize(string target, item it)
{
  maximize(target, "", it, $familiar[none]);
}

void maximize(string target, string outfit, familiar fam)
{
  maximize(target, outfit, $item[none], fam);
}

void maximize(string target, familiar fam)
{
  maximize(target, "", fam);
}

void maximize(string target, string outfit)
{
  maximize(target, outfit, $familiar[none]);
}

void maximize(string target)
{
  maximize(target, "");
}
