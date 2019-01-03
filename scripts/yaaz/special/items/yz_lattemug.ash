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

void latte_refill()
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;
  int refills = to_int(get_property("_latteRefillsUsed"));
  if (refills >= 3) return;

  string ingred = "cinnamon pumpkin vanilla";
  log("About to refill our " + wrap($item[latte lovers member's mug]) + " with: " + wrap(ingred, COLOR_ITEM));
  cli_execute("latte refill " + ingred);

}

void lattemug()
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;

  if (to_boolean(get_property("_latteCopyUsed"))) return;
  if (to_boolean(get_property("_latteDrinkUsed"))) return;
  if (to_boolean(get_property("_latteBanishUsed"))) return;

  latte_refill();
}

void main()
{
  lattemug();
}
