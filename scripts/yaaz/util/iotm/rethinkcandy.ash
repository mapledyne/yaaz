import "util/base/print.ash";

/*
Cast sweet synthesis, which takes us to a choice (1217). Send option=1 and
candies "a" and "b":
choice.php?a=6833&b=6836&whichchoice=1217&option=1&pwd
*/

boolean[item] candy_list(string typ)
{
  boolean[item] sugar;
  foreach candy in $items[]
  {
    if (candy.candy
        && candy.candy_type == typ
        && item_amount(candy) > 0)
    {
      sugar[candy] = true;
    }
  }
  return sugar;

}

boolean[item] complex_candies()
{
  return candy_list("complex");
}

boolean[item] simple_candies()
{
  return candy_list("simple");
}

item[int] pick_candies(int goal, int tier)
{
  item[int] candies;
  clear(candies);
  if (tier == 0) return candies;

  boolean[item] lista;
  boolean[item] listb;

  switch(tier)
  {
    case 1:
      lista = simple_candies();
      listb = simple_candies();
      break;
    case 2:
      lista = simple_candies();
      listb = complex_candies();
      break;
    case 3:
      lista = complex_candies();
      listb = complex_candies();
      break;
  }
  if (count(lista) == 0
      || count(listb) == 0)
  {
    return candies;
  }

  foreach a in lista
  {
    foreach b in listb
    {
      int modulus = (to_int(a) + to_int(b)) % 5;
      if (modulus == goal)
      {
        if (a == b && item_amount(a) < 2) continue;
        candies[0] = a;
        candies[1] = b;
        return candies;
      }
    }
  }

  return candies;
}

item[int] pick_candies(effect ef)
{
  item[int] candies;
  clear(candies);
  if (ef.candy_tier == 0) return candies;
  int modulus = -1;
  switch(ef)
  {
    case $effect[Synthesis: Hot]:
      modulus = 0;
      break;
    case $effect[Synthesis: Cold]:
      modulus = 1;
      break;
    case $effect[Synthesis: Pungent]:
      modulus = 2;
      break;
    case $effect[Synthesis: Scary]:
      modulus = 3;
      break;
    case $effect[Synthesis: Greasy]:
      modulus = 4;
      break;
    case $effect[Synthesis: Strong]:
      modulus = 0;
      break;
    case $effect[Synthesis: Smart]:
      modulus = 1;
      break;
    case $effect[Synthesis: Cool]:
      modulus = 2;
      break;
    case $effect[Synthesis: Hardy]:
      modulus = 3;
      break;
    case $effect[Synthesis: Energy]:
      modulus = 4;
      break;
    case $effect[Synthesis: Greed]:
      modulus = 0;
      break;
    case $effect[Synthesis: Collection]:
      modulus = 1;
      break;
    case $effect[Synthesis: Movement]:
      modulus = 2;
      break;
    case $effect[Synthesis: Learning]:
      modulus = 3;
      break;
    case $effect[Synthesis: Style]:
      modulus = 4;
      break;
  }


  if (modulus == -1) return candies;

  candies = pick_candies(modulus, ef.candy_tier);

  return candies;
}

boolean do_synthesis(effect ef)
{
  if (!have_skill($skill[sweet synthesis])) return false;
  if (ef.candy_tier == 0) return false;
  if (my_spleen_use() >= spleen_limit()) return false;

  item[int] candies = pick_candies(ef);
  if (count(candies) == 0) return false;

  log("About to cast " + wrap($skill[sweet synthesis]) + " to gain " + wrap(ef) + ".");
  log("Choosing the candies " + wrap(candies[0]) + " and " + wrap(candies[1]) + ".");
  wait(10);
  use_skill(1, $skill[sweet synthesis]);
  visit_url('choice.php?a=' + to_int(candies[0]) + '&b=' + to_int(candies[1]) + '&whichchoice=1217&option=1&pwd');
  return true;
}

void print_candy_options()
{
  foreach ef in $effects[]
  {
    if (ef.candy_tier == 0) continue;
    item[int] candies = pick_candies(ef);
    if (count(candies) == 0)
    {
      log("Cannot gain effect: " + wrap(ef));
    } else {
      log("Can gain effect: " + wrap(ef) + " from " + wrap(candies[0]) + " and " + wrap(candies[1]));
    }
  }

}

void main()
{
  print_candy_options();
}
