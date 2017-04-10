import "util/base/settings.ash";
import "util/base/print.ash";

boolean[item] annoyances = $items[brick,
                                  glass of warm water,
                                  jawbruiser,
                                  puppet strings,
                                  roll of toilet paper,
                                  unmotivator: crashed meat car,
                                  unmotivator: crashed orca,
                                  unmotivator: success warrior];

void summon_annoyance()
{
  if (!have_skill($skill[summon annoyance])) return;
  if (to_boolean(get_property("_summonAnnoyanceUsed"))) return;
  if (!to_boolean(setting("do_heart"))) return;

  int annoy_cost = to_int(get_property("summonAnnoyanceCost"));

  // make sure we have plenty of surplus swagger.
  if (to_int(get_property("availableSwagger")) < annoy_cost * 100) return;

  int so_many_annoyances = 0;
  foreach annoy in annoyances
  {
    so_many_annoyances += item_amount(annoy);
    so_many_annoyances += get_free_pulls()[annoy];
  }

  // if we have plenty of annoyances, let's skip for now.
  if (so_many_annoyances > 20) return;

  log("Going to " + wrap($skill[summon annoyance]) + " to do stuff to people in the future.");
  use_skill(1, $skill[summon annoyance]);
}

void main()
{
  summon_annoyance();
}
