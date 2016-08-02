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
	return (progress & (1 << c)) != 0;
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

int clover_cost() {
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


boolean check_clovers() {
  //Hermit clovers
  string body = visit_url("/hermit.php");
  if(contains_text(body,"left in stock")) {
    log("You can still get hermit clovers today. Approximate cost: " + clover_cost() + " meat.");
    return true;
  }
  return false;
}
