import "util/yz_main.ash";

void L03_Q_rats_progress()
{

}

void L03_Q_rats_cleanup()
{

}

boolean L03_Q_rats()
{
  if (my_level() < 3)
    return false;

  if (quest_status("questL02Larva") != FINISHED)
    return false;

  if (quest_status("questL03Rat") == FINISHED)
    return false;

  if (quest_status("questL03Rat") == UNSTARTED)
  {
    log("Going to the council to pick up the tavern quest.");
    council();
  }
  if (quest_status("questL03Rat") == 0)
  {
    log("Speaking to " + wrap("Bart Ender", COLOR_MONSTER) + " in the " + wrap("Typical Tavern", COLOR_LOCATION) + ".");
    visit_url("tavern.php?place=barkeep");
  }

  if (quest_status("questL03Rat") < FINISHED)
  {
    log("Going to clear the rats.");
    maximize();
    tavern("faucet");
  }

  // generally would only get this if the tavern were done manually
  // and not through tavern("faucet") above, but if so, we should handle the case:
  if (quest_status("questL03Rat") == 2)
  {
    log("Faucet turned off. Going to talk to Bart.");
    visit_url("tavern.php?place=barkeep");
  }
  return true;

}

void main()
{
  while (L03_Q_rats());
}
