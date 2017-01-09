import "util/base/settings.ash";
import "util/base/print.ash";
import "util/base/util.ash";
import "util/base/inventory.ash";
import "util/base/quests.ash";

void harvest_thanksgarden()
{
  if (get_campground()[$item[cornucopia]] > 1)
  {
    log("Harvesting the " + wrap("Thanksgarden", COLOR_ITEM) + ".");
    visit_url('campground.php?action=garden');
    log("I wonder what we just won. Opening the " + wrap($item[cornucopia], item_amount($item[cornucopia])) + ".");
    use(item_amount($item[cornucopia]), $item[cornucopia]);
  }
}

void stuffing()
{
  if (to_int(setting("stuffing_ascension","0")) < my_ascensions())
  {
    save_setting("stuffing_ascension", my_ascensions());
    save_setting("stuffing_used", 0);
  }

  int stuffing_used = to_int(setting("stuffing_used"));
  int stuffing_max = to_int(setting("stuffing_max", "2"));

  if (stuffing_used >= stuffing_max)
    return;

  if (quest_status("questL12War") < FINISHED)
  {
    int stock = stuffing_max - stuffing_used;
    stock_item($item[stuffing fluffer], stock);
  }

  if (quest_status("questL12War") != 1)
    return;

  if (!have($item[stuffing fluffer]))
    return;

  while(have($item[stuffing fluffer])
        && stuffing_used < stuffing_max)
  {
    log("Throwing a " + wrap($item[stuffing fluffer]) + " into the war.");
    boolean u = use(1, $item[stuffing fluffer]);
    if (u)
    {
      stuffing_used += 1;
      save_setting("stuffing_used", stuffing_used);
    } else { break; }
  }

}

void thanksgarden()
{
  if (!(get_campground() contains $item[cornucopia]))
    return;

  harvest_thanksgarden();

  if (quest_status("questL07Cyrptic") < FINISHED)
  {
    stock_item($item[gravy boat]);
  }

  stuffing();
}

void main()
{
  thanksgarden();
}
