import "util/base/yz_settings.ash";
import "util/base/yz_print.ash";

boolean[item] annoyances = $items[brick,
                                  glass of warm water,
                                  jawbruiser,
                                  puppet strings,
                                  roll of toilet paper,
                                  unmotivator: crashed meat car,
                                  unmotivator: crashed orca,
                                  unmotivator: success warrior];


int total_annoyances()
{
  int so_many_annoyances = 0;
  foreach annoy in annoyances
  {
    so_many_annoyances += item_amount(annoy);
    so_many_annoyances += get_free_pulls()[annoy];
  }
  return so_many_annoyances;
}

void summon_annoyance()
{
  if (!have_skill($skill[summon annoyance])) return;
  if (to_boolean(get_property("_summonAnnoyanceUsed"))) return;
  if (!to_boolean(setting("do_heart"))) return;

  int annoy_cost = to_int(get_property("summonAnnoyanceCost"));

  // make sure we have plenty of surplus swagger.
  if (to_int(get_property("availableSwagger")) < annoy_cost * 100) return;


  // if we have plenty of annoyances, let's skip for now.
  if (total_annoyances() > 20) return;

  log("Going to " + wrap($skill[summon annoyance]) + " to do stuff to people in the future.");
  use_skill(1, $skill[summon annoyance]);
}

void main()
{
  summon_annoyance();
}
