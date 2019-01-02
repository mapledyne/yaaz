import "util/base/yz_inventory.ash";
import "util/base/yz_quests.ash";

import <zlib.ash>

void consider_chrome_item()
{
  // bail if we don't have the chrome ore
  if (!have($item[chrome ore])) return;

  item chrome_weapon;

  if (my_primestat() == $stat[mysticality])
    chrome_weapon = $item[chrome staff];
  if (my_primestat() == $stat[muscle])
    chrome_weapon = $item[chrome sword];
  if (my_primestat() == $stat[moxie])
    chrome_weapon = $item[chrome crossbow];

  if (!can_equip(chrome_weapon))
  {
    // sad, but these items aren't that useful outside of rollover, so
    // using the "wrong" one isn't that big a penalty. This will help us
    // occasionally since the staff is Mus 40 requirement and the sword
    // is Mus 35. (crossbow is Mox 45, but that's for Mox classes, so likely
    // won't get hit as often since that's their prime stat).

    if (can_equip($item[chrome sword]))
      chrome_weapon = $item[chrome sword];
  }
  // bail if we have any of them. This is to protect me since I have a habit
  // of making the wrong one when doing it manually, but that'll still
  // give us adventures:
  if (count_set($items[chrome staff,
                       chrome sword,
                       chrome crossbow,
                       carob cannon]) > 0) return;

  if (get_property("questL08Trapper") == "unstarted"
      || (get_property("questL08Trapper") == "step1"
          && get_property("trapperOre") == "chrome ore"))
  {
    // bail if we don't have surplus ore: trapper wants (or may want) chrome ore and we haven't turned it in yet.
    if (item_amount($item[chrome ore]) < 4)
    {
      return;
    }
  }

  if (creatable_amount(chrome_weapon) == 0)
    return;

  if (my_meat() < 5000)
    return;

  log("Making a " + wrap(chrome_weapon) + " for more rollover adventures.");
  create(1, chrome_weapon);
}

void make_things()
{

  // General requirements for future quests and such


  if (quest_status("questL13Final") < 5)
  {
    string msg = "for the perplexing door.";
    make_if_needed($item[skeleton key], msg);
    make_if_needed($item[richard's star key], msg);
  }

  make_if_needed($item[rusty metal key], "to open an orcish meat locker.");

  if (my_path() != "License to Adventure")
  {
    make_if_needed($item[wand of nagamar]);
  }

  if (my_path() != "Nuclear Autumn")
  {
    make_if_needed($item[unstable fulminate]);
  }
  if (my_path() == "Nuclear Autumn" && creatable_amount($item[unstable fulminate]) > 0 && quest_active("questL11Manor"))
  {
    warning("You collected the pieces for the " + wrap($item[unstable fulminate]) + ", but I don't know how to make that since I can't buy a " + wrap($item[Dramatic&trade; range]) + ". If you can get one somehow, you'll need to make this yourself.");
    wait(5);
  }

  if (get_property("questL11Palindome") != "finished")
  {
    make_if_needed($item[wet stunt nut stew], "for Mr. Alarm");
  }

  // Cobb Goblin cake
  if (get_property("questL05Goblin") != "finished")
  {
    make_if_needed($item[knob cake], "to get to the " + wrap($monster[knob goblin king]) + ".");
  }


  // *** Less requirements, but still sometimes useful or fun:

  make_if_needed($item[ratskin belt], "for a meat bonus item.");
  make_if_needed($item[asshat], "because it's funny.");

  // rainbow summons:
  while (have_skill($skill[rainbow gravitation])
         && to_int(get_property("prismaticSummons")) < 3)
  {
    if (!have_or_get_all_wads()) break;
    log("Summoning a " + wrap($item[prismatic wad]) + ".");
    use_skill(1, $skill[rainbow gravitation]);
  }

  // bricks of sand:
  if (item_amount($item[handful of sand]) >= 5)
  {
    log("Turning " + wrap("handfuls of sand", COLOR_ITEM) + " into " + wrap("bricks of sand", COLOR_ITEM) + ".");
    use_all($item[handful of sand]);
    // for some reason, Mafia doesn't remove "used" sand when turned into bricks.
    cli_execute("refresh inv");
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

  // turtlemail bits:
  if (be_good($item[turtlemail bits]))
  {
    if (item_amount($item[turtlemail bits]) > 7
        && have_skill($skill[torso awaregness])
        && i_a($item[turtlemail hauberk]) == 0)
    {
      log("Turning " + wrap($item[turtlemail bits]) + " into a " + wrap($item[turtlemail hauberk]) + ".");
      create(1, $item[turtlemail hauberk]);
    }
    if (item_amount($item[turtlemail bits]) > 5
        && i_a($item[turtlemail breeches]) == 0)
    {
      log("Turning " + wrap($item[turtlemail bits]) + " into a " + wrap($item[turtlemail breeches]) + ".");
      create(1, $item[turtlemail breeches]);
    }
    if (item_amount($item[turtlemail bits]) > 3 && i_a($item[turtlemail coif]) == 0)
    {
      log("Turning " + wrap($item[turtlemail bits]) + " into a " + wrap($item[turtlemail coif]) + ".");
      create(1, $item[turtlemail coif]);
    }
    if (i_a($item[turtlemail hauberk]) > 0 && i_a($item[turtlemail breeches]) > 0 && i_a($item[turtlemail coif]) > 0)
    {
      sell_all($item[turtlemail bits]);
    }

  }

  // turtle wax. Aught to make it into something useful.
  if (item_amount($item[turtle wax]) > 0)
  {
    use(1, $item[turtle wax]);
  }

  if (creatable_amount($item[imbued seal-blubber candle]) > 0 && my_meat() > 1000)
  {
    create(creatable_amount($item[imbued seal-blubber candle]), $item[imbued seal-blubber candle]);
  }

  // double-ice things:
  if (item_amount($item[shard of double-ice]) > 5 && i_a($item[double-ice cap]) == 0)
  {
    log("Turning " + wrap($item[shard of double-ice]) + " into a " + wrap($item[double-ice cap]) + ".");
    create(1, $item[double-ice cap]);
  }
  if (item_amount($item[shard of double-ice]) > 9 && i_a($item[double-ice britches]) == 0)
  {
    log("Turning " + wrap($item[shard of double-ice]) + " into a " + wrap($item[double-ice britches]) + ".");
    create(1, $item[double-ice britches]);
  }
  if (item_amount($item[shard of double-ice]) > 7 && i_a($item[double-ice box]) == 0)
  {
    log("Turning " + wrap($item[shard of double-ice]) + " into a " + wrap($item[double-ice box]) + ".");
    create(1, $item[double-ice box]);
  }

  foreach l in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
  {
    make_if_needed(l, "to help scare away protestors");
  }


  if (setting("long_aftercore", "false") == "true"
      && setting("do_heart", "false") == "true"
      && quest_status("questL13Final") == FINISHED)
  {
    if (have($item[gob of wet hair])
        && get_property("unknownRecipe5062") == "false")
    {
      int gobs = item_amount($item[gob of wet hair]);
      stock_item($item[wooden figurine], gobs);
      log("Making " + wrap($item[creepy voodoo doll], gobs) + " to give them to people.");
      create(creatable_amount($item[creepy voodoo doll]), $item[creepy voodoo doll]);
    }
    if (get_property("unknownRecipe5067") == "false")
    {
      int pops = item_amount($item[knob goblin firecracker]) - 10;
      pops = min(pops, item_amount($item[cob of corn]));
      if (pops > 0)
      {
        create(pops, $item[popcorn]);
      }
    }
  }

}
