import "util/base/yz_print.ash";

boolean[item] saucepans = $items[saucepan,
                              5-Alarm Saucepan,
                              warbear oil pan,
                              oil pan,
                              17-alarm Saucepan,
                              Saucepanic,
                              Windsor Pan of the Source,
                              frying brainpan];

boolean knows_sauceror_buff()
{
  foreach sk in $skills[]
  {
    if (!have_skill(sk)) continue;
    if (!is_sauceror_buff(sk)) continue;
    return true;
  }
  return false;
}

boolean has_saucepan()
{
  foreach pan in saucepans
  {
    if (i_a(pan) > 0) return true;
  }
  return false;
}

void get_saucepan()
{
  if (npc_price($item[chewing gum on a string]) == 0) return;
  if (has_saucepan()) return;
  if (!knows_sauceror_buff()) return;

	while(!have($item[saucepan]) && my_meat() > 500)
	{
    log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap($item[saucepan]) + ".");
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}

}

void prep_sauceror(location loc)
{
  get_saucepan();

  if (my_class() != $class[sauceror]) return;

  // ... class specific stuff ...

}

void prep_sauceror()
{
  prep_sauceror($location[none]);
}

void main()
{
  prep_sauceror();
}
