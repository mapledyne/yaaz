import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";

void lattemug_progress()
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;
  int refills = to_int(get_property("_latteRefillsUsed"));

  string drink = UNCHECKED;
  string copy = UNCHECKED;
  string banish = UNCHECKED;

  if (to_boolean(get_property("_latteCopyUsed"))) copy = CHECKED;
  if (to_boolean(get_property("_latteDrinkUsed"))) drink = CHECKED;
  if (to_boolean(get_property("_latteBanishUsed"))) banish = CHECKED;

  progress(refills, 3, "Refills on your " + wrap($item[latte lovers member's mug]) + " (" + banish + " banish, " + copy + " copy, " + drink + " drink)", "blue");

}


void lattemug()
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;

}

void main()
{
  lattemug();
}
