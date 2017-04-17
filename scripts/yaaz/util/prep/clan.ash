import "util/base/inventory.ash";


void clan_things()
{
  if (get_clan_name() == "") return;
  if (!to_boolean(setting("use_stash", "false"))) return;

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
