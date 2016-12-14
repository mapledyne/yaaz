import "util/main.ash";

boolean M_8bit()
{
  if (item_amount($item[digital key]) > 0)
    return false;

  if (quest_status("questL13Final") > 3)
    return false;

  if (item_amount($item[continuum transfunctioner]) == 0)
    return false;

  add_attract($monster[blooper]);
  while(item_amount($item[digital key]) == 0)
  {
      if (creatable_amount($item[digital key]) > 0)
      {
        log("Making a " + wrap($item[digital key]) + ".");
        create(1, $item[digital key]);
        continue;
      }
      maximize("items", $item[continuum transfunctioner]);
      boolean b = dg_adventure($location[8-bit realm]);
      if (!b)
        break;
  }
  remove_attract($monster[blooper]);
  return true;
}

void main()
{
  M_8bit();
}
