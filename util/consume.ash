import "util/print.ash";
import "util/util.ash";

boolean is_spleen_item(item it);
int spleen_remaining();
float adv_per_consumption(item it);


float adv_per_consumption(item it)
{
  if (it.levelreq > my_level())
    return 0;

  if (is_spleen_item(it))
  {
    if (it.spleen > spleen_remaining())
      return 0;
    return average_range(it.adventures) / to_float(it.spleen);
  }

  return 0;
}

int spleen_remaining()
{
  return spleen_limit() - my_spleen_use();
}

boolean is_spleen_item(item it)
{
  if (it.spleen > 0)
    return true;
  return false;
}

int spleen_cost(item it)
{
  return it.spleen;
}

boolean can_chew(item it)
{
  if (item_amount(it) == 0)
    return false;
  if (!is_spleen_item(it))
    return false;
  if (spleen_cost(it) > spleen_remaining())
    return false;
  return true;
}

boolean try_chew(item it)
{
  if (!can_chew(it))
    return false;
  log("Chewing a " + wrap(it) + ".");
  return chew(1, it);
}

void chew_all(item it)
{
  while(try_chew(it))
  {
    // work in try_chew()
  }
}

void spleen()
{
  // things we feel comfortable using immediately:
  chew_all($item[astral energy drink]);
  chew_all($item[homeopathic mint tea]);
}

void max_spleen()
{
  // give the default stuff priority:
  spleen();

  float[item] spleens;
  int[item] inventory = get_inventory();
  foreach it in inventory
  {
    if (!is_spleen_item(it))
      continue;

    float avg = adv_per_consumption(it);

    if (avg == 0)
      continue;

    spleens[it] = avg;
  }
  sort spleens by value;

  foreach s in spleens
  {
    log("Spleen: " + wrap(s) + " value is: " + spleens[s]);
  }


}

void max_consumption()
{
  // use up all of our space.
  max_spleen();

}

void drink_irresponibly()
{
  // overdrink.

  // doing this in this here vs max_consumption.
  // This way if max_consumption() makes enough turns to then
  // generate more speen items, they can be used. Here this will
  // only fire if we're truly near end-of-day and have the room:
  if (spleen_remaining() >= 5 && hippy_stone_broken() && my_meat() > 1000)
  {
    log("Chewing a " + $item[hatorade] + " for extra pvp.");
    cli_execute("chew hatorade");
  }

}

void consume()
{
  spleen();

}

void main()
{
  max_consumption();
}
