import "util/main.ash";



void get_blasting()
{
  if (quest_status("questL11Manor") < 1)
  {
    error("Trying to work in the cellar, but the cellar isn't opened yet.");
    return;
  }
  if (quest_status("questL11Manor") >= 3)
  {
    return;
  }

  while (item_amount($item[blasting soda]) == 0 && item_amount($item[unstable fulminate]) == 0 && item_amount($item[wine bomb]) == 0)
  {
    choose_familiar("items");
    maximize("items");
    dg_adventure($location[the haunted laundry room]);
  }
  build_requirements();
}

void open_summoning()
{
  get_blasting();
}

void main()
{
  open_summoning();
}
