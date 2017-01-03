import "util/base/print.ash";
import <zlib.ash>;

float frequency_of_monster(location loc, monster mon);
boolean bit_flag(int progress, int c);
boolean guild_class();
float avg_meat_per_adv(location loc);
float cost_per_mp();
boolean guild_store_open();
float average_range(string avg);
boolean can_adventure();

// these really should be in effects.ash, but are here to avoid an import loop.
// Need to sort this sort of problem out sometime...
void uneffect(effect ef);
void uneffect_song();
boolean is_song(skill sk);
boolean is_song(effect ef);
int songs_in_head();
int max_songs();
boolean can_cast_song();


string SCRIPT = "yaaz";
string DATA_DIR = "scripts/" + SCRIPT + "/util/data/";

int abort_on_advs_left = 3;

int smiles_remaining()
{

  int total_casts_available = to_int(get_property("goldenMrAccessories")) * 5;
  int casts_used = to_int(get_property("_smilesOfMrA"));

  return total_casts_available - casts_used;
}

int total_smiles()
{
	return to_int(get_property("goldenMrAccessories")) * 5;
}

int elemental_resitance(element goal)
{
	return numeric_modifier(goal + " resistance");
}

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
  return 0;
}

boolean bit_flag(int progress, int c)
{
	return (progress & (1 << c)) != 0;
}

boolean is_guild_class()
{
	return ($classes[Seal Clubber, Turtle Tamer, Sauceror, Pastamancer, Disco Bandit, Accordion Thief] contains my_class());
}

skill thrall_to_skill(thrall slave)
{
  skill sk = $skill[none];
  switch(slave)
  {
    case $thrall[lasagmbie]:
      return $skill[bind lasagmbie];
    case $thrall[Spice Ghost]:
      return $skill[bind Spice Ghost];
    case $thrall[Angel Hair Wisp]:
      return $skill[bind Angel Hair Wisp];
    case $thrall[Vermincelli]:
      return $skill[bind Vermincelli];
    case $thrall[Spaghetti Elemental]:
      return $skill[bind Spaghetti Elemental];
    case $thrall[Vampieroghi]:
      return $skill[bind Vampieroghi];
    case $thrall[Penne Dreadful]:
      return $skill[bind Penne Dreadful];
    case $thrall[Elbow Macaroni]:
      return $skill[bind undead Elbow Macaroni];

    default:
      return $skill[none];
  }
}

boolean is_song(skill sk)
{
  return (sk.class == $class[accordion thief] && sk.buff);
}

boolean is_song(effect ef)
{
  skill sk = to_skill(ef);
  return is_song(sk);
}

int songs_in_head()
{
  int count = 0;
  foreach buff in my_effects()
  {
    if (is_song(buff))
      count++;
  }
  return count;
}

int max_songs()
{
  // this obviously could be handled better...
  if (have_skill($skill[mariachi memory])) return 4;
  return 3;
}

boolean can_cast_song()
{
  return songs_in_head() < max_songs();
}

void uneffect_song()
{
  effect song = $effect[none];
  foreach ef in my_effects()
  {
    if (!is_song(ef)) continue;
    if (have_effect(ef) < have_effect(song) || song == $effect[none])
    {
      song = ef;
    }
  }
  uneffect(song);
}

boolean uneffect(effect ef)
{
	if(have_effect(ef) == 0)
		return true;

	if(cli_execute("uneffect " + ef))
		return true;

  if (ef == $effect[beaten up] && have_effect(ef) > 0)
  {
    // not great, but don't have a better plan right now.
    log("Unsure how else to get rid of " + wrap(ef) + ", so going to take a quick rest.");
    wait(3);
    cli_execute("rest");
  }

	if(item_amount($item[Soft Green Echo Eyedrop Antidote]) > 0)
	{
    log("Removing the effect " + wrap(ef) + " with a " + wrap($item[Soft Green Echo Eyedrop Antidote]) + ".");
		visit_url("uneffect.php?pwd=&using=Yep.&whicheffect=" + to_int(ef));
		return true;
	}
	return false;
}
