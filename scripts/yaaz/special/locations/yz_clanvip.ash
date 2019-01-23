import "util/base/yz_inventory.ash";

boolean is_vip_item(item it);
boolean can_vip_drink();
boolean can_vip_drink(item it);
boolean can_vip();
boolean can_vip_shower();
boolean vip_shower(string temp);

// Note: more complex Clan VIP items have their own entry, like the Floundry.

void clanvip_progress()
{
  if (!can_vip()) return;
  if (can_vip_shower())
  {
    task("Take a shower in the " + wrap($item[clan shower]));
  }
}

void vip_hottub()
{
  if (can_vip())
    visit_url("clan_viplounge.php?action=hottub");
}

boolean can_vip_shower()
{
  if (!have($item[clan vip lounge key])) return false;
  if (to_boolean(get_property("_aprilShower"))) return false;
  if (!is_unrestricted($item[clan shower])) return false;

  return get_clan_lounge() contains $item[clan shower];
}

boolean vip_shower(string temp)
{
  if (!can_vip_shower()) return false;

  switch (to_lower_case(temp))
  {
    case 'mainstat':
      return vip_shower(my_primestat());
    case 'muscle':
      temp = 'warm';
      break;
    case 'moxie':
      temp = 'cool';
      break;
    case 'mysticality':
      temp = 'lukewarm';
      break;
  }

  log("About to use the " + wrap($item[clan shower]) + " set to " + wrap(temp, COLOR_ITEM));
  cli_execute("shower " + temp);
  return true;
}

boolean vip_shower()
{
  string temp = setting('shower_temp', 'mainstat');

  return vip_shower(temp);
}

boolean can_vip()
{
  return (have($item[clan vip lounge key]));
}

boolean can_vip_drink()
{
  return can_vip() && prop_int("_speakeasyDrinksDrunk") < 3;
}

boolean can_vip_drink(item it)
{
  if (!is_vip_item(it))
    return false;
  if (!can_vip_drink())
    return false;

  int yum = it.inebriety;

  if (my_path() == "Nuclear Autumn" && yum > 1)
    return false;

  if (npc_price(it) == 0 || npc_price(it) > (my_meat() / 2))
    return false;

  int room = inebriety_limit() - my_inebriety();
  return yum <= room;
}

boolean is_vip_item(item it)
{
  if ($items[glass of &quot;milk&quot;,
             cup of &quot;tea&quot;,
             thermos of &quot;whiskey&quot;,
             Lucky Lindy,
             Bee's Knees,
             Sockdollager,
             Ish Kabibble,
             Hot Socks,
             Phonus Balonus,
             Flivver,
             Sloppy Jalopy] contains it)
    return true;
  return false;
}

void clanvip()
{

}

void main()
{
  clanvip();
}
