import "util/base/monsters.ash";
import "util/base/inventory.ash";
import "util/base/settings.ash";

import <zlib.ash>;

void main(int round, monster foe, string page)
{
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

  string yellow_ray_list = setting("yellow_ray_list");
  if (list_contains(yellow_ray_list, foe) && have_yellow_ray() && have_effect($effect[everything looks yellow]) == 0)
  {
    item yr = yellow_ray_item();
    throw_item(yr);
    string new_list = list_remove(yellow_ray_list, foe);
    save_setting("yellow_ray_list", new_list);
  }

  string duplicate_list = setting("duplicate_list");
  if (list_contains(duplicate_list, foe) && have_skill($skill[duplicate]))
  {
    use_skill(1, $skill[duplicate]);
    string new_list = list_remove(duplicate_list, foe);
    save_setting("duplicate_list", new_list);
  }

  string digitize_list = setting("digitize_list");
  if (list_contains(digitize_list, foe) && have_skill($skill[digitize]))
  {
    use_skill(1, $skill[digitize]);
    string new_list = list_remove(digitize_list, foe);
    save_setting("digitize_list", new_list);
  }

}
