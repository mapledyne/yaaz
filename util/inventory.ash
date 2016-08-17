import "util/print.ash";
import "util/util.ash";

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

  while (total > 0 && master.available_tokens > price)
  {
    buy(master, 1, it);
    total = total - 1;
  }
}

void stock_item(item it, int qty)
{
  if (is_coinmaster_item(it))
  {
    stock_coin_item(it, qty);
    return;
  }

  int total = qty - item_amount(it);
  int price = npc_price(it);
  int meat_buffer = 10;

  if (total <= 0 || price == 0)
    return;

  if ((price * total) < (my_meat() * meat_buffer))
  {
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
	if((i_a($item[Antique Accordion]) == 0) && (i_a($item[toy accordion]) == 0) && my_meat() > 300 && !($classes[Accordion Thief, Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed] contains my_class()))
	{
    log("Getting an accordion.");
		get_one($item[toy accordion]);
	}
}

void get_totem()
{
	while(i_a($item[turtle totem]) == 0 && my_meat() > 300)
	{
    log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap($item[turtle totem]) + ".");
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}
}

void get_saucepan()
{
	while(i_a($item[saucepan]) == 0 && my_meat() > 300)
	{
    log("Using a " + wrap($item[chewing gum on a string]) + " in hopes to find a " + wrap($item[saucepan]) + ".");
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}

}

int total_shadow_helpers()
{
  return item_amount($item[gauze garter]) + item_amount($item[filthy poultice]);
}
