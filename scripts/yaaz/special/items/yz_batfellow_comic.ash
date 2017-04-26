import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";


item batfellow_item()
{
  debug("Todo: improve logic in batfellow_item() to pick an item from the " + wrap($item[special edition Batfellow comic]) + ".");
  return $item[The Inquisitor's unidentifiable object];
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
