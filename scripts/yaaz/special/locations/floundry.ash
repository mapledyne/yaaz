import "util/base/util.ash";
import "util/base/quests.ash";

string[6] floundry_fish;
floundry_fish[0] = "carp";
floundry_fish[1] = "cod";
floundry_fish[2] = "trout";
floundry_fish[3] = "bass";
floundry_fish[4] = "hatchetfish";
floundry_fish[5] = "tuna";

location[string] parse_holes() {
	//Determine where we can find the fish

  location[string] fishing_holes;

	string floundry = visit_url("clan_viplounge.php?action=floundry");
	matcher fish = create_matcher("<b>(carp|cod|trout|bass|hatchetfish|tuna):</b> ([^<]+)", floundry);

	while (fish.find()) {
		fishing_holes[fish.group(1)] = fish.group(2).to_location();
	}

  return fishing_holes;
}

boolean can_get_floundry_item()
{
  if (!have($item[fishin' pole]))
    return false;
	if (to_boolean(setting("floundry_skip", "false")))
		return false;
	// TODO: This parameter doesn't seem 100% reliable:
  if (to_boolean(get_property("_floundryItemUsed")))
    return false;

  return true;
}

item pick_floundry_item(boolean alt)
{
  if (!can_get_floundry_item())
    return $item[none];

    if (my_primestat() == $stat[muscle])
    {
			if (!alt)
      	return $item[fish hatchet];
			else
				return $item[bass clarinet];
    }
		if (!alt)
    	return $item[bass clarinet];
		else
			return $item[fish hatchet];
}

item pick_floundry_item()
{
	return pick_floundry_item(false);
}

int floundry_item_no(item it)
{
  switch (it)
  {
    default:
      warning("Trying to find the Floudry item for " + wrap(it) + ", but I don't think that's a Floundry item.");
      return 0;
    case $item[carpe]:
      return 9001;
    case $item[codpiece]:
      return 9002;
    case $item[troutsers]:
      return 9003;
    case $item[bass clarinet]:
      return 9004;
    case $item[fish hatchet]:
      return 9005;
    case $item[tunac]:
      return 9006;
  }
}

void maybe_use_fish(item it)
{
  switch(it)
  {
    default:
      break;
    case $item[fish hatchet]:
      log("Using the " + wrap(it) + ".");
      use(1, it);
      break;
    case $item[codpiece]:
      log("Wringing out the " + wrap(it) + ".");
      use (1, it);
      break;
    case $item[bass clarinet]:
      log("Draining spit from the " + wrap(it) + ".");
      use(1, it);
      break;
  }
}

item get_floundry_item(item it)
{
  if (it == $item[none])
    return $item[none];

  string url = 'clan_viplounge.php?preaction=buyfloundryitem&whichitem=';
  int num = floundry_item_no(it);

  if (num == 0)
  {
    warning("Cannot get a " + wrap(it) + " from the Floundry.");
    return $item[none];
  }
  int qty = item_amount(it);

  url += to_string(num);
  log("Attempting to get a " + wrap(it) + " from the " + wrap("Floundry", COLOR_LOCATION) + ".");
  visit_url(url);

  if (qty < item_amount(it))
  {
    log(wrap(it) + " made from the " + wrap("Floundry", COLOR_LOCATION) + ".");
    maybe_use_fish(it);
    return it;
  } else {
    log("Tried to get a " + wrap(it) + " from the " + wrap("Floundry", COLOR_LOCATION) + ", but I wasn't able to.");
    return $item[none];
  }
}

item get_floundry_item()
{
	int tries = to_int(setting("floundry_attempts", "0"));
	if (tries > 1)
	{
		warning("Tried to get a couple of things from the foundry but failed. It likely doesn't have enough fish for us.");
		save_daily_setting("floundry_skip", "true");
		return $item[none];
	}
	item fish;
	if (tries == 0)
			fish = pick_floundry_item();
	else
			fish = pick_floundry_item(true);
	save_daily_setting("floundry_attempts", tries + 1);
  fish = get_floundry_item(fish);
	if (fish == $item[none])
		return get_floundry_item();
	return fish;
}

void floundry_daily_check()
{

	// if we have values already ...
	if (setting("floundry_cod") != "")
		return;

  location[string] fishing_holes = parse_holes();
  foreach f in fishing_holes
  {
    save_daily_setting("floundry_" + f, fishing_holes[f]);
  }
}

void floundry()
{

  floundry_daily_check();

  if (!can_get_floundry_item())
    return;

  if (quest_status("questL13Final") == UNSTARTED)
	  get_floundry_item();
}

boolean is_fishing_hole(location loc)
{
  if (!have($item[fishin' pole]))
    return false;

  floundry_daily_check();
  foreach f in floundry_fish
  {
    location hole = to_location(setting("floundry_" + floundry_fish[f]));
    if (loc == hole)
      return true;
  }
  return false;
}

void main()
{
  floundry();
}
