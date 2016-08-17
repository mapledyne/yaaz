import "util/monsters.ash";
import "util/inventory.ash";

import <zlib.ash>;

void main(int round, monster foe, string page)
{
  if (ghosts contains foe && have_equipped($item[protonic accelerator pack]))
  {
    use_skill(1, $skill[shoot ghost]);
    use_skill(1, $skill[shoot ghost]);
    use_skill(1, $skill[shoot ghost]);
    use_skill(1, $skill[trap ghost]);
  }

  string yellow_ray_list = setting("yellow_ray_list");
  if (list_contains(yellow_ray_list, foe) && have_yellow_ray() && have_effect($effect[everything looks yellow]) == 0)
  {
    item yr = yellow_ray_item();
    throw_item(yr);
  }

  string duplicate_list = setting("duplicate_list");
  if (list_contains(duplicate_list, foe) && have_skill($skill[duplicate]))
  {
    use_skill(1, $skill[duplicate]);
  }

  string digitize_list = setting("digitize_list");
  if (list_contains(duplicate_list, foe) && have_skill($skill[digitize]))
  {
    use_skill(1, $skill[digitize]);
  }

}
