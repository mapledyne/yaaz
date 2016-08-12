import "util/main.ash";
string TRAPPER_URL="place.php?whichplace=mclargehuge&action=trappercabin"

void visit_trapper()
{
  visit_url(TRAPPER_URL);
}

int get_cheese()
{
  item cheese = $item[goat cheese];
  location goatlet = $location[goatlet];

  int qty = item_amount(cheese);

  while(qty < 3)
  {
    maximize("items");
    dg_adventure(goatlet);
    qty = item_amount(cheese);
  }
  return qty;
}

void L08_Q_trapper()
{
  if (my_level() < 8)
  {
    warning("You can't start the trapper quest until level 8.");
    return;
  }

  if (quest_status("questL08Trapper") == 0)
  {
    log("Quest isn't started yet. Talking to the council.");
    council();
  }

  if (quest_status("questL08Trapper") == 1)
  {
    item ore = to_item(get_property("trapperOre"));
    int ore_qty = item_amount(ore);
    int goat_qty = get_cheese();

    if (ore_qty < 3)
    {
      log("Unsure if it's better to clover the mine, get these from the deck, or just mine. Letting you decide for yourself for now.");
      return;
    }

    if (goat_qty < 3)
    {
      warning("You should have three " + wrap($item[goat cheese]) + " at this point, but you don't.");
      return;
    }

    log("Three " + wrap($item[goat cheese]) + " and three " + wrap(ore) + " found.");
    log("Returning these to the trapper.");
    visit_trapper();
  }

}

void main()
{
  L08_Q_trapper();
}
