import "util/print.ash";
import "util/effects.ash";
import "util/inventory.ash";
import "util/maximize.ash";
import "util/util.ash";
import "util/heart.ash";
import "util/prep/sell.ash";
import "util/prep/buy.ash";
import "util/prep/make.ash";
import "util/prep/pulverize.ash";
import "util/prep/use.ash";
import "util/iotm/floundry.ash";
import "util/iotm/bookshelf.ash";

void meat_cast(skill sk, effect ef, int avg)
{

  if (!have_skill(sk))
    return;

  if (turns_per_cast(sk) == 0)
    return;

  if (have_effect(ef) == 0)
  {
    float sk_cost = (mp_cost(sk)*1.0) / turns_per_cast(sk);
    if (sk_cost * cost_per_mp() < avg)
    {
      log("Cost to cast " + wrap(sk) + " seems cost effective here. Meat avg gain: " + avg + ", cost avg: " + sk_cost * cost_per_mp() + ".");
      use_skill(sk);
    }
  }

}

void cast_meat_spells(location loc)
{
  if (loc == $location[none])
    return;

  float avg_meat = avg_meat_per_adv(loc);

  float meat_pct = avg_meat * 0.01;

  meat_cast($skill[The Polka of Plenty], $effect[Polka of Plenty], meat_pct * 50);
}

void item_cast(skill sk)
{
  effect ef = to_effect(sk);
  if (!have_skill(sk))
    return;

  if (have_effect(ef) == 0)
  {
    log("Casting " + wrap(sk) + ".");
    use_skill(sk);
  }
}

void cast_item_spells(location loc)
{
  foreach l in $locations[tower level 1, tower level 2, tower level 3, tower level 4, none]
  {
    if (l == loc)
      return;
  }

  item_cast($skill[Fat Leon's Phat Loot Lyric]);
}

void prep_turtle_tamer()
{
  effect_maintain($effect[Eau de Tortue]);
}

void class_specific_prep(class cl)
{
  switch(cl)
  {
    case $class[turtle tamer]:
      prep_turtle_tamer();
      break;
  }

}

void consider_mall(item it)
{
  if (item_amount(it) == 0)
    return;

  log("You may want to give this to your clan, or maybe put in the mall: " + wrap(it) + ".");
  log("In the meantime, moving these to your closet until you decide.");
  put_closet(item_amount(it), it);
}

void mall_or_clan()
{
  consider_mall($item[almost-dead walkie-talkie]);
  consider_mall($item[gift card]);
  consider_mall($item[stuffed astral badger]);
  consider_mall($item[stuffed cheshire bitten]);
  // should check for stuffed treasure chest and open them when possible:
  consider_mall($item[stuffed key]);
  consider_mall($item[stuffed mink]);
  consider_mall($item[stuffed sleazy gravy fairy]);
}

void prep_fishing(location loc)
{
  if (is_fishing_hole(loc))
  {
    log("This location (" + wrap(loc) + ") may have floundry fish in it.");
    effect_maintain($effect[baited hook]);
  }
  if (can_get_floundry_item())
  {
    log("You should get an item from the " + wrap("Floundry", COLOR_LOCATION) + ".");
  }
}


void cast_things()
{
  // if it makes sense to cast another libram spell
  while(libram())
  {

  }
}


void prep(location loc)
{
  if (my_meat() > 300)
    hermit(999, $item[ten-leaf clover]);

  get_totem();
  get_saucepan();
  get_accordion();
  
  cast_things();
  pulverize_things();
  sell_things();
  buy_things();
  use_things();
  make_things();
  cast_meat_spells(loc);
  cast_item_spells(loc);
  class_specific_prep(my_class());
  prep_fishing(loc);
  mall_or_clan();
  if (setting("use_avatar_potions") == "")
  {
    save_setting("use_avatar_potions", "true");
  }
  if (setting("use_avatar_potions") == "true")
  {
    maintain_avatar();
  }
  heart();

}

void prep()
{
  prep($location[none]);
}


void main()
{
  prep();
}
