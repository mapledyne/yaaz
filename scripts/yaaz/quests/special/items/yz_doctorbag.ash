import "util/yz_main.ash";

void doctorbag_cleanup()
{

}

void doctorbag_progress()
{
  item bag = $item[Lil' Doctor&trade; bag];

  if (!have(bag)) return;
  if (!be_good(bag)) return;

}

boolean doctorbag()
{
  item bag = $item[Lil' Doctor&trade; bag];

  if (!have(bag)) return false;
  if (!be_good(bag)) return false;
//  set_property("choiceAdventure1340", "1");
  if (get_property("doctorBagQuestItem") != "")
  {
      debug("Doctor quest?");
      wait(10);
  }

  return false;
}

void main()
{
  while(doctorbag());
}
