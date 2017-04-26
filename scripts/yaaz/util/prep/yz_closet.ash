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

  item best_held = $item[none];
  foreach held in get_inventory()
  {
    if (held.inebriety == 0) continue;
    if (held.inebriety > max_drink_size()) continue;
    if (average_range(held.adventures) > average_range(best_held.inebriety)) best_held = held;
  }

//  print(best_held);
//  print(best_stored);

  if (best_held != $item[none]
      && best_held.inebriety > best_stored.inebriety)
  {
    foreach drink, qty in get_closet()
    {
      if (drink.inebriety > 0)
      {
        log("Taking " + qty + " " + wrap(drink, qty) + " from the closet to maybe drink in the future.");
        take_closet(qty, drink);
      }
    }
    log("Putting one " + wrap(best_held) + " in the closet for use at the end of the day.");
    put_closet(1, best_held);
  }

}

void main()
{
  closet_things();
}
