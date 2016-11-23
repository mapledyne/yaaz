import "util/base/print.ash";
boolean quest_active(string quest);
int quest_status(string quest);

int FINISHED = 100;
int UNSTARTED = -1;
int STARTED = 0;


boolean quest_active(string quest)
{
  int q = quest_status(quest);
  return (q > UNSTARTED && q < FINISHED);
}

int quest_status(string quest)
{
	string progress = get_property(quest);
	if (progress == "unstarted")
	{
		return -1;
	}
	if (progress == "started")
	{
		return 0;
	}
	if (progress == "finished")
	{
		return FINISHED;
	}

	for i from 1 to 26
	{
		string st = "step" + to_string(i);
		if (progress == st)
		{
			return i;
		}
	}
	return -1;
}

boolean start_galaktik()
{
	if(quest_status("questM24Doc") == UNSTARTED && my_path() != "Nuclear Autumn")
	{
    log("Starting the " + wrap("Doc Galaktik", COLOR_LOCATION) + " to open " + wrap($location[the overgrown lot]) + ".");
		string temp = visit_url("shop.php?whichshop=doc");
		temp = visit_url("shop.php?whichshop=doc&action=talk");
		temp = visit_url("choice.php?pwd=&whichchoice=1064&option=1");
		return true;
	}
	return false;
}

int pirate_insults()
{
  int count = 0;
  for x from 1 to 8
  {
    string insult = 'lastPirateInsult' + x;
    if (to_boolean(get_property(insult)))
    {
      count += 1;
    }
  }
  return count;
}
