import "util/inventory.ash";

void buy_things()
{
  stock_item($item[anti-anti-antidote], 3);

  stock_item($item[the big book of pirate insults]);
  if ((item_amount($item[dictionary]) + item_amount($item[abridged dictionary])) == 0)
  {
    stock_item($item[abridged dictionary]);
  }

  stock_item($item[gauze garter], 10 - item_amount($item[filthy poultice]));
  stock_item($item[filthy poultice], 10 - item_amount($item[gauze garter]));

  if (total_shadow_helpers() >= 10)
  {
    coinmaster master = $item[commemorative war stein].seller;
    int tokens = master. available_tokens;
    int qty = tokens / (sell_price(master, $item[commemorative war stein]));
    buy(master, qty, $item[commemorative war stein]);
  }
}
