import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_inventory.ash";

void sausage_progress()
{

}

int sausage_cost()
{
  int made = prop_int("_sausagesMade");

  return (made + 1) * 111;
}

void make_sausage()
{
  if (!have($item[Kramco Sausage-o-Matic&trade;])) return;
  if (!be_good($item[Kramco Sausage-o-Matic&trade;])) return;
  if (!have($item[magical sausage casing])) return;

  int cost = sausage_cost();
  int own = prop_int("_sausageGrinderUnits");
  int made = prop_int("_sausagesMade");

  if (to_int(setting("max_daily_sausage", "5")) <= made) return;

  if (cost > own) return;

  // make a sausage
  log("Going to grind a " + wrap($item[magical sausage]));
  visit_url('inventory.php?action=grind');
  run_choice(2);
}


void sausage()
{
  if (!have($item[Kramco Sausage-o-Matic&trade;])) return;
  if (!be_good($item[Kramco Sausage-o-Matic&trade;])) return;

  make_sausage();
}

void main()
{
  sausage();
}
