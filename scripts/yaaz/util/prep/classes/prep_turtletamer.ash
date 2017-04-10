import "util/base/effects.ash";

void prep_turtletamer(location loc)
{
  if (my_class() != $class[turtle tamer]) return;

  effect_maintain($effect[Eau de Tortue]);

}

void prep_turtletamer()
{
  prep_turtletamer($location[none]);
}

void main()
{
  prep_turtletamer();
}
