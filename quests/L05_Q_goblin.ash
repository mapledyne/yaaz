import "util/main.ash";


boolean L05_Q_goblin()
{
  if (quest_status("questL05Goblin") == FINISHED)
    return false;

  location outskirts = $location[the outskirts of cobb's knob];
  warning("Test: Does questL05Goblin get updated on opening the Knob, before the main quest is offered?");
  wait(5);
  if (outskirts.turns_spent < 11 || quest_status("questL05Goblin") < 1)
  {
    if (item_amount($item[cobb's knob map]) == 0)
    {
      log("Getting " + wrap($item[cobb's knob map]) + " from the council.");
      council();
    }
    while (item_amount($item[Knob Goblin encryption key]) == 0)
    {
      dg_adventure(outskirts, "");
    }
    log("Using the " + wrap($item[Knob Goblin encryption key]) + " to unlock Cobb's Knob.");
    use(1, $item[Knob Goblin encryption key]);
    return true;
  }

  log("Keep scripting L05_Q_goblin!");
  wait(10);
  return false;
}

void main()
{
  L05_Q_goblin();
}
