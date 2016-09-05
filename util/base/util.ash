import "util/base/print.ash";
import <zlib.ash>;

float frequency_of_monster(location loc, monster mon);
boolean bit_flag(int progress, int c);
boolean drunk();
boolean guild_class();
float avg_meat_per_adv(location loc);
float cost_per_mp();
boolean guild_store_open();
int count_set(boolean[item] things);
float average_range(string avg);
boolean can_adventure();

string SCRIPT = "yaaz";

int abort_on_advs_left = 3;

boolean can_adventure()
{
  if (my_adventures() <= abort_on_advs_left)
    return false;
  if (my_inebriety() > inebriety_limit())
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
