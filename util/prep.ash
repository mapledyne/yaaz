import "util/print.ash";
import "util/inventory.ash";
import "util/memento.ash";
import "util/maximize.ash";
import "util/util.ash";

float frequency_of_monster(location loc, monster mon)
{
  foreach mob, freq in appearance_rates(loc)
  {
    if (mob == mon)
    {
      return freq;
    }
  }
  warning("Looking for monster (" + wrap(mon) + ") frequency at " + wrap(loc) + ", but couldn't find monster.");
  return 0;
}

float avg_meat_per_adv(location loc)
{
  monster [int] monster_list = get_monsters(loc);
  float avg_meat = 0;
  int counter = 0;
  foreach i in monster_list {
     avg_meat += (meat_drop(monster_list[i]) * frequency_of_monster(loc, monster_list[i]) / 100);
  }
  return avg_meat;
}

float cost_per_mp()
{
  if (my_class() == $class[Pastamancer] || my_class() == $class[Sauceror] || (my_class() == $class[accordion thief] && my_level() >= 9))
  {
    // has access to MMJ
    int cost = npc_price($item[magical mystery juice]);
    float restore =  (1.5 * my_level()) + 5;
    return cost/restore;
  }
  return 17.5; // soda water
}

void meat_cast(skill sk, effect ef, int avg)
{

  if (!have_skill(sk))
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
  if (loc == $location[none])
    return;

  // if loc in ...... return; // (for loc that isn't worth upping items)

  item_cast($skill[Fat Leon's Phat Loot Lyric]);
}


void stock_item(item it, int qty)
{
  int total = qty - item_amount(it);
  int price = npc_price(it);
  int meat_buffer = 10;

  if (total <= 0 || price == 0)
    return;

  if ((price * total) < (my_meat() * meat_buffer))
  {
    buy(total, it);
  }

}

void stock_item(item it)
{
  stock_item(it, 1);
}

void buy_things()
{
  stock_item($item[anti-anti-antidote], 3);

  stock_item($item[the big book of pirate insults]);
  if ((item_amount($item[dictionary]) + item_amount($item[abridged dictionary])) == 0)
  {
    stock_item($item[abridged dictionary]);
  }

}

void use_things()
{
  use_all($item[black pension check]);
  use_all($item[shiny stones]);
  use_all($item[ancient vinyl coin purse]);
  use_all($item[bag of park garbage]);
  use_all($item[briefcase]);
  use_all($item[chest of the Bonerdagon]);
  use_all($item[collection of tiny spooky objects]);
  use_all($item[CSA discount card]);
  use_all($item[dungeon dragon chest]);
  use_all($item[duct tape wallet]);
  use_all($item[fat wallet]);
  use_all($item[kobold treasure hoard]);
  use_all($item[meat globe]);
  use_all($item[O'RLY manual]);
  use_all($item[orcish meat locker]);
  use_all($item[old coin purse]);
  use_all($item[old leather wallet]);
  use_all($item[very overdue library book]);
  use_all($item[warm subject gift certificate]);


  use_all($item[old eyebrow pencil]);
  use_all($item[old rosewater cream]);

  use_all($item[Squat-Thrust Magazine]);
  use_all($item[Ye Olde Bawdy Limerick]);

  use_all($item[Frobozz Real-Estate Company Instant House (TM)]);

  if (get_property("questL09Topping") == "unstarted" || get_property("questL09Topping") == "started")
  {
    use_all($item[smut orc keepsake box]);
  }

  if (item_amount($item[abridged dictionary]) > 0)
  {
    cli_execute("untinker abridged dictionary");
  }

  if (get_property("questL10Garbage") == "started" && item_amount($item[enchanted bean]) > 0)
  {
    use(1, $item[enchanted bean]);
  }

}

void sell_all(item it, int keep)
{
  int qty = item_amount(it) - keep;
  if (qty <= 0)
    return;
  log("Selling " + qty + " " + wrap(pluralize(item_amount(it), it), COLOR_ITEM));
  autosell(qty, it);
}

void sell_all(item it)
{
  sell_all(it, 0);
}

void sell_things()
{
  if (my_meat() < 5000)
    sell_all($item[1952 Mickey Mantle card]);

  sell_all($item[fat stacks of cash]);
  sell_all($item[dense meat stack]);
  sell_all($item[meat stack]);

  sell_all($item[Anticheese]);
  sell_all($item[Antique helmet]);
  sell_all($item[Antique spear]);
  sell_all($item[Awful Poetry Journal]);
  sell_all($item[Beach Glass Bead]);
  sell_all($item[Blue Pixel]);
  sell_all($item[Clay Peace-Sign Bead]);
  sell_all($item[Decorative Fountain]);
  sell_all($item[Empty Cloaca-Cola Bottle]);
  sell_all($item[Enchanted Barbell]);
  sell_all($item[Fancy Bath Salts]);
  sell_all($item[Frigid Ninja Stars]);
  sell_all($item[Giant Moxie Weed]);
  sell_all($item[Green Pixel]);
  sell_all($item[Half of a Gold Tooth]);
  sell_all($item[Imp Ale]);
  sell_all($item[Keel-Haulin\' Knife]);
  sell_all($item[Kokomo Resort Pass]);
  sell_all($item[Mad Train Wine]);
  sell_all($item[Margarita]);
  sell_all($item[Martini]);
  sell_all($item[Meat Paste]);
  sell_all($item[Mineapple]);
  sell_all($item[Moxie Weed]);
  sell_all($item[Patchouli Incense Stick]);
  sell_all($item[Phat Turquoise Bead]);
  sell_all($item[Photoprotoneutron Torpedo]);
  sell_all($item[Procrastination Potion]);
  sell_all($item[Ratgut]);
  sell_all($item[Red Pixel]);
  sell_all($item[Smelted Roe]);
  sell_all($item[Spicy Jumping Bean Burrito]);
  sell_all($item[Spicy Bean Burrito]);
  sell_all($item[Strongness Elixir]);
  sell_all($item[Sunken Chest]);
  sell_all($item[Tambourine Bells]);
  sell_all($item[Tequila Sunrise]);
  sell_all($item[Windchimes]);
  sell_all($item[valuable trinket]);


  sell_all($item[hot wing], 3);
}

void consider_chrome_item()
{
  // bail if we don't have the chrome ore
  if (item_amount($item[chrome ore]) == 0)
  {
    return;
  }
  item chrome_weapon;

  if (my_primestat() == $stat[mysticality])
    chrome_weapon = $item[chrome staff];
  if (my_primestat() == $stat[muscle])
    chrome_weapon = $item[chrome sword];
  if (my_primestat() == $stat[moxie])
    chrome_weapon = $item[chrome crossbow];

  // bail if we have one:
  if (item_amount(chrome_weapon) > 0)
    return;

  if (get_property("trapperOre") == "chrome ore")
  {
    if (get_property("questL08Trapper") == "unstarted" || get_property("questL08Trapper") == "step1")
    {
      // bail if we don't have surplus ore: trapper wants chrome ore and we haven't turned it in yet.
      if (i_a($item[chrome ore]) < 4)
      {
        return;
      }
    }
  }

  if (creatable_amount(chrome_weapon) == 0)
    return;

  if (my_meat() < 5000)
    return;

  // we have lots of adventures... or we're drunk:
  if ((my_adventures() < 20) && (my_inebriety() <= inebriety_limit()))
    return;

  create(1, chrome_weapon);
}

void make_things()
{
  // bricks of sand:
  if (item_amount($item[handful of sand]) >= 5)
  {
    log("Turning " + wrap("handfuls of sand", COLOR_ITEM) + " into " + wrap("bricks of sand", COLOR_ITEM) + ".");
    use_all($item[handful of sand]);
  }

  // palm frond fans:
  if (item_amount($item[palm frond]) > 1)
  {
    log("Turning " + wrap("palm fronds", COLOR_ITEM) + " into " + wrap("palm frond fans", COLOR_ITEM) + ".");
    while (item_amount($item[palm frond]) > 1)
    {
      use(2, $item[palm frond]);
    }
  }

  // Chrome items:
  consider_chrome_item();

  // Cobb Goblin cake
  if (creatable_amount($item[knob cake]) > 0 && get_property("questL05Goblin") != "finished")
  {
    create(1, $item[knob cake]);
  }

  if (creatable_amount($item[jar of oil]) > 0 && item_amount($item[jar of oil]) == 0 && bit_flag(get_property("twinPeakProgress").to_int(), 2))
  {
    create(1, $item[jar of oil]);
  }
}

void pulverize_things()
{

  if (!have_skill($skill[pulverize]))
    return;

  if (item_amount($item[tenderizing hammer]) == 0)
  {
    // don't do this unless we have surplus meat.
    if (my_meat() < 5000 && my_level() > 5)
      return;

    buy(1, $item[tenderizing hammer]);
  }


  // we may want some of these if not relying on muscle:
  if (my_primestat() != $stat[moxie])
  {
    pulverize_all($item[armgun]);
    pulverize_all($item[magilaser blastercannon]);
    pulverize_all($item[punk rock jacket]);
  }

  if (my_primestat() != $stat[muscle])
  {
    pulverize_all($item[wolf mask]);
    pulverize_all($item[giant safety pin]);
    pulverize_all($item[ridiculously huge sword]);
    pulverize_all($item[black sword]);
  } else {
    pulverize_all_but_one($item[wolf mask]);
    pulverize_all_but_one($item[giant safety pin]);
    pulverize_all_but_one($item[ridiculously huge sword]);
    pulverize_all_but_one($item[black sword]);
  }

  if (my_primestat() != $stat[mysticality])
  {
    pulverize_all($item[giant artisanal rice peeler]);
    pulverize_all($item[brown felt tophat]);
  }

  pulverize_all_but_one($item[little black book]);

  // may be useful for the peak.
  if (get_property("booPeakProgress") > 0)
  {
    pulverize_all_but_one($item[glowing red eye]);
  } else {
    pulverize_all($item[glowing red eye]);
  }

  // some more aggressive work if we aren't flush in wads:
  if (wad_total() < spleen_limit())
  {
    pulverize_all_but_one($item[twinkly nuggets]);
    pulverize_all_but_one($item[hot nuggets]);
    pulverize_all_but_one($item[cold nuggets]);
    pulverize_all_but_one($item[sleaze nuggets]);
    pulverize_all_but_one($item[spooky nuggets]);
    pulverize_all_but_one($item[stench nuggets]);
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

  save_mementos();
  buy_things();
  use_things();
  make_things();
  sell_things();
  pulverize_things();
  cast_meat_spells(loc);
  cast_item_spells(loc);
  class_specific_prep(my_class());
}

void main()
{
  prep($location[none]);
}
