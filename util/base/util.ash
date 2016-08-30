import "util/base/print.ash";
import <zlib.ash>;

int FINISHED = 100;
int UNSTARTED = -1;
int STARTED = 0;

float frequency_of_monster(location loc, monster mon);
int i_a(string name);
int i_a(item it);
boolean bit_flag(int progress, int c);
boolean drunk();
boolean guild_class();
int wad_total();
void use_all(item it);
void pulverize_all(item it);
void pulverize_all_but_one(item it);
void pulverize(item it);
void pulverize_keep_if(item it, boolean keep_if);
int quest_status(string quest);
int clover_cost();
boolean check_clovers();
float avg_meat_per_adv(location loc);
float cost_per_mp();
string setting(string value, string def);
string setting(string value);
item spooky_quest_item();
boolean guild_store_open();
int count_set(boolean[item] things);
float average_range(string avg);
boolean can_adventure();

int abort_on_advs_left = 3;

boolean can_adventure()
{
  if (my_adventures() <= abort_on_advs_left)
    return false;
  if (my_inebriety() >= inebriety_limit())
    return false;
  return true;
}

float average_range(string avg)
{
  // turns strings like "1-5" into the average of the string ("3")
  // useful for things like consumables which sometimes express
  // values as ranges (adventures for food, for instance)

  if (!contains_text(avg, "-"))
    return to_float(avg);

  string[int] avgs = split_string(avg, "-");
  return ((to_int(avgs[0]) + to_int(avgs[1])) / 2);
}

int count_set(boolean[item] things)
{
  int counter = 0;
  foreach it in things
  {
    counter += item_amount(it);
  }
  return counter;
}

boolean guild_store_open()
{
  return (get_property("lastGuildStoreOpen").to_int() == my_ascensions());
}

item spooky_quest_item()
{
  switch (my_class())
  {
    case $class[seal clubber]:
    case $class[avatar of boris]:
      return $item[tattered wolf standard];
    case $class[turtle tamer]:
      return $item[tattered snake standard];
    case $class[pastamancer]:
    case $class[sauceror]:
      return $item[english to a. f. u. e. dictionary];
    case $class[disco bandit]:
    case $class[accordion thief]:
      return $item[bizarre illegible sheet music];
    default:
      return $item[none];
  }
}

string setting(string value, string def)
{
  // daily values override permanent ones:
  string prop = get_property("_dg_" + value);
  if (prop != "")
    return prop;

  prop = get_property("dg_" + value);
  if (prop != "")
    return prop;

  return def;
}

string setting(string value)
{
  return setting(value, "");
}

string save_setting(string key, string value)
{
  set_property("dg_" + key, value);
  return value;
}

string save_daily_setting(string key, string value)
{
  set_property("_dg_" + key, value);
  return value;
}

float cost_per_mp()
{
  if (my_class() == $class[Pastamancer] || my_class() == $class[Sauceror] || (my_class() == $class[accordion thief] && my_level() >= 9))
  {
    // has access to MMJ
    int cost = npc_price($item[magical mystery juice]);
    float restore =  (1.5 * my_level()) + 5;
    return cost/restore;
  }
  return 17.5; // soda water
}

float avg_meat_per_adv(location loc)
{
  monster [int] monster_list = get_monsters(loc);
  float avg_meat = 0;
  int counter = 0;
  foreach i in monster_list {
     avg_meat += (meat_drop(monster_list[i]) * frequency_of_monster(loc, monster_list[i]) / 100);
  }
  return avg_meat;
}

float frequency_of_monster(location loc, monster mon)
{
  foreach mob, freq in appearance_rates(loc)
  {
    if (mob == mon)
    {
      return freq;
    }
  }
  warning("Looking for monster (" + wrap(mon) + ") frequency at " + wrap(loc) + ", but couldn't find monster.");
  return 0;
}

int i_a(string name)
{
	item it = to_item(name);
	if (it == $item[none])
	{
		return 0;
	}
	return i_a(it);
}

int i_a(item i)
{
	int a = item_amount(i) + closet_amount(i) + equipped_amount(i);

	//Make a check for familiar equipment NOT equipped on the current familiar.
	foreach fam in $familiars[] {
		if (have_familiar(fam) && fam != my_familiar()) {
			if (i == familiar_equipped_equipment(fam) && i != $item[none])
      {
				a = a + 1;
			}
		}
	}
	return a;
}

boolean bit_flag(int progress, int c)
{
	return (progress & (1 << c)) != 0;
}

boolean drunk()
{
	return my_inebriety() > inebriety_limit();
}

boolean is_guild_class()
{
	return ($classes[Seal Clubber, Turtle Tamer, Sauceror, Pastamancer, Disco Bandit, Accordion Thief] contains my_class());
}

int wad_total()
{
	return item_amount($item[twinkly wad]) + item_amount($item[cold wad]) + item_amount($item[hot wad]) + item_amount($item[spooky wad]) + item_amount($item[sleaze wad]) + item_amount($item[stench wad]);
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
	// artificial limiter - why make more wads if we're swimming in them?
	if (wad_total() < spleen_limit() * 2 && item_amount(it) > 0)
		cli_execute("pulverize " + item_amount(it) + " " + it);
}

void pulverize_all_but_one(item it)
{
	// artificial limiter - why make more wads if we're swimming in them?
	if (wad_total() < spleen_limit() * 2 && item_amount(it) > 1)
		cli_execute("pulverize " + (item_amount(it)-1) + " " + it);
}

void pulverize(item it)
{
	// artificial limiter - why make more wads if we're swimming in them?
	if (wad_total() < spleen_limit() * 2 && item_amount(it) > 0)
		cli_execute("pulverize 1 " + it);
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
	warning("Unable to determine quest status for quest " + quest + ". Progress status is set to " + progress + ".");
	return -1;
}

int clover_cost()
{
  // estimate the cost of a clover:
  item gum = $item[chewing gum on a string];
  int cost = npc_price(gum);
  item trinket = $item[worthless trinket];
  item gewgaw = $item[worthless gewgaw];
  item knick = $item[worthless knick-knack];

  if ((item_amount(trinket) + item_amount(gewgaw) + item_amount(knick)) > 0) {
    warning('To reduce clover cost, put your worthless items in the closet.');
    warning('This script assumes you\'ll do this, and will calculate accordingly.');
  }
  int own = 0;
  if (i_a("old sweatpants") > 0)
    own = own + 1;
  if (i_a("stolen accordion") > 0)
    own = own + 1;
  if (i_a("mariachi hat") > 0)
    own = own + 1;
  if (i_a("disco ball") > 0)
    own = own + 1;
  if (i_a("disco mask") > 0)
    own = own + 1;
  if (i_a("saucepan") > 0)
    own = own + 1;
  if (i_a("[Hollandaise helmet") > 0)
    own = own + 1;
  if (i_a("pasta spoon") > 0)
    own = own + 1;
  if (i_a("ravioli hat") > 0)
    own = own + 1;
  if (i_a("turtle totem") > 0)
    own = own + 1;
  if (i_a("helmet turtle") > 0)
    own = own + 1;
  if (i_a("seal-skull helmet") > 0)
    own = own + 1;
  if (i_a("seal-clubbing club") > 0)
    own = own + 1;

	int est_cost = (((16-own)*cost)/3);
  return est_cost;
}


boolean check_clovers()
{
  //Hermit clovers
  string body = visit_url("/hermit.php");
  if(contains_text(body,"left in stock")) {
    log("You can still get hermit clovers today. Approximate cost: " + clover_cost() + " meat.");
    return true;
  }
  return false;
}
