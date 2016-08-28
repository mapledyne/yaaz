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

  // spend BACON on things for future use:
  if(setting("bought_viral_video") == "" && item_amount($item[BACON]) > 20 && item_amount($item[viral video]) < 2)
  {
    log("Picking up a " + wrap($item[viral video]) + " for use later.");
    cli_execute("acquire viral video");
    save_daily_setting("bought_viral_video", "true");
  }

  if(setting("bought_print_screen") == "" && item_amount($item[BACON]) > 111 && item_amount($item[print screen button]) < 2)
  {
    log("Picking up a " + wrap($item[print screen button]) + " for use later.");
    cli_execute("acquire print screen button");
    save_daily_setting("bought_print_screen", "true");
  }

  if (get_property("lastGoofballBuy") < my_ascensions() && quest_status("questL03Rat") == FINISHED)
  {
    // once per ascension
    log("Getting some " + wrap($item[bottle of goofballs]) + ". They're free!");
    cli_execute("acquire bottle of goofballs");
  }
}
