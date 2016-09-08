import "util/base/print.ash";
import "util/base/consume.ash";

item effect_to_item(effect ef)
{
  item def = $item[none];
  foreach action in ef.all
  {
    if (contains_text(action, "use 1 "))
    {
      item it = to_item(replace_string(action, "use 1 ", ""));
      if (item_amount(it) > 0)
        return it;

      // setting def to something that can cause the effect at least allows
      // us to use this as a lookup, even if we don't have the item. Still,
      // if multiple items create the effect (sugar rush being the biggest?)
      // function should continue to loop and find something we have, if any.
      def = it;
    }
  }

  // exception that mafia seems to miss:
  if (ef == $effect[sugar rush] && item_amount($item[stick of &quot;gum&quot;]) > 0)
    return $item[stick of &quot;gum&quot;];

  return def;
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
    error("Trying to add an effect (" + wrap(ef) + ") and can't find an appropriate skill or item.");
    return;
  }

  if (sk != $skill[none])
  {
    if (have_skill(sk))
    {
      log("Adding effect " + wrap(ef) + " by casting " + wrap(sk) + ".");
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
      log("Adding effect " + wrap(ef) + " by consuming " + wrap(it) + ".");
      try_consume(it);
      return;
    }
  }
}

boolean uneffect(effect ef)
{
	if(have_effect(ef) == 0)
		return true;

	if(cli_execute("uneffect " + ef))
		return true;

	if(item_amount($item[Soft Green Echo Eyedrop Antidote]) > 0)
	{
    log("Removing the effect " + wrap(ef) + " with a " + wrap($item[Soft Green Echo Eyedrop Antidote]) + ".");
		visit_url("uneffect.php?pwd=&using=Yep.&whicheffect=" + to_int(ef));
		return true;
	}
	return false;
}

void cast_surplus_mp()
{
  if (my_mp() < (my_maxmp() * 0.8))
    return;

  effect[int] effect_list;
  int count = 0;

  foreach ef in $effects[polka of plenty,
                         Fat Leon's Phat Loot Lyric,
                         elemental saucesphere,
                         astral shell,
                         snarl of the timberwolf,
                         ghostly shell,
                         Empathy,
                         ear winds,
                         Impeccable Coiffure,
                         Juiced and Loose,
                         mind vision,
                         Hardened Sweatshirt]
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
    if(my_mp() < (my_maxmp() * 0.8))
      break;
    skill sk = to_skill(effect_list[ef]);
    log("Casting " + wrap(sk) + " to use up surplus MP.");
    use_skill(1, sk);
  }
}

boolean have_flavour_of_magic()
{
  foreach ef in $effects[spirit of cayenne,
                     spirit of garlic,
                     spirit of peppermint,
                     spirit of wormwood,
                     spirit of bacon grease]
   {
      if (have_effect(ef) > 0)
        return true;
   }
   return false;
}
