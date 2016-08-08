import "util/print.ash";
import "util/inventory.ash";
import "util/maximize.ash";
import "util/util.ash";
import "util/prep/sell.ash";
import "util/prep/buy.ash";
import "util/prep/make.ash";
import "util/prep/pulverize.ash";
import "util/prep/use.ash";

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

void buy_things()
{
  stock_item($item[anti-anti-antidote], 3);

  stock_item($item[the big book of pirate insults]);
  if ((item_amount($item[dictionary]) + item_amount($item[abridged dictionary])) == 0)
  {
    stock_item($item[abridged dictionary]);
  }

  stock_item($item[gauze garter], 10 - item_amount($item[filthy poultice]));
  stock_item($item[filthy poultice], 10 - item_amount($item[gauze garter]));

  if (total_shadow_helpers() >= 10)
  {
    coinmaster master = $item[commemorative war stein].seller;
    int tokens = master. available_tokens;
    int qty = tokens / (sell_price(master, $item[commemorative war stein]));
    buy(master, qty, $item[commemorative war stein]);
  }
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

void prep(location loc)
{
  if (my_meat() > 300)
    hermit(999, $item[ten-leaf clover]);

  pulverize_things();
  sell_things();
  buy_things();
  use_things();
  make_things();
  cast_meat_spells(loc);
  cast_item_spells(loc);
  class_specific_prep(my_class());
}

void main()
{
  prep($location[none]);
}
