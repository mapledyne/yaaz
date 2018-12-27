import "util/yz_main.ash";

boolean[class] nemesis_classes = $classes[Seal Clubber,
                                          Turtle Tamer,
                                          Pastamancer,
                                          Sauceror,
                                          Disco Bandit,
                                          Accordion Thief];

boolean nemesissing()
{
  if (!(nemesis_classes contains my_class())) return false;
  string option = setting("nemesis", "aftercore");
  switch(option)
  {
    default:
      if (setting("nemesis_warning", "false") == "true") return false;
      error("I don't understand the setting for " + wrap("yz_nemesis", COLOR_ITEM) + ": " + wrap(option, COLOR_ITEM) + ". Options are: aftercore, true, false. Defaulting to false.");
      wait(10);
      save_daily_setting("nemesis_warning", "true");
      return false;
    case "aftercore":
      return quest_status("questL13Final") == FINISHED;
    case "false":
      return false;
    case "true":
      return true;
  }

}


void M_nemesis_progress()
{
  if (true) return; // too much in progress to want to share - it'd just be confusing so far.
  if (!nemesissing()) return;

  if (!have($item[secret tropical island volcano lair map]))
  {
    task("Find the " + wrap($item[secret tropical island volcano lair map]));
  }

  if ($location[The Nemesis' Lair].turns_spent > 0)
  {
      if (my_class() == $class[disco bandit])
          task("Fight daft punk, then your nemesis face to face.");
      else
          task("Fight goons, then your nemesis.");
  } else {

    switch(my_class())
    {
      case $class[accordion thief]:
        int keys = item_amount($item[hacienda key]);
        if (keys < 5)
        {
          progress(keys, 5, wrap($item[hacienda key], item_amount($item[hacienda key])) + " collected.");
        } else {
          task (wrap($item[Hacienda key], 5) + " collected.");
        }

        break;

    }

  }

}

void M_nemesis_cleanup()
{

}

boolean M_nemesis()
{
  return false;
}
