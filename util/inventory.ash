import "util/print.ash";
import "util/util.ash";

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
	if((item_amount($item[Antique Accordion]) == 0) && !($classes[Accordion Thief, Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed] contains my_class()))
	{
		get_one($item[toy accordion]);
	}
}

void get_totem()
{
	while(item_amount($item[turtle totem]) == 0)
	{
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}
}

void get_saucepan()
{
	while(item_amount($item[saucepan]) == 0)
	{
		get_one($item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}

}
