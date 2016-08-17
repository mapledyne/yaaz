import "util/main.ash";

void get_star_key()
{
  if (item_amount($item[steam-powered model rocketship]) == 0)
  {
    warning("Go and get the " + wrap($item[steam-powered model rocketship]) + " first.");
    return;
  }

  if (item_amount($item[richard's star key]) > 0)
  {
    log("You already have " + wrap($item[richard's star key]) + ".");
    return;
  }

  while(creatable_amount($item[richard's star key]) == 0)
  {
    dg_adventure($location[hole in the sky], "items");
  }

  log("Creating " + wrap($item[richard's star key]) + ".");
  create(1, $item[richard's star key]);
}

void main()
{
  get_star_key();
}
