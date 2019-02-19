import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";

void batfellow_comic_progress()
{
  if (!have($item[special edition batfellow comic])) return;
  if (to_boolean(setting("did_batfellow", "false"))) return;

  task("Consider using your " + wrap($item[special edition batfellow comic]) + ".");
}

item batfellow_item()
{

  item[int] batfellow_items;
  batfellow_items[0] = $item[Kudzu salad];
  batfellow_items[1] = $item[Mansquito Serum];
  batfellow_items[2] = $item[Miss Graves' vermouth];
  batfellow_items[3] = $item[The Plumber's mushroom stew];
  batfellow_items[4] = $item[The Author's ink];
  batfellow_items[5] = $item[The Mad Liquor];
  batfellow_items[6] = $item[Doc Clock's thyme cocktail];
  batfellow_items[7] = $item[Mr. Burnsger];
  batfellow_items[8] = $item[The Inquisitor's unidentifiable object];

  sort batfellow_items by item_amount(value) + closet_amount(value) + storage_amount(value);

  return batfellow_items[0];
  
}

void batfellow_comic()
{
  if (!have($item[special edition Batfellow comic])) return;
  if (!to_boolean(setting("do_batfellow", "false"))) return;
  if (to_boolean(setting("did_batfellow", "false"))) return;

  item bat_item = batfellow_item();

  if (bat_item == $item[none]) return;

  if (!svn_exists('ccascend-batfellow'))
  {
    warning("I can't get an item from the " + wrap($item[special edition Batfellow comic]) + " without cheesecookie's Batfellow script installed.");
    warning("Install this, then I can try to play Batfellow for you..");
    return;
  }

  save_daily_setting("did_batfellow", "true");
  log("You've set '" + wrap('yz_do_batfellow', COLOR_ITEM) + "' and have a " + wrap($item[special edition Batfellow comic]) + ", so playing it to get a " + wrap(bat_item) + ".");
  wait(10);
  cli_execute("ash import<batfellow.ash> batfellow($item[" + bat_item + "]);");

}

void main()
{
  batfellow_comic();
}
