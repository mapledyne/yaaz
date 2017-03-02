import "util/main.ash";

boolean M_8bit()
{
  if (have($item[digital key]))
    return false;

  if (quest_status("questL13Final") > 3)
    return false;

  if (!have($item[continuum transfunctioner]))
    return false;

  add_attract($monster[blooper]);
  while(!have($item[digital key]))
  {
      if (creatable_amount($item[digital key]) > 0)
      {
        log("Making a " + wrap($item[digital key]) + ".");
        create(1, $item[digital key]);
        continue;
      }
      maximize("items", $item[continuum transfunctioner]);
      if (!time_combat($monster[blooper], $location[8-bit realm]))
      {
        boolean b = yz_adventure($location[8-bit realm]);
        if (!b)
          break;
      }
  }
  remove_attract($monster[blooper]);
  return true;
}

void main()
{
  M_8bit();
}
