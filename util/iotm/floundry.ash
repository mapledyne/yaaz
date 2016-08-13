import "util/util.ash";

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
  if (item_amount($item[fishin' pole]) == 0)
    return false;
  if (to_boolean(get_property("_floundryItemUsed")))
    return false;

  return true;
}

item pick_floundry_item()
{
  if (!can_get_floundry_item())
    return $item[none];

    if (my_primestat() == $stat[muscle])
    {
      return $item[fish hatchet];
    }
    return $item[bass clarinet];
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
  return get_floundry_item(pick_floundry_item());
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

  if (!can_get_floundry_item())
    return;

  floundry_daily_check();

  get_floundry_item();
}

boolean is_fishing_hole(location loc)
{
  if (item_amount($item[fishin' pole]) == 0)
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
