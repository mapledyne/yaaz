int spleen_remaining()
{
  return spleen_limit() - my_spleen_use();
}

boolean is_spleen_item(item it)
{
  if (it.spleen > 0)
    return true;
  return false;
}

int spleen_cost(item it)
{
  return it.spleen;
}

boolean can_chew(item it)
{
  if (item_amount(it) == 0)
    return false;
  if (!is_spleen_item(it))
    return false;
  if (spleen_cost(it) > spleen_remaining())
    return false;
  return true;
}

boolean try_chew(item it)
{
  if (!can_chew(it))
    return false;
  return chew(1, it);
}

void spleen()
{
  try_chew($item[astral energy drink]);
}

void max_consumption()
{
  // use up all of our space.

}

void drink_irresponibly()
{
  // overdrink.

}
