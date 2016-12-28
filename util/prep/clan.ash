import "util/base/inventory.ash";


void clan_things()
{
  int[item] clan_items;
  file_to_map(DATA_DIR + "clan.txt", clan_items);

  foreach it, i in clan_items
  {
    stash(it, i);
  }

}

void main()
{
  clan_things();
}
