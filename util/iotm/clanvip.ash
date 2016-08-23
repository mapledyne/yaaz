boolean can_vip()
{
  return (item_amount($item[clan vip lounge key]) > 0);
}

boolean can_vip_drink()
{
  return can_vip() && to_int(get_property("_speakeasyDrinksDrunk")) < 3;
}

boolean is_vip_item(item it)
{
  if ($items[lucky lindy] contains it)
    return true;
  return false;
}
