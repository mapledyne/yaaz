import "util/main.ash";

boolean laugh_loop()
{
  if (item_amount($item[imp air]) > 4 && i_a($item[observational glasses]) > 0)
    return false;

  dg_adventure($location[the laugh floor], "items");
  progress(item_amount($item[imp air]), 5, "imp airs");
  return true;
}

boolean backstage_loop()
{
  if (item_amount($item[bus pass]) > 4)
    return false;

  maximize("items");
  dg_adventure($location[infernal rackets backstage]);
  progress(item_amount($item[bus pass]), 5, "bus passes");
  return true;
}
void collect_steel()
{

  int turns = my_adventures();

  int counter = 0;

  log("Getting some " + wrap($item[imp air]) + ".");
  while (laugh_loop())
  {

  }

  log("Getting some " + wrap($item[bus pass]) + ".");
  while (backstage_loop())
  {

  }


}

void main()
{
  collect_steel();
}
