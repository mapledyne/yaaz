import "util/base/monsters.ash";
import "util/base/inventory.ash";
import "util/base/settings.ash";
import "util/iotm/terminal.ash";

import <zlib.ash>;

void main(int round, monster foe, string page)
{
  if (foe == $monster[protector spectre])
  {
    print("Whoa - why can't we seem to be able to script this Spectre fight?");
    print("At least we know we got this far...");
  }

  if (have_skill($skill[extract jelly]))
  {
    if (foe.attack_element != $element[none]
        || foe.phylum == $phylum[fish]) use_skill(1, $skill[extract jelly]);
  }

  if (ghosts contains foe && have_equipped($item[protonic accelerator pack]))
  {
    if (expected_damage(foe) < (my_hp() / 2))
    {
      use_skill(1, $skill[shoot ghost]);
      use_skill(1, $skill[shoot ghost]);
      use_skill(1, $skill[shoot ghost]);
      use_skill(1, $skill[trap ghost]);
    }
  }
  monster digitized = to_monster(get_property("_sourceTerminalDigitizeMonster"));

  if (have_skill($skill[digitize]) && digitize_remaining() > 0)
  {
    switch (foe)
    {
      case $monster[dirty thieving brigand]:
      if (to_int(get_property("currentNunneryMeat")) < 94000)
      {
        break;
      }
      case $monster[ninja snowman assassin]:
      case $monster[writing desk]:
      case $monster[lobsterfrogman]:
        if (digitized != foe)
        {
          use_skill(1, $skill[digitize]);
        }
        break;
    }
  }

  string yellow_ray_list = setting("yellow_ray_list");
  if (list_contains(yellow_ray_list, foe) && have_yellow_ray() && have_effect($effect[everything looks yellow]) == 0)
  {
    item yr = yellow_ray_item();
    string new_list = list_remove(yellow_ray_list, foe);
    save_setting("yellow_ray_list", new_list);
    throw_item(yr);
  }

  string duplicate_list = setting("duplicate_list");
  if (list_contains(duplicate_list, foe) && have_skill($skill[duplicate]))
  {
    string new_list = list_remove(duplicate_list, foe);
    save_setting("duplicate_list", new_list);
    use_skill(1, $skill[duplicate]);
  }

  if (foe == $monster[your shadow] && have_skill($skill[Ambidextrous Funkslinging]))
  {
    // this could obviously use some much better finesse.
    throw_items($item[gauze garter], $item[gauze garter]);
    throw_items($item[gauze garter], $item[gauze garter]);
    throw_items($item[gauze garter], $item[gauze garter]);
  }

}
