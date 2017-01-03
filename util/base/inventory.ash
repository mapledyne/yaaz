import "util/base/print.ash";
import "util/base/util.ash";
import "util/base/settings.ash";

int i_a(item it);
int wad_total();
void use_all(item it);
void pulverize_all(item it);
void pulverize_all_but_one(item it);
void pulverize_keep_if(item it, boolean keep_if);
int immateria();
int palindome_items();
item spooky_quest_item();
void make_if_needed(item it, string msg);
void make_if_needed(item it);

int count_set(boolean[item] things)
{
  int counter = 0;
  foreach it in things
  {
    counter += item_amount(it);
  }
  return counter;
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

void use_all(item it, int keep)
{
	int count = item_amount(it) - keep; // use item_amount() instead of i_a() to protect closet things and such.
	if (count < 1)
		return;
  if (!be_good(it))
    return;
	log("Using " + count + " " + wrap(it, count) + ".");
	use(count, it);
}

void use_all(item it)
{
	use_all(it, 0);
}

boolean should_pulverize()
{
  boolean config = to_boolean(setting("aggresive_pulverize", "false"));
  if (config) return true;

  // artificial limiter - why make more wads if we're swimming in them?
  if (wad_total() < (spleen_limit() * 3))
    return true;

  return false;
}

void stash(item it, int keep)
{
  string config = setting("use_stash", "z");
  if (config == "z")
  {
    config = "false";
    log("Please set the variable " + wrap(SETTING_PREFIX + "_use_stash", COLOR_ITEM) + " to 'true' or 'false'");
    log("Setting to 'true' will add the items in clan.txt to the clan stash.");
    wait(5);
    save_daily_setting("use_stash", "false");
  }
  if (!to_boolean(config)) return;

  int num = item_amount(it) - keep;
  if (num <= 0) return;

  log("Adding " + num + " " + wrap(it, num) + " to the clan stash.");
  put_stash(num, it);
}

void pulverize(item it, int keep)
{
  if (!should_pulverize()) return;
  int num = item_amount(it) - keep;
  if (num <= 0) return;

  string kp = "";

  if (keep > 0)
    kp = " (keeping " + keep + ")";

	log("Pulverizing " + num + " " + wrap(it, num) + kp + ".");
	cli_execute("pulverize " + num + " " + it);
}

void pulverize_all(item it)
{
  pulverize(it, 0);
}

void pulverize_all_but_one(item it)
{
  pulverize(it, 1);
}

void pulverize(item it)
{
  if (!should_pulverize()) return;
  if (item_amount(it) == 0) return;

	log("Pulverizing 1 " + wrap(it) + ".");
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

void closet(item it, int keep)
{
	int qty = item_amount(it) - keep;
	if (qty < 1)
		return;
	log("Putting " + qty + " " + wrap(it, qty) + " in the closet to reduce clutter.");
	put_closet(qty, it);
}

int wad_total()
{
	return item_amount($item[twinkly wad]) + item_amount($item[cold wad]) + item_amount($item[hot wad]) + item_amount($item[spooky wad]) + item_amount($item[sleaze wad]) + item_amount($item[stench wad]);
}

boolean have_all_wads()
{
	if (item_amount($item[twinkly wad]) == 0)
	 	return false;
	if (item_amount($item[cold wad]) == 0)
	 	return false;
	if (item_amount($item[hot wad]) == 0)
	 	return false;
	if (item_amount($item[spooky wad]) == 0)
	 	return false;
	if (item_amount($item[sleaze wad]) == 0)
	 	return false;
	if (item_amount($item[stench wad]) == 0)
		return false;

	return true;
}

item jim()
{
  if (item_amount($item[Comfy Pillow]) > 0)
    return $item[Comfy Pillow];
  if (item_amount($item[Sponge Cake]) > 0)
    return $item[Sponge Cake];
  return $item[none];
}

item flargwurm()
{
  if (item_amount($item[Booze-Soaked Cherry]) > 0)
    return $item[Booze-Soaked Cherry];
  if (jim() != $item[sponge cake] && item_amount($item[sponge cake]) == 1)
    return $item[sponge cake];
  if (item_amount($item[sponge cake]) > 1)
    return $item[sponge cake];
  return $item[none];
}

item bognort()
{
  if (item_amount($item[Giant Marshmallow]) > 0)
    return $item[Giant Marshmallow];
  if (item_amount($item[Gin-Soaked Blotter Paper]) > 0)
    return $item[Gin-Soaked Blotter Paper];
  return $item[none];
}

item stinkface()
{
  if (item_amount($item[Beer-Scented Teddy Bear]) > 0)
    return $item[Beer-Scented Teddy Bear];
  if (bognort() != $item[Gin-Soaked Blotter Paper] && item_amount($item[Gin-Soaked Blotter Paper]) == 1)
    return $item[Gin-Soaked Blotter Paper];
  if (item_amount($item[Gin-Soaked Blotter Paper]) > 1)
    return $item[Gin-Soaked Blotter Paper];
  return $item[none];
}


int backstage_items()
{
  int count = 0;
  if (jim() != $item[none])
    count += 1;
  if (flargwurm() != $item[none])
    count += 1;
  if (bognort() != $item[none])
    count += 1;
  if (stinkface() != $item[none])
    count += 1;

  return count;
}

int turners()
{
  return item_amount($item[crumbling wooden wheel]) + item_amount($item[tomb ratchet]);
}

boolean have_cubeling_items()
{
  if (i_a($item[eleven-foot pole]) == 0)
    return false;
  if (i_a($item[pick-o-matic lockpicks]) == 0)
    return false;
  if (i_a($item[ring of detect boring doors]) == 0)
    return false;

  return true;
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

int scavenger_hunt_items()
{
	return count_set($items[loosening powder,
													powdered castoreum,
													drain dissolver,
													triple-distilled turpentine,
													detartrated anhydrous sublicalc,
													triatomaceous dust]);
}

int mcclusky_items()
{
	if (item_amount($item[McClusky file (complete)]) > 0)
		return 6;

	return count_set($items[McClusky file (page 1),
													McClusky file (page 2),
													McClusky file (page 3),
													McClusky file (page 4),
													McClusky file (page 5)]);
}

int ninja_snowman_items()
{
	int ninja = 0;

	foreach toy in $items[ninja rope, ninja crampons, ninja carabiner]
	{
		if (item_amount(toy) > 0)
			ninja += 1;
	}
	return ninja;
}

int immateria()
{
	return count_set($items[gauze immateria,
													plastic wrap immateria,
													tissue paper immateria,
													tin foil immateria]);
}

void make_if_needed(item it, string msg)
{
  if (i_a(it) == 0 && creatable_amount(it) > 0)
  {
    if (msg != "")
    {
      log("Making " + wrap(it) + " " + msg);
    }
    create(1, it);
  }
}

void make_if_needed(item it)
{
  make_if_needed(it, "");
}


boolean have_yellow_ray()
{
  return false;
}

item yellow_ray_item()
{
  return $item[none];
}

boolean have_flyers()
{
  return (item_amount($item[rock band flyers]) > 0 || item_amount($item[jam band flyers]) > 0);
}

int friar_things()
{

	return count_set($items[dodecagram,
													box of birthday candles,
													eldritch butterknife]);
}

int junkyard_items()
{
  return i_a($item[molybdenum hammer]) + i_a($item[molybdenum crescent wrench]) + i_a($item[molybdenum pliers]) + i_a($item[molybdenum screwdriver]);
}

int dancing_items()
{
  return item_amount($item[lady spookyraven's powder puff]) + item_amount($item[lady spookyraven's dancing shoes]) + item_amount($item[lady spookyraven's finest gown]);
}

int total_clovers()
{
	return item_amount($item[ten-leaf clover]) + item_amount($item[disassembled clover]);
}

int hero_keys()
{
  int keys = 0;
  if (item_amount($item[sneaky pete's key]) > 0)
    keys += 1;
  if (item_amount($item[boris's key]) > 0)
    keys += 1;
  if (item_amount($item[jarlsberg's key]) > 0)
    keys += 1;

  return keys;
}

void sell_coin_item(item it, int keep)
{
  if(it.buyer == $coinmaster[none])
  {
    warning("Trying to sell " + wrap(it) + " to a coinmaster, but it's not that sort of item.");
    return;
  }
  coinmaster master = it.buyer;
  if (!is_accessible(master))
    return;

  int qty = item_amount(it) - keep;
  if (qty < 1)
    return;

  log("Selling " + wrap(it) + " to the " + wrap(master) + ".");
  sell(master, qty, it);
}

void sell_coin_item(item it)
{
  sell_coin_item(it, 0);
}

void stock_coin_item(item it, int qty)
{
  if (!is_coinmaster_item(it))
  {
    return;
  }

  coinmaster master = it.seller;
  if (!is_accessible(master))
  {
    return;
  }
  int total = qty - item_amount(it);
  int price = sell_price(master, it);
	int tokens = master.available_tokens;

	if (tokens < total * price)
	{
		total = tokens / price;
	}

	if (total > 0)
	{
		log("Buying " + total + " "  + wrap(it, total) + " from the " + wrap(master) + ".");
		buy(master, total, it);
	}
}

void stock_item(item it, int qty)
{
  if (is_coinmaster_item(it))
  {
    stock_coin_item(it, qty);
    return;
  }

  int total = qty - (item_amount(it) + equipped_amount(it));

  int price = npc_price(it);
  int meat_buffer = 10;

  if (total <= 0 || price == 0)
    return;

  if ((price * total * meat_buffer) < my_meat())
  {
    log("Buying " + total + " "  + wrap(it, total) + ".");
    buy(total, it);
  }

}

void stock_item(item it)
{
  stock_item(it, 1);
}

void sell_all(item it, int keep)
{
  // handle coinmaster items differently:
  if (it.buyer != $coinmaster[none])
  {
    sell_coin_item(it, keep);
    return;
  }

  // don't actually sell things for meat on Fist paths:
  if (my_path() == "Way of the Surprising Fist")
    return;

  int qty = item_amount(it) - keep;
  if (qty <= 0)
    return;
  log("Selling " + qty + " " + wrap(pluralize(item_amount(it), it), COLOR_ITEM));
  autosell(qty, it);
}

void sell_all(item it)
{
  sell_all(it, 0);
}

void sell_one(item it)
{
	if (item_amount(it) == 0)
		return;
	sell_all(it, item_amount(it) - 1);
}

void get_one(item it)
{
	if (item_amount(it) > 0)
		return;
	if (!is_npc_item(it))
	{
		error("get_one() only supports NPC items currently, and " + wrap(it) + " isn't one.");
		return;
	}
	int price = npc_price(it);
	if (price == 0)
	{
		warning("Trying to buy a " + wrap(it) + " but it's not available to buy right now. Sad.");
		return;
	}

	if (price > my_meat())
	{
		warning("You don't have enough meat to buy " + wrap(it) + ". Sad.");
		return;
	}

	log("Buying one " + wrap(it) + ".");
	buy(1, it);
}

void get_accordion()
{
  if (npc_price($item[toy accordion]) == 0)
    return;
	if((i_a($item[Antique Accordion]) == 0) && (i_a($item[toy accordion]) == 0) && my_meat() > 300 && !($classes[Accordion Thief, Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed] contains my_class()))
	{
    log("Getting an accordion.");
		get_one($item[toy accordion]);
	}
}

void get_totem()
{
  if (npc_price($item[chewing gum on a string]) == 0)
    return;
	while(i_a($item[turtle totem]) == 0 && my_meat() > 300)
	{
    log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap($item[turtle totem]) + ".");
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}
}

void get_saucepan()
{
  if (npc_price($item[chewing gum on a string]) == 0)
    return;
	while(i_a($item[saucepan]) == 0 && my_meat() > 300)
	{
    log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap($item[saucepan]) + ".");
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}

}

int palindome_items()
{
  int count = 0;
  foreach it in $items[photograph of a dog,
                       photograph of an ostrich egg,
                       photograph of a red nugget,
                       photograph of god,
                       [7262]&quot;I Love Me\, Vol. I&quot;]
  {
    if (item_amount(it) > 0)
      count += 1;
  }
	return count;
}

int total_shadow_helpers()
{
  return item_amount($item[gauze garter]) + item_amount($item[filthy poultice]);
}

boolean is_rollover(item i)
{
  if (i == $item[none])
    return false;

  float mod = numeric_modifier(i, "Adventures") + numeric_modifier(i, "PvP Fights");

  if (i == $item[your cowboy boots])
  {
    if (equipped_item($slot[bootspur]) == $item[ticksilver spurs])
    {
      mod = mod + 5;
    }
  }
  return mod > 0;
}

void remove_non_rollover(slot s)
{
  if (!is_rollover(equipped_item(s)))
  {
    equip(s, $item[none]);
  }
}

void remove_non_rollover()
{
  remove_non_rollover($slot[hat]);
  remove_non_rollover($slot[weapon]);
  remove_non_rollover($slot[off-hand]);
  remove_non_rollover($slot[back]);
  remove_non_rollover($slot[shirt]);
  remove_non_rollover($slot[pants]);
  remove_non_rollover($slot[acc1]);
  remove_non_rollover($slot[acc2]);
  remove_non_rollover($slot[acc3]);
}
