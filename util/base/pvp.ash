import "util/base/print.ash";
import "util/iotm/deck.ash";
import "util/base/settings.ash";

void pvp();
void pvp(string name, string swag, string attack);

item find_best_clothes(slot s)
{
  item target = $item[none];
  int current = 0;
  foreach i in get_inventory()
  {
    if (to_slot(i) != s)
      continue;
    string[int] spl = split_string(i, "r");
    if (count(spl) > current)
    {
      target = i;
      current = count(spl);
    }
  }
  return target;
}

void school_clothes()
{
  cli_execute("outfit birthday suit");
  equip(find_best_clothes($slot[hat]));
  equip(find_best_clothes($slot[weapon]));
  if (weapon_hands(equipped_item($slot[weapon])) == 1)
    equip(find_best_clothes($slot[off-hand]));
  equip(find_best_clothes($slot[pants]));
  equip(find_best_clothes($slot[shirt]));
  equip(find_best_clothes($slot[back]));
  equip(find_best_clothes($slot[familiar]));
  equip($slot[acc1], find_best_clothes($slot[acc1]));
  equip($slot[acc2], find_best_clothes($slot[acc1]));
  equip($slot[acc3], find_best_clothes($slot[acc1]));
}

void dress_for_pvp(string name)
{
  switch(name)
  {
    default:
      cli_execute("outfit birthday suit");
      return;
    case "School":
      school_clothes();
      return;
  }
}

void pvp()
{
//  pvp("Numeric", "numericSwagger", "back to");
  pvp("School", "schoolSwagger", "Freshman Rule");
}

void pvp(string name, string swag, string attack)
{

  if (hippy_stone_broken())
  {
    if (can_deck("clubs"))
      cheat_deck("clubs", "more PVP fights");

    if (pvp_attacks_left() > 0)
    {
      cli_execute("checkpoint");
      dress_for_pvp(name);
      cli_execute("pvp fame " + attack);
      cli_execute("outfit checkpoint");
    }
    visit_url("peevpee.php?place=shop");
    log("PVP swagger: " + get_property("availableSwagger"));
    int totalSwag = to_int(get_property(swag));
    log(name + " swagger: " + totalSwag);
    if (totalSwag > 1000)
    {
      log("You've earned enough swagger to get the seasonal item if you haven't already picked it up.");
    } else {
      int fights = 10 + numeric_modifier("PvP Fights");
      float avgSwag = fights*1.5;
      int days = to_int((1000 - totalSwag) / avgSwag);
      log("Approx " + days + " days remain to buy the seasonal award item.");
    }
  }

}

void main()
{
  pvp();
}
