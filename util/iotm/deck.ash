import "util/print.ash";
import "util/inventory.ash";

boolean can_deck()
{
  if (i_a($item[deck of every card]) > 0 && to_int(get_property("_deckCardsDrawn")) < 15)
    return true;
  return false;
}

void deck()
{
  if (!can_deck())
    return;

  log("Checking out your " + wrap($item[deck of every card]) + ".");
  warn("Deck checking is not currently implemented.");
}

void main()
{
  deck();
}
