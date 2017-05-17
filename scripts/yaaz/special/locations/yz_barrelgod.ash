import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";

void barrelgod_progress()
{

}

void barrelgod()
{
  if(!get_property("barrelShrineUnlocked").to_boolean())
  {
    return;
  }

  // Use up all the barrels
  boolean [item] barrels = $items[little firkin, normal barrel, big tun, weathered barrel, dusty barrel, disintegrating barrel, moist barrel, rotting barrel, mouldering barrel, barnacled barrel];
  foreach it in barrels
  {
    int barrel_amount = item_amount(it);
    if (barrel_amount > 0)
    {
      use_all(it);
    }
  }
}

void main()
{
  barrelgod();
}
