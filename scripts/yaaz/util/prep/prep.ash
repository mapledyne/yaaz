import "util/base/print.ash";
import "util/base/effects.ash";
import "util/base/inventory.ash";
import "util/base/maximize.ash";
import "util/base/util.ash";
import "util/heart.ash";
import "util/base/consume.ash";
import "util/prep/sell.ash";
import "util/prep/buy.ash";
import "util/prep/clan.ash";
import "util/prep/make.ash";
import "util/prep/pulverize.ash";
import "util/prep/use.ash";
import "util/prep/closet.ash";
import "special/special_check_often.ash";
import "special/locations/vip_floundry.ash";
import "special/items/deck.ash";
import "special/items/manuel.ash";

import <zlib.ash>


void prep_turtle_tamer()
{
  effect_maintain($effect[Eau de Tortue]);
}

boolean valid_thrall(thrall slave)
{
  skill sk = thrall_to_skill(slave);
  if (!have_skill(sk)) return false;
  if (my_maxmp() < mp_cost(sk)) return false;
  return true;
}

void bind_thrall(thrall slave)
{
  if (my_thrall() == slave)
    return;
  skill sk = thrall_to_skill(slave);
  if (sk != $skill[none])
  {
    log("Binding a " + wrap(slave) + " to our will.");
    use_skill(1, sk);
  }
}

void prep_pastamancer(location loc)
{

  if (valid_thrall($thrall[lasagmbie])
      && (loc == $location[the themthar hills]
          || loc == $location[tower level 2]))
  {
    bind_thrall($thrall[lasagmbie]);
    return;
  }

  foreach slave in $thralls[spice ghost, angel hair wisp, vermincelli, spaghetti elemental, vampieroghi, lasagmbie, penne dreadful, elbow macaroni]
  {
    if (valid_thrall(slave))
    {
      bind_thrall(slave);
      return;
    }
  }
  log("You're a " + wrap(my_class()) + ", but you don't have any thrall skills. Go learn one!");

}

void class_specific_prep(class cl, location loc)
{
  switch(cl)
  {
    case $class[turtle tamer]:
      prep_turtle_tamer();
      break;
    case $class[pastamancer]:
      prep_pastamancer(loc);
      break;
  }

}

void prep_fishing(location loc)
{
  if (is_fishing_hole(loc))
  {
    log("This location (" + wrap(loc) + ") may have floundry fish in it.");
    effect_maintain($effect[baited hook]);
  }
}

