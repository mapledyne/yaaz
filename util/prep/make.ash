import "util/inventory.ash";


void consider_chrome_item()
{
  // bail if we don't have the chrome ore
  if (item_amount($item[chrome ore]) == 0)
  {
    return;
  }
  item chrome_weapon;

  if (my_primestat() == $stat[mysticality])
    chrome_weapon = $item[chrome staff];
  if (my_primestat() == $stat[muscle])
    chrome_weapon = $item[chrome sword];
  if (my_primestat() == $stat[moxie])
    chrome_weapon = $item[chrome crossbow];

  // bail if we have one:
  if (item_amount(chrome_weapon) > 0)
    return;


  if (get_property("questL08Trapper") == "unstarted" || get_property("questL08Trapper") == "step1" || get_property("trapperOre") != "chrome ore")
  {
    // bail if we don't have surplus ore: trapper wants (or may want) chrome ore and we haven't turned it in yet.
    if (i_a($item[chrome ore]) < 4)
    {
      return;
    }
  }

  if (creatable_amount(chrome_weapon) == 0)
    return;

  if (my_meat() < 5000)
    return;

  // we have lots of adventures... or we're drunk:
  if ((my_adventures() < 20) && (my_inebriety() <= inebriety_limit()))
    return;

  log("Making a " + wrap(chrome_weapon) + " for rollover adventures.");
  create(1, chrome_weapon);
}

void make_things()
{
  // bricks of sand:
  if (item_amount($item[handful of sand]) >= 5)
  {
    log("Turning " + wrap("handfuls of sand", COLOR_ITEM) + " into " + wrap("bricks of sand", COLOR_ITEM) + ".");
    use_all($item[handful of sand]);
    // for some reason, Mafia doesn't remove "used" sand when turned into bricks.
    cli_execute("refresh inv");
  }

  // palm frond fans:
  if (item_amount($item[palm frond]) > 1)
  {
    log("Turning " + wrap("palm fronds", COLOR_ITEM) + " into " + wrap("palm frond fans", COLOR_ITEM) + ".");
    while (item_amount($item[palm frond]) > 1)
    {
      use(2, $item[palm frond]);
    }
  }

  // Chrome items:
  consider_chrome_item();
}
