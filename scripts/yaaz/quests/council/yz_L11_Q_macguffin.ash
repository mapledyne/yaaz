
void L11_Q_macguffin_progress()
{
  if (!quest_active("questL11MacGuffin")) return;

  task("Recover the " + wrap("Holy MacGuffin", COLOR_ITEM) + ".");

}

void L11_Q_macguffin_cleanup()
{

}

boolean L11_Q_macguffin()
{

  if (my_level() < 11)
    return false;

  if (quest_status("questL11MacGuffin") == UNSTARTED)
  {
    log("Going to the council to start the MacGuffin quest.");
    council();
    return true;
  }

  if (have($item[[2334]Holy MacGuffin]) || have($item[[7965]Holy MacGuffin]))
  {
    log("Returning the " + wrap($item[[2334]Holy MacGuffin]) + " to the council.");
    council();
    return true;
  }

  return false;
}

void main()
{
  while (L11_Q_macguffin());
}
