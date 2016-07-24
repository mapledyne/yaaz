import "util/print.ash";

void save(item it)
{
  int qty = item_amount(it);
  if (qty > 0)
  {
    log("Putting " + qty + " " + wrap(pluralize(qty, it), COLOR_ITEM) + " in the display case.");
    put_display(item_amount(it), it);
  }
}

void save_mementos()
{
  // stuffies:
  foreach it in $items[stuffed Meat, stuffed Baron von Ratsworth, stuffed MagiMechTech MicroMechaMech, stuffed Meat, stuffed treasure chest]
  {
    save(it);
  }
}

void main()
{
  save_mementos();
}
