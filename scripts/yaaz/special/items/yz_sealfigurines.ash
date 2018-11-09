import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_maximize.ash";
import "util/base/yz_monsters.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_inventory.ash";

int figurines_max()
{
  if (have($item[claw of the infernal seal]))
  {
    return 10;
  }
  return 5;
}

int figurines_summoned()
{
  return to_int(get_property("_sealsSummoned"));
}

int figurines_remaining()
{
  int left = figurines_max() - figurines_summoned();
  if (left < 0) left = 0;
  return left;
}

void sealfigurines_progress()
{
  if (my_class() != $class[seal clubber]) return;
  if (figurines_summoned() >= figurines_max()) return;
  progress(figurines_summoned(), figurines_max(), "Infernal Seal summonings", "blue");
}

item get_best_figurine()
{
  item target = $item[none];
  if (have($item[figurine of a sleek seal]) && !dangerous($monster[watertight seal]))
  {
    target = $item[figurine of a sleek seal];
  }
  if (have($item[figurine of a charred seal]) && !dangerous($monster[heat seal]))
  {
    target = $item[figurine of a charred seal];
  }
  if (have($item[figurine of a cold seal]) && !dangerous($monster[navy seal]))
  {
    target = $item[figurine of a cold seal];
  }
  if (have($item[figurine of a stinking seal]) && !dangerous($monster[servant of grodstank]))
  {
    target = $item[figurine of a stinking seal];
  }
  if (have($item[figurine of a shadowy seal]) && !dangerous($monster[shadow of black bubbles]))
  {
    target = $item[figurine of a shadowy seal];
  }
  if (have($item[figurine of a slippery seal]) && !dangerous($monster[wet seal]))
  {
    target = $item[figurine of a slippery seal];
  }

  if (!have($item[imbued seal-blubber candle]) && target != $item[none])
  {
    debug("Wanting to use " + wrap(target) + " but with no " + wrap($item[imbued seal-blubber candle]) + ", we'll try to build one of those instead.");
    target = $item[figurine of an ancient seal];
  }

  return target;
}

void sealfigurines()
{
  if (my_class() != $class[seal clubber]) return;
  if (my_level() <= 6) return;
  if (figurines_remaining() < 1) return;

  item fig = get_best_figurine();

  if (fig == $item[none]) return;

  debug("Trying to summon a seal from a " + wrap(fig));
  if (fig == $item[figurine of an ancient seal])
  {
    int needed = 3 - item_amount($item[seal-blubber candle]);
    if (needed > 0)
    {
      if (my_meat() < 200 * needed)
      {
        debug("Going to skip the figurine for now until we have more meat.");
        return;
      }
      buy(needed, $item[seal-blubber candle]);
    }
  }

  log("About to use a " + wrap(fig) + " to summon a seal.");
  maximize("club");
  use(1, fig);
}

void main()
{
  sealfigurines();
}
