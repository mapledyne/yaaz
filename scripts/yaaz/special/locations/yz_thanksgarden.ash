import "util/base/yz_settings.ash";
import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_inventory.ash";
import "util/base/yz_quests.ash";

void thanksgarden_progress()
{

}

void harvest_thanksgarden()
{
  if (get_campground()[$item[cornucopia]] > 1 && be_good($item[Granny Tood's Thanksgarden Catalog]))
  {
    log("Harvesting the " + wrap("Thanksgarden", COLOR_ITEM) + ".");
    visit_url('campground.php?action=garden');
    log("I wonder what we just won. Opening the " + wrap($item[cornucopia], item_amount($item[cornucopia])) + ".");
    use(item_amount($item[cornucopia]), $item[cornucopia]);
  }
}

void cashew()
{
  if (!be_good($item[Granny Tood's Thanksgarden Catalog])) return;
  
  if (to_int(setting("stuffing_ascension","0")) < my_ascensions())
  {
    save_setting("stuffing_ascension", my_ascensions());
    save_setting("stuffing_used", 0);
  }

  if (quest_status("questL07Cyrptic") < FINISHED)
  {
    stock_item($item[gravy boat]);
  }

  int stuffing_used = to_int(setting("stuffing_used"));
  int stuffing_max = to_int(setting("stuffing_max", "1"));

  if (stuffing_used >= stuffing_max)
    return;

  if (quest_status("questL12War") < FINISHED)
  {
    int stock = stuffing_max - stuffing_used;
    stock_item($item[stuffing fluffer], stock);
  }

  while(item_amount($item[cashew]) >= 3)
  {
    log("Turning in " + wrap($item[cashew], 3) + " to get a " + wrap($item[turkey blaster]));
		buy($item[turkey blaster].seller, 1, $item[turkey blaster]);
  }

}

void thanksgarden()
{
  if (!(get_campground() contains $item[cornucopia])) return;

  if (!be_good($item[Granny Tood's Thanksgarden Catalog])) return;

  harvest_thanksgarden();

  cashew();
}

void main()
{
  thanksgarden();
}
