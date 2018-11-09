import "util/base/yz_print.ash";
import "util/base/yz_consume.ash";
import "util/base/yz_quests.ash";
import "util/base/yz_util.ash";
import "special/skills/yz_rethinkcandy.ash";

item effect_to_item(effect ef)
{
  item def = $item[none];
  foreach action in ef.all
  {
    // sadly can't seem to do this in the list itself
    boolean[string] tests;

    tests[substring(action, 4)] = true; // 'use ...'
    tests[substring(action, 6)] = true; // 'use 1 ...' (and 'eat 1 ...'')
    tests[substring(action, 7)] = true; // 'chew 1 ...'
    tests[substring(action, 8)] = true; // 'drink 1 ...'

    foreach maybe in tests {
      item it = to_item(maybe);

      if (it != $item[none])
      {
        if (item_amount(it) > 0 || creatable_amount(it) > 0)
          return it;
          // setting def to something that can cause the effect at least allows
          // us to use this as a lookup, even if we don't have the item. Still,
          // if multiple items create the effect (sugar rush being the biggest?)
          // function should continue to loop and find something we have, if any.
        def = it;
      }

    }
  }

  // exceptions that mafia seems to miss:
  if (ef == $effect[sugar rush] && item_amount($item[stick of &quot;gum&quot;]) > 0)
    return $item[stick of &quot;gum&quot;];

  if (ef == $effect[thanksgetting])
  {
    foreach it in $items[candied sweet potatoes,
                         green bean casserole,
                         baked stuffing,
                         cranberry cylinder,
                         thanksgiving turkey,
                         mince pie,
                         mashed potatoes,
                         warm gravy,
                         bread roll]
    {
      if (it == $item[baked stuffing] && quest_status("questL12War") != FINISHED) continue;
      if (it == $item[warm gravy] && quest_status("questL07Cyrptic") != FINISHED) continue;

      if (item_amount(it) > 0 || creatable_amount(it) > 0)
        return it;
    }
  }


  return def;
}

skill effect_to_skill(effect ef)
{
  return to_skill(ef);
}

int demon_effect_to_int(effect ef)
{
  int summon = 0;
  switch (ef)
  {
    case $effect[Preternatural Greed]:
      summon = 2;
      break;
    case $effect[speed of the internet]:
      if (my_level() != 13) return 0;
      // intentionally falling through to Jacked In...
    case $effect[jacked in]:
      summon = 12;
      break;
    default:
      warning("This effect: " + wrap(ef) + " doesn't seem to be a demon effect, but we tried anyway.");
      return 0;
  }
  string name = get_property("demonName" + summon);
  if (name == "") return 0;

  return summon;
}

boolean demon_effect(effect ef)
{
  return $effects[Preternatural Greed,
                  jacked in,
                  speed of the internet] contains ef;
}

void try_summon_demon(effect ef)
{
  if (to_boolean(get_property("demonSummoned"))) return;
  if (quest_status("questL11Manor") != FINISHED) return;

  if (item_amount($item[thin black candle]) < 3) return;
  if (item_amount($item[scroll of ancient forbidden unspeakable evil]) < 1) return;
  int summon = demon_effect_to_int(ef);
  if (summon == 0) return;

  familiar current_fam = my_familiar();

  if (summon == 12)
  {
    if (!have_familiar($familiar[intergnat])) return;
    use_familiar($familiar[intergnat]);
  }
  log("Summoning a demon to get us " + wrap(ef) + ".");
  boolean b = cli_execute("summon " + summon);
  if (summon == 12)
  {
    use_familiar(current_fam);
  }
  if (!b)
  {
    debug("Tried to summon but failed. This happens (rarely) with demon12 for some reason where mafia thinks we have the name, but we actually don't.");
    if (summon != 12)
    {
      debug("We were summoning demon " + summon + ", so I don't know what the problem was.");
    } else {
      set_property("demonName12", "");
    }
  }
}


void effect_maintain(effect ef, boolean use_turns)
{
  if (have_effect(ef) > 0)
    return;

  if (demon_effect(ef))
  {
    try_summon_demon(ef);
    return;
  }

  item it = effect_to_item(ef);
  skill sk = effect_to_skill(ef);

  if (sk == $skill[none] && it == $item[none])
  {
    if (is_synthesis_effect(ef))
    {
      if (do_synthesis(ef)) return;
    }

    error("Trying to add an effect (" + wrap(ef) + ") and can't find an appropriate skill or item.");
    return;
  }

  if (sk != $skill[none])
  {
    if (!have_skill(sk)) return;

    if (have_effect($effect[temporary amnesia]) > 0)
    {
      info("I want to cast " + wrap(sk) + ", but I have " + wrap($effect[temporary amnesia]) + ", so can't right now.");
      return;
    }
    if (is_turtle_buff(sk) && !have($item[turtle totem])) return;
    log("Adding effect " + wrap(ef) + " by casting " + wrap(sk) + ".");
    if (is_thief_buff(ef))
    {
      if (!can_cast_song())
      {
        uneffect_song();
      }
    }
    use_skill(1, sk);
    return;
  }

  if (it != $item[none])
  {
    if (!be_good(it)) return;
    if (!can_consume(it)) return;

    if (it == $item[The Inquisitor's unidentifiable object]
        && to_boolean(setting("inquisitor_chewed", "false")))
    {
      return;
    }


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
      if (
        creatable_amount(it) > 0 &&
        (
          use_turns ||
          creatable_turns(it, 1, true) == 0
        )
      ) {
        log("Creating " + wrap(it) + " to maintain " + wrap(ef));
        create(1, it);
      }
    }

    if (item_amount(it) > 0)
    {
      log("Adding effect " + wrap(ef) + " by consuming " + wrap(it) + ".");
      try_consume(it);
      return;
    }
  }
}

void effect_maintain(effect ef) {
  effect_maintain(ef, false);
}

void cast_surplus_mp()
{
  if (have_effect($effect[temporary amnesia]) > 0)
  {
    info("I have " + wrap($effect[temporary amnesia]) + ", so can't right use up surplus MP right now.");
    return;
  }

  if (my_mp() < (my_maxmp() * 0.9)) return;

  effect[int] effect_list;
  int count = 0;

  foreach ef in $effects[astral shell,
                         ear winds,
                         earthen fist,
                         elemental saucesphere,
                         Empathy,
                         Fat Leon's Phat Loot Lyric,
                         ghostly shell,
                         Hardened Sweatshirt,
                         Impeccable Coiffure,
                         Juiced and Loose,
                         mind vision,
                         mariachi mood,
                         pasta oneness,
                         patience of the tortoise,
                         polka of plenty,
                         reptilian fortitude,
                         retrograde relaxation,
                         Salamanderenity,
                         seal clubbing frenzy,
                         scarysauce,
                         snarl of the timberwolf,
                         springy fusilli,
                         tenacity of the snapper,
                         ur-kel's aria of annoyance,
                         Drescher's Annoying Noise]
  {
    if (have_skill(effect_to_skill(ef)))
    {
      effect_list[count] = ef;
      count += 1;
    }
  }

  sort effect_list by have_effect(value);

  foreach ef in effect_list
  {
    if(my_mp() < (my_maxmp() * 0.9))
      break;
    skill sk = to_skill(effect_list[ef]);
    if (is_turtle_buff(sk) && !have($item[turtle totem]))
      continue;
    if (is_thief_buff(sk) && !have($item[stolen accordion]))
      continue;
    if (is_sauceror_buff(sk) && !have($item[saucepan]))
      continue;
    log("Casting " + wrap(sk) + " to use up surplus MP.");
    use_skill(1, sk);
  }
}
