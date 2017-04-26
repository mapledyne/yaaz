import "util/base/yz_inventory.ash";

boolean is_vip_item(item it);
boolean can_vip_drink();
boolean can_vip_drink(item it);
boolean can_vip();

// Note: more complex Clan VIP items have their own entry, like the Floundry.

void vip_hottub()
{
  if (can_vip())
    visit_url("clan_viplounge.php?action=hottub");
}

boolean can_vip()
{
  return (have($item[clan vip lounge key]));
}

boolean can_vip_drink()
{
  return can_vip() && to_int(get_property("_speakeasyDrinksDrunk")) < 3;
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

void main()
{
  // this file just has utility functions. There's no "always do this if you have VIP" at this point.
}
