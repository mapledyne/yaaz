import "util/main.ash";

int turners()
{
  return item_amount($item[crumbling wooden wheel]) + item_amount($item[tomb ratchet]);
}

void open_pyramid()
{
  if (quest_status("questL11Pyramid") < 0)
  {
    error("Pyramid not yet discovered. If I was helpful, I'd tell you what to do next. I'm not.");
    return;
  }
  if (quest_status("questL11Pyramid") > 10)
  {
    warning("Pyramid quest already complete.");
    return;
  }

  while (quest_status("questL11Pyramid") < 1)
  {
    maximize("noncombat");
    dg_adventure($location[The Upper Chamber]);
    if (turners() > 0)
    {
      progress(turners(), 10, "wheel turning things");
    }
  }

  while (quest_status("questL11Pyramid") < 3)
  {
    maximize("items");
    dg_adventure($location[The Middle Chamber]);
    if (turners() > 0)
    {
      progress(turners(), 10, "wheel turning things");
    }
  }

  while (turners() < 10)
  {
    maximize("items");
    dg_adventure($location[The Middle Chamber]);
    progress(turners(), 10, "wheel turning things");
  }

}

void main()
{
  open_pyramid();
}
