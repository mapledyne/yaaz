
import "util/base/yz_print.ash";
import "util/base/yz_util.ash";


boolean valid_thrall(thrall slave)
{
  skill sk = to_skill(slave);
  if (!have_skill(sk)) return false;
  if (my_maxmp() < mp_cost(sk)) return false;
  return true;
}

void bind_thrall(thrall slave)
{
  if (my_thrall() == slave)
    return;
  skill sk = to_skill(slave);
  if (sk != $skill[none])
  {
    log("Binding a " + wrap(slave) + " to our will.");
    use_skill(1, sk);
  }
}

void prep_pastamancer(location loc)
{
  if (my_class() != $class[pastamancer]) return;

  // ... class specific stuff ...

  if (valid_thrall($thrall[lasagmbie])
      && (loc == $location[the themthar hills]
          || loc == $location[tower level 2]))
  {
    bind_thrall($thrall[lasagmbie]);
    return;
  }

  // roughly in order of preference:
  foreach slave in $thralls[spice ghost,
                            penne dreadful,
                            elbow macaroni,
                            angel hair wisp,
                            vermincelli,
                            spaghetti elemental,
                            vampieroghi,
                            lasagmbie]
  {
    if (valid_thrall(slave))
    {
      bind_thrall(slave);
      return;
    }
  }
  log("You're a " + wrap(my_class()) + ", but you don't have any thrall skills. Go learn one!");
}

void prep_pastamancer()
{
  prep_pastamancer($location[none]);
}

void main()
{
  prep_pastamancer();
}