void cast_things(location loc)
{

  // Things we may as well use. Low cost and sometimes helpful:
  effect_maintain($effect[bloodstain-resistant]);

  effect_maintain($effect[Neuroplastici Tea]);
  effect_maintain($effect[flexibili Tea]);
  effect_maintain($effect[Physicali Tea]);

  while (have_skill($skill[ancestral recall]) && to_int(get_property("_ancestralRecallCasts")) < 10 && have($item[blue mana]))
  {
    log("Casting " + wrap($skill[ancestral recall]) + " to get us a few more adventures.");
    use_skill(1, $skill[ancestral recall]);
  }


  // Way of the Surprising Fist
  effect_maintain($effect[Salamanderenity]);

  if (have_skill($skill[flavour of magic]))
  {
    element el = $element[none];
    foreach key, mon in get_monsters(loc)
    {
      if (mon.defense_element != $element[none])
        el = mon.defense_element;
    }

    // a few exceptions:
    switch(loc)
    {
  		case $location[The Ancient Hobo Burial Ground]:
  			el = $element[none];
  			break;
  		case $location[The Ice Hotel]:
  			if(get_property("walfordBucketItem") == "rain" && have_equipped($item[Walford's bucket]))
  				el = $element[spooky]; // Doing 100 hot damage in a fight will fill the bucket faster
  			// Lack of break is intentional
  		case $location[VYKEA]:
  			if(get_property("walfordBucketItem") == "ice" && have_equipped($item[Walford's bucket]))
  				el = $element[sleaze]; // It will do 1 damage unless you change their element somehow, but doing 10 cold damage speeds filling the bucket
  			break;
    }
    skill target = $skill[none];

    switch (el)
    {
      case $element[none]:
        if (!have_flavour_of_magic() && loc != $location[The Ancient Hobo Burial Ground])
        {
          log("You have " + wrap("Flavour of Magic", COLOR_SKILL) + ". Firing up some taste!");
          use_skill(1, $skill[spirit of garlic]);
        }
        if (loc == $location[The Ancient Hobo Burial Ground] && have_flavour_of_magic())
        {
          log("Everything in " + wrap($location[The Ancient Hobo Burial Ground]) + " is immune to elemental damage, so turning " + wrap($skill[flavour of magic]) + " off.");
          use_skill(1, $skill[spirit of nothing]);
        }
        break;
      case $element[hot]:
        target = $skill[spirit of garlic];
        break;
      case $element[cold]:
        target = $skill[spirit of wormwood];
        break;
      case $element[sleaze]:
        target = $skill[spirit of peppermint];
        break;
      case $element[spooky]:
        target = $skill[spirit of cayenne];
        break;
      case $element[stench]:
        target = $skill[spirit of bacon grease];
        break;
    }
    if (target != $skill[none] && have_effect(to_effect(target)) == 0)
    {
      log("Changing up your " + wrap("Flavour of Magic", COLOR_SKILL) + " to better suit where you're heading. Casting " + wrap(target) + ".");
      use_skill(1, target);
    }
  }

// currently disabled until smarter methodology can be used to decide when to do this:
  if (my_meat() > 10000
      && my_level() < 13
      && false)
  {
    // limiter on this so we don't cause MP restores to use up all of our meat.

    effect_maintain($effect[Drescher's Annoying Noise]);
    effect_maintain($effect[Ur-Kel's Aria of Annoyance]);
  }
}

void cast_if(skill sk, boolean doit)
{
  if (!doit) return;
  if (!have_skill(sk)) return;
  if (!be_good(sk)) return;

  if (my_mp() < (mp_cost(sk) * 5)) return; // wait until we have an MP buffer

  use_skill(1, sk);
}

void cast_one_time_things()
{
  cast_if($skill[Advanced Cocktailcrafting], to_int(get_property("cocktailSummons")) == 0);
  cast_if($skill[Advanced Saucecrafting], to_int(get_property("reagentSummons")) == 0);
  cast_if($skill[Pastamastery], to_int(get_property("noodleSummons")) == 0);
  cast_if($skill[summon crimbo candy], to_int(get_property("_candySummons")) == 0);
  cast_if($skill[Perfect Freeze], !to_boolean(get_property("perfectFreezeUsed")));
  cast_if($skill[Summon Holiday Fun!], !to_boolean(get_property("_holidayFunUsed")));
}

void prep(location loc)
{
 if (my_path() != "Actually Ed the Undying")
 {
   if (have_effect($effect[beaten up]) > 0)
     uneffect($effect[beaten up]);

   if (my_hp() < (my_maxhp() * 0.75))
   {
     log("Restoring health...");
     restore_hp(my_maxhp() * 0.9);
   }

   // should put more finesse here to just recover what we need...
   if (my_mp() < (my_maxmp() * 0.5))
   {
     log("Restoring MP...");
     restore_mp(my_maxmp() * 0.6);
   }

 }

  while (my_meat() > 1000
      && setting("hermit_complete") != "true"
      && setting("no_clover") != "true"
      && my_path() != "Nuclear Autumn")
  {

    while ($coinmaster[hermit].available_tokens == 0)
    {
      if (!have($item[chewing gum on a string]))
        buy(1, $item[chewing gum on a string]);
      use(1, $item[chewing gum on a string]);
    }
    int qty = total_clovers();

    boolean gotcha = hermit(1, $item[ten-leaf clover]);
    if (!gotcha || qty == total_clovers())
    {
      save_daily_setting("hermit_complete", "true");
    }
  }
  get_totem();
  get_saucepan();
  get_accordion();

  cast_one_time_things();
  cast_surplus_mp();

  consume();

  if (to_int(setting("adventure_floor", "10")) > my_adventures())
  {
    if (hippy_stone_broken())
    {
      cheat_deck("clubs", "more PvP");
    }
    if (!have_skill($skill[ancestral recall]))
    {
      cheat_deck("ancestral recall", "learn a skill for more adventures");
    } else
    {
      cheat_deck("ancestral recall", "get some " + wrap($item[blue mana]) + " for more adventures");
      cheat_deck("island", "get some " + wrap($item[blue mana]) + " for more adventures");
    }
  }

  heart();

  special_check_often();

  cast_things(loc);

  pulverize_things();
  sell_things();
  buy_things();
  make_things();
  use_things();
  closet_things();
  clan_things();
  class_specific_prep(my_class(), loc);
  prep_fishing(loc);

  if (have($item[screencapped monster])
      && my_adventures() > 3
      && my_inebriety() <= inebriety_limit())
  {
    cli_execute("checkpoint");
    maximize();
    use(1, $item[screencapped monster]);
    cli_execute("outfit checkpoint");
  }

  manuel();

  maybe_pull($item[disassembled clover], 3);

  if (have_effect($effect[majorly poisoned]) > 0)
    uneffect($effect[majorly poisoned]);


  // auto_mcd() seems to be way too easy on us and sets it to 0 more than I'd like.
  //  if (loc != $location[none]) auto_mcd(loc);

  if (!($locations[the boss bat's lair,
                   Haert of the Cyrpt,
                   Throne Room] contains loc))
  {
    int annoy = 10;
    if (canadia_available()) annoy = 11;
    if (current_mcd() != annoy)
      change_mcd(annoy);
  }

}

void prep()
{
  prep($location[none]);
}


void main()
{
  prep();
}
