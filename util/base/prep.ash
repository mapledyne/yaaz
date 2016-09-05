import "util/base/print.ash";
import "util/base/effects.ash";
import "util/base/inventory.ash";
import "util/base/maximize.ash";
import "util/base/util.ash";
import "util/base/heart.ash";
import "util/base/consume.ash";
import "util/prep/sell.ash";
import "util/prep/buy.ash";
import "util/prep/make.ash";
import "util/prep/pulverize.ash";
import "util/prep/use.ash";
import "util/iotm/floundry.ash";
import "util/iotm/bookshelf.ash";
import "util/iotm/manuel.ash";
import "util/iotm/deck.ash";

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
}


void cast_things()
{

  while (have_skill($skill[ancestral recall]) && to_int(get_property("_ancestralRecallCasts")) < 10 && item_amount($item[blue mana]) > 0)
  {
    log("Casting " + wrap($skill[ancestral recall]) + " to get us a few more adventures.");
    use_skill(1, $skill[ancestral recall]);
  }

  // if it makes sense to cast another libram spell
  while(libram())
  {

  }
}


void prep(location loc)
{

  if (have_effect($effect[beaten up]) > 0)
    uneffect($effect[beaten up]);

  if (my_hp() < (my_maxhp() * 0.6))
    restore_hp(90);

  // should put more finesse here to just recover what we need...
  if (my_mp() < (my_maxmp() * 0.5))
    restore_hp(my_maxmp() * 0.6);

  cast_surplus_mp();

  if (my_meat() > 1000 && my_path() != "Nuclear Autumn")
    hermit(999, $item[ten-leaf clover]);

  get_totem();
  get_saucepan();
  get_accordion();

  if (to_int(setting("adventure_floor", "10")) > my_adventures())
  {
    if (!have_skill($skill[ancestral recall]))
    {
      cheat_deck("ancestral recall", "learn a skill for more adventures");
    } else
    {
      cheat_deck("ancestral recall", "get some " + wrap($item[blue mana]) + " for more adventures");
      cheat_deck("island", "get some " + wrap($item[blue mana]) + " for more adventures");
    }
  }

  cast_things(); // before consume() so we can cast ancestral recall if able.

  consume();

  pulverize_things();
  sell_things();
  buy_things();
  use_things();
  make_things();
  cast_meat_spells(loc);
  class_specific_prep(my_class());
  prep_fishing(loc);
  mall_or_clan();

  manuel();

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
