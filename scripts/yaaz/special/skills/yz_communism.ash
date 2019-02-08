import "util/base/yz_print.ash";

void communism_progress()
{

}

void communism()
{
  if (!have_skill($skill[communism!])) return;
  if (prop_bool("_communismUsed")) return;

  log(wrap($skill[communism!]));
  use_skill(1, $skill[communism!]);
}

void main()
{
  communism();
}
