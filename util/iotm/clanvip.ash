boolean is_vip_item(item it);
boolean can_vip_drink();
boolean can_vip_drink(item it);
boolean can_vip();

boolean can_vip()
{
  return (item_amount($item[clan vip lounge key]) > 0);
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
  int room = inebriety_limit() - my_inebriety();
  return yum <= room;
}

boolean is_vip_item(item it)
{
  if ($items[lucky lindy] contains it)
    return true;
  return false;
}
