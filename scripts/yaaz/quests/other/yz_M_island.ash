import "util/yz_main.ash";

void M_island_cleanup()
{

}

void M_island_progress()
{

  if (to_int(get_property("lastIslandUnlock")) >= my_ascensions()
      || to_int(get_property("lastDesertUnlock")) < my_ascensions())
  {
    return;
  }
  if (!have($item[dinghy plans]))
  {
    progress(item_amount($item[Shore Inc. Ship Trip Scrip]), 3, "shore scrip for the dinghy plans");
  }
  if (!have($item[dingy planks]))
  {
    task("buy dinghy planks");
  }
}

boolean M_island()
{
  if (have($item[Dingy dinghy])) return false;
  if (to_int(get_property("lastDesertUnlock")) < my_ascensions()) return false;

  if (my_adventures() < 20) return false;

  if (item_amount($item[dingy planks]) == 0 && my_meat() > 1000)
  {
    buy(1, $item[dingy planks]);
  }

  maybe_pull($item[Shore Inc. Ship Trip Scrip], 3);

  if (item_amount($item[Shore Inc. Ship Trip Scrip]) < 3)
  {

    switch (my_primestat())
    {
      case $stat[muscle]:
        set_property("choiceAdventure793", 1);
        break;
      case $stat[mysticality]:
        set_property("choiceAdventure793", 2);
        break;
      case $stat[moxie]:
        set_property("choiceAdventure793", 3);
        break;
    }
    log("Going on a shore vacation to get some " + wrap($item[Shore Inc. Ship Trip Scrip]) + ".");
    adventure(1, $location[The Shore\, Inc. Travel Agency]);
    return true;
  }

  if (!have($item[dinghy plans]))
  {
    log("Buying " + wrap($item[dinghy plans]) + ".");
    cli_execute("acquire dinghy plans");
    return true;
  }

  if (have($item[dinghy plans])
      && have($item[dingy planks]))
  {
    log("Making a " + wrap($item[Dingy dinghy]) + ".");
    use(1, $item[dinghy plans]);
    return true;
  }

  return false;
}


void main()
{
  while(M_island());
}
