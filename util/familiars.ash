boolean have_cubeling_items()
{
  if (i_a($item[eleven-foot pole]) == 0)
    return false;
  if (i_a($item[pick-o-matic lockpicks]) == 0)
    return false;
  if (i_a($item[ring of detect boring doors]) == 0)
    return false;

  return true;
}
