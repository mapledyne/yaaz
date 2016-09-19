import "util/base/util.ash";
import "util/base/inventory.ash";

int[item] closet_items;
file_to_map(DATA_DIR + "closet.txt", closet_items);

void closet_things()
{
  foreach it, i in closet_items
  {
    closet(it, i);
  }
}

void main()
{
  closet_things();
}
