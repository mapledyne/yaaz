import "util/print.ash";
import "util/inventory.ash";

void ltt()
{
  if (get_property("telegraphOfficeAvailable") != "true")
    return;

  if (i_a($item[your cowboy boots]) == 0)
  {
    log("Getting " + wrap($item[your cowboy boots]) + ".");
    visit_url("place.php?whichplace=town_right&action=townright_ltt");
  }
}

void main()
{
  ltt();
}
