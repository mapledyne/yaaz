boolean check_wads() {
  // if we don't have access to the Malus, there isn't much to do
  if (my_class() != $class[seal clubber] && my_class() != $class[turtle tamer])
    return false;
  // don't have access to the Malus currently, but may later.
  if (! have_skill($skill[pulverize]))
    return false;

  item tnug = $item[twinkly nuggets];
  item tpow = $item[twinkly powder];
  boolean ret = false;

  if (item_amount(tnug) > 4) {
    ret = true;
    print ('You can convert twinkly nuggets to wads.');
  }
  if (item_amount(tpow) > 4) {
    ret = true;
    print ('You can convert twinkly powder to nuggets.');
  }

  return ret;
}

int clover_cost() {
  // estimate the cost of a clover:
  item gum = $item[chewing gum on a string];
  int cost = npc_price(gum);
  item trinket = $item[worthless trinket];
  item gewgaw = $item[worthless gewgaw];
  item knick = $item[worthless knick-knack];

  if ((item_amount(trinket) + item_amount(gewgaw) + item_amount(knick)) > 0) {
    print('To reduce clover cost, put your worthless items in the closet.');
    print('This script assumes you\'ll do this, and will calculate accordingly.');
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
    print("You can still get hermit clovers today. Approximate cost: " + clover_cost() + " meat.");
    return true;
  }
  return false;
}
