import "util/base/yz_util.ash";
import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";
import "util/base/yz_paths.ash";

int[item] closet_items;
file_to_map(DATA_DIR + "yz_closet.txt", closet_items);

void closet_things()
{

  if (!be_good($item[disassembled clover]))
  {
    closet($item[ten-leaf clover], 0);
  }

  foreach it, i in closet_items
  {
    closet(it, i);
  }

  item best_stored = $item[none];
  foreach stored in get_closet()
  {
    if (stored.inebriety == 0) continue;
    if (stored.inebriety > max_drink_size()) continue;
    if (average_range(stored.adventures) > average_range(best_stored.adventures)) best_stored = stored;
  }
}

void main()
{
  closet_things();
}
