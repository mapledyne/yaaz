import "util/print.ash";

int i_a(string name) {
	item i = to_item(name);
	int a = item_amount(i) + closet_amount(i) + equipped_amount(i);

	//Make a check for familiar equipment NOT equipped on the current familiar.
	foreach fam in $familiars[] {
		if (have_familiar(fam) && fam != my_familiar()) {
			if (name == to_string(familiar_equipped_equipment(fam)) && name != "none") {
				a = a + 1;
			}
		}
	}
	return a;
}

boolean bit_flag(int progress, int c) {
	return (progress & (1 << c)) == 0;
}

boolean drunk()
{
	return my_inebriety() > inebriety_limit();
}

boolean guild_class()
{
	return ($classes[Seal Clubber, Turtle Tamer, Sauceror, Pastamancer, Disco Bandit, Accordion Thief] contains my_class());
}

int wad_total()
{
	return item_amount($item[cold wad]) + item_amount($item[hot wad]) + item_amount($item[spooky wad]) + item_amount($item[sleaze wad]) + item_amount($item[stench wad]);
}

void use_all(item it)
{
  int count = item_amount(it); // use item_amount() instead of i_a() to protect closet things and such.
  if (count == 0)
    return;
  log("Using " + count + " " + wrap(pluralize(count, it), COLOR_ITEM) + ".");
  use(count, it);
}

void pulverize_all(item it)
{
	if (item_amount(it) > 0)
		cli_execute("pulverize " + item_amount(it) + " " + it);
}

void pulverize_all_but_one(item it)
{
	if (item_amount(it) > 1)
		cli_execute("pulverize " + (item_amount(it)-1) + " " + it);
}

void pulverize(item it)
{
	cli_execute("pulverize " + it);
}

void pulverize_keep_if(item it, boolean keep_if)
{
	if (keep_if)
	{
		pulverize_all_but_one(it);
	} else {
		pulverize_all(it);
	}
}


boolean quest_status(string prop, string target) {
   string currp = get_property(prop);
   if (currp == "unstarted") return false;
   if (target == currp || currp == "finished") return true;
   string s;
   for i from 0 upto 26 {  // nemesis quest has 26 steps (think it's the most atm)
      s = (i == 0) ? "started" : "step"+to_string(i);
      if (s == currp) break;
      if (s == target) return true;
   }
   return false;
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
		return 100;
	}

	for i from 1 to 26
	{
		string st = "step" + to_string(i);
		if (progress == st)
		{
			return i;
		}
	}
	warning("Unable to determine quest status for quest " + quest + ". Progress status is set to " + progress + ".");
	return -1;
}
