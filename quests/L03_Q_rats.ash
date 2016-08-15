import "util/main.ash";

void clear_rats()
{
  if (my_level() < 3)
  {
    log("You need to be at least level 3 before clearing the rats.");
    return;
  }

  if (quest_status("questL02Larva") != FINISHED)
  {
    warning("You can't start the Rats quest until the Larva quest is complete.");
    return;
  }

  if (quest_status("questL03Rat") == FINISHED)
  {
    log("Rat faucet already turned off.");
    return;
  }
  if (quest_status("questL03Rat") == -1)
  {
    log("Going to the council to pick up the quest.");
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

  if (quest_status("questL03Rat") == 2)
  {
    log("Faucet turned off. Going to talk to Bart.");
    visit_url("tavern.php?place=barkeep");
  }

}

void main()
{
  clear_rats();
}
