import "util/base/effects.ash";
import "util/base/inventory.ash";

boolean[item] totems = $items[Chelonian Morningstar,
                              Flail of the Seven Aspects,
                              Mace of the Tortoise,
                              Ouija Board\, Ouija Board,
                              Turtle totem];

boolean has_totem()
{
  foreach t in totems
  {
    if (i_a(t) > 0) return true;
  }
  return false;
}

boolean knows_turtle_buff()
{
  foreach sk in $skills[]
  {
    if (!have_skill(sk)) continue;
    if (!is_turtle_buff(sk)) continue;
    return true;
  }
  return false;
}

void get_totem()
{
  if (npc_price($item[chewing gum on a string]) == 0) return;
  if (has_totem()) return;
  if (!knows_turtle_buff()) return;

	while(!have($item[turtle totem]) && my_meat() > 500)
	{
    log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap($item[turtle totem]) + ".");
		stock_item($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}
}

void prep_turtletamer(location loc)
{
  get_totem();
  
  if (my_class() != $class[turtle tamer]) return;

  // ... class specific stuff ...

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
