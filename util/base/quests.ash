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
