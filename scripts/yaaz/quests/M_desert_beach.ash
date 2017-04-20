import "util/main.ash";

void M_desert_beach_progress()
{
  if (to_int(get_property("lastDesertUnlock")) >= my_ascensions()) return;

  if (knoll_available())
  {
    task("Build a " + wrap($item[bitchin' meatcar]));
  } else {
    task("Buy a " + wrap($item[desert bus pass]));
  }
}

void M_desert_beach_cleanup()
{

}

boolean M_desert_beach()
{
  if (to_int(get_property("lastDesertUnlock")) >= my_ascensions()) return false;

  if (knoll_available())
  {
    if (my_meat() > 2500)
    {
      make_if_needed($item[bitchin' meatcar], "to reach the desert.");
      return true;
    }
    return false;
  }

  if (my_meat() > 7000)
  {
    log("Buying a " + wrap($item[desert bus pass]) + " to access the beach.");
    buy(1, $item[desert bus pass]);
    return true;
  }
  return false;
}

void main()
{
  while(M_desert_beach());
}
