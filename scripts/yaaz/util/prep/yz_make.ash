import "util/base/yz_inventory.ash";
import "util/base/yz_quests.ash";

import <zlib.ash>


void make_things()
{

  // General requirements for future quests and such




  make_if_needed($item[rusty metal key], "to open an orcish meat locker.");

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


  if (be_good($item[metal meteoroid]) && have($item[metal meteoroid]))
  {

    item target = $item[none];
    int qty = 1000;
    foreach metal in $items[meteorthopedic shoes, asteroid belt, meteorb, shooting morning star, meteorite guard, meteortarboard]
    {
      if (i_a(metal) < qty)
      {
        qty = i_a(metal);
        target = metal;
      }
    }

    int[item] metal_choices;
    metal_choices[$item[meteortarboard]] = 1;
    metal_choices[$item[meteorite guard]] = 2;
    metal_choices[$item[meteorb]] = 3;
    metal_choices[$item[asteroid belt]] = 4;
    metal_choices[$item[meteorthopedic shoes]] = 5;
    metal_choices[$item[shooting morning star]] = 6;

    log("Making a " + wrap(target) + " from a " + wrap($item[metal meteoroid]));
    visit_url('inv_use.php?which=3&whichitem=9516');
    visit_url('choice.php?whichchoice=1264&option=' + metal_choices[target] + '&pwd');
  }


  make_if_needed($item[ratskin belt], "for a meat bonus item.");
  make_if_needed($item[asshat], "because it's funny.");

  // rainbow summons:
  while (have_skill($skill[rainbow gravitation])
         && prop_int("prismaticSummons") < 3)
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
