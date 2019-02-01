import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";

int i_a(item it);
boolean have(item toy);
int wad_total();
void use_all(item it);
void pulverize_all(item it);
void pulverize_all(item it, int keep);
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
    counter += i_a(it);
  }
  return counter;
}

// a very simple way to check to see if we "have" something.
boolean have(item toy)
{
  if (item_amount(toy) > 0) return true;
  if (equipped_amount(toy) > 0) return true;

  return false;
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

// check to see if we have an outfit, ignoring requirements
// built-in have_outfit() will return false if we can't wear it.
boolean have_outfit_simple(string outfit)
{
  if (count(outfit_pieces(outfit)) == 0)
  {
    warning("Trying to check parts for outfit " + wrap(outfit, COLOR_ITEM) + ", but that doesn't appear to be valid.");
    wait(5);
    return false;
  }
  foreach key, part in outfit_pieces(outfit)
  {
    if (!have(part)) return false;
  }
  return true;
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

int maybe_pull(item it, int qty)
{

  if (to_boolean(setting("no_pulls", "false"))) return 0;

  int want = qty - i_a(it);
  if (want <= 0) return 0;

  want = min(want, pulls_remaining());
  if (want <= 0) return 0;

  want = min(want, storage_amount(it));
  if (want <= 0) return 0;

  // looks like we may actually be able to get a couple of these...?

  log("Pulling " + want + " " + wrap(it, want) + " from storage.");
  take_storage(want, it);
  progress(20 - pulls_remaining(), 20, "pulls from storage used");
  return want;
}

int maybe_pull(item it)
{
  return maybe_pull(it, 1);
}

void stash(item it, int keep)
{
  if (get_clan_name() == "") return;

  if (to_boolean(setting("no_dispose", "false"))) return;

  string config = setting("use_stash", "false");

  if (!to_boolean(config)) return;

  int num = item_amount(it) - keep;
  if (num <= 0) return;

  log("Adding " + num + " " + wrap(it, num) + " to the clan stash.");
  put_stash(num, it);
}

void pulverize_all(item it, int keep)
{
  if (to_boolean(setting("no_dispose", "false"))) return;

  int num = item_amount(it) - keep;
  if (num <= 0) return;

  string kp = "";

  if (keep > 0)
    kp = " (keeping " + keep + ")";

  if (!have_skill($skill[pulverize]))
  {
    log("Can't " + wrap($skill[pulverize]) + ", so instead selling " + num + " " + wrap(it, num) + kp + ".");
    autosell(num, it);
    return;
  }

	log("Pulverizing " + num + " " + wrap(it, num) + kp + ".");
	cli_execute("pulverize " + num + " " + it);
}

void pulverize_all(item it)
{
  pulverize_all(it, 0);
}

void pulverize_keep_if(item it, boolean keep_if)
{
	if (keep_if)
	{
		pulverize_all(it, 1);
	} else {
		pulverize_all(it);
	}
}

void closet(item it, int keep)
{
  if (to_boolean(setting("no_dispose", "false"))) return;

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

boolean have_or_get_all_wads()
{
  foreach wad in $items[twinkly wad, cold wad, hot wad, spooky wad, sleaze wad, stench wad]
  {
    if (item_amount(wad) == 0)
    {
      if (closet_amount(wad) == 0) return false;
      take_closet(1, wad);
    }
  }

  return true;
}

boolean have_all_wads()
{
	if (!have($item[twinkly wad]))
	 	return false;
	if (!have($item[cold wad]))
	 	return false;
	if (!have($item[hot wad]))
	 	return false;
	if (!have($item[spooky wad]))
	 	return false;
	if (!have($item[sleaze wad]))
	 	return false;
	if (!have($item[stench wad]))
		return false;

	return true;
}

item jim()
{
  if (have($item[Comfy Pillow]))
    return $item[Comfy Pillow];
  if (have($item[Sponge Cake]))
    return $item[Sponge Cake];
  return $item[none];
}

item flargwurm()
{
  if (have($item[Booze-Soaked Cherry]))
    return $item[Booze-Soaked Cherry];
  if (jim() != $item[sponge cake] && item_amount($item[sponge cake]) == 1)
    return $item[sponge cake];
  if (item_amount($item[sponge cake]) > 1)
    return $item[sponge cake];
  return $item[none];
}

item bognort()
{
  if (have($item[Giant Marshmallow]))
    return $item[Giant Marshmallow];
  if (have($item[Gin-Soaked Blotter Paper]))
    return $item[Gin-Soaked Blotter Paper];
  return $item[none];
}

item stinkface()
{
  if (have($item[Beer-Scented Teddy Bear]))
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
  if (!have($item[eleven-foot pole]))
    return false;
  if (!have($item[pick-o-matic lockpicks]))
    return false;
  if (!have($item[ring of detect boring doors]))
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
	if (have($item[McClusky file (complete)]))
		return 6;

	return count_set($items[McClusky file (page 1),
													McClusky file (page 2),
													McClusky file (page 3),
													McClusky file (page 4),
													McClusky file (page 5)]);
}

int ninja_snowman_items()
{
  return count_set($items[ninja rope,
                   ninja crampons,
                   ninja carabiner]);
}

int immateria()
{
	return count_set($items[gauze immateria,
													plastic wrap immateria,
													tissue paper immateria,
													tin foil immateria]);
}

int make_all(item it, string msg)
{
  int make = creatable_amount(it);
  if (make == 0) return 0;

  log("Making " + make + " " + wrap(it, make) + " " + msg);
  create(make, it);
  return make;
}

void make_if_needed(item it, string msg)
{
  if (!have(it) && creatable_amount(it) > 0)
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

item yellow_ray_item()
{
  foreach toy in $items[viral video]
  {
    if (have(toy)) return toy;
  }
  return $item[none];
}

boolean have_flyers()
{
  return (have($item[rock band flyers])
          || have($item[jam band flyers]));
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
  if (have($item[sneaky pete's key]))
    keys += 1;
  if (have($item[boris's key]))
    keys += 1;
  if (have($item[jarlsberg's key]))
    keys += 1;

  return keys;
}

void sell_coin_item(item it, int keep)
{
  if (to_boolean(setting("no_dispose", "false"))) return;

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
  if (is_coinmaster_item(it)
      && (it != $item[red zeppelin ticket]
          || have($item[priceless diamond])))
  {
    stock_coin_item(it, qty);
    return;
  }
  int total = qty - (item_amount(it) + equipped_amount(it));

  int price = npc_price(it);
  int meat_buffer = 2;

  if (price == 0 && can_interact())
  {
    price = historical_price(it);
  }

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

int grind(int qty, item it)
{
  // try to grind things instead of selling. Return how many we have left

  if (qty <= 0) return 0;

  if (!have($item[Kramco Sausage-o-Matic&trade;])) return qty;
  if (!be_good($item[Kramco Sausage-o-Matic&trade;])) return qty;
  int price = autosell_price(it);
  if (price == 0) return qty;
  if (!it.tradeable) return qty;
  if (!it.discardable) return qty;
  if (it.gift) return qty;

  // things that can't be ground, but we don't know how to programatically determine this:
  if ($items[fat stacks of cash, powdered organs, procrastination potion] contains it) return qty;

  int current = prop_int("_sausageGrinderUnits");

  if (current > to_int(setting("max_sausage_units", "5000"))) return qty;

  log("Off to grind " + qty + " " + wrap(it, qty));
  visit_url('inventory.php?action=grind');
  visit_url("choice.php?whichchoice=1339&option=1&qty=" + qty + "&iid=" + to_int(it));
  int gained = prop_int("_sausageGrinderUnits") - current;
  log("You just gained " + wrap(gained, COLOR_ITEM) + " grinder units (you now have " + wrap(get_property("_sausageGrinderUnits"), COLOR_ITEM) + ")");
  if (gained == 0)
  {
    debug("It looks like we tried to grind a " + wrap(it) + ", but since we didn't gain any grinder units, maybe it can't be used by this?");
    wait(5);
  }
  return 0;
}

void sell_all(item it, int keep)
{
  if (to_boolean(setting("no_dispose", "false"))) return;

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

  if (my_meat() > 5000) qty = grind(qty, it);

  if (qty <= 0) return;

  log("Selling " + qty + " " + wrap(pluralize(item_amount(it), it), COLOR_ITEM));
  int old_qty = item_amount(it);
  autosell(qty, it);

  if (item_amount(it) != old_qty - qty)
  {
    warning("I was unable to sell the " + wrap(it) + ". This could be because you have the item marked as a 'keep one' in the Mafia settings?");
  }
}

void sell_all(item it)
{
  sell_all(it, 0);
}

void sell_one(item it)
{
	if (!have(it))
		return;
	sell_all(it, item_amount(it) - 1);
}

void get_one(item it)
{
	if (have(it))
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


int palindome_items()
{
  int count = 0;
  foreach it in $items[photograph of a dog,
                       photograph of an ostrich egg,
                       photograph of a red nugget,
                       photograph of god,
                       [7262]&quot;I Love Me\, Vol. I&quot;]
  {
    if (have(it))
      count += 1;
  }
	return count;
}

int total_shadow_helpers()
{
  return item_amount($item[gauze garter]) + item_amount($item[filthy poultice]);
}
