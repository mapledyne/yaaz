import "util/base/print.ash";
import "util/iotm/deck.ash";
import "util/base/settings.ash";

//  Numeric: ("Numeric", "numericSwagger", "back to")

string PVP_SEASON = "School";
string PVP_SWAGGER = "schoolSwagger";
string PVP_FIGHT = "Spirit Day";

void pvp();

string school_letter()
{
  string info = visit_url("peevpee.php?place=rules");
  matcher letter = create_matcher("<b>([A-Z])<\/b>", info);
  if(letter.find())
  {
     return (letter.group(1));
  }
  return "A";
}

item find_best_clothes(slot s)
{
  string letter = school_letter();
  item target = $item[none];
  int current = 0;
  foreach i in get_inventory()
  {
    if (to_slot(i) != s)
      continue;
    string[int] spl = split_string(to_upper_case(i), letter);
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
  string letter = school_letter();
  log("Optimizing wardrobe for PvP. School letter is currently: " + wrap(letter, COLOR_ITEM));

  if(equipped_item($slot[hat]) == $item[none])
    equip(find_best_clothes($slot[hat]));
  if(equipped_item($slot[weapon]) == $item[none])
    equip(find_best_clothes($slot[weapon]));
  if (weapon_hands(equipped_item($slot[weapon])) == 1
      && equipped_item($slot[off-hand]) == $item[none])
    equip(find_best_clothes($slot[off-hand]));
  if(equipped_item($slot[pants]) == $item[none])
    equip(find_best_clothes($slot[pants]));
  if (have_skill($skill[torso awaregness])
      && equipped_item($slot[shirt]) == $item[none])
    equip(find_best_clothes($slot[shirt]));
  if(equipped_item($slot[back]) == $item[none])
    equip(find_best_clothes($slot[back]));
  if(equipped_item($slot[familiar]) == $item[none])
    equip(find_best_clothes($slot[familiar]));
  if(equipped_item($slot[acc1]) == $item[none])
    equip($slot[acc1], find_best_clothes($slot[acc1]));
  if(equipped_item($slot[acc2]) == $item[none])
    equip($slot[acc2], find_best_clothes($slot[acc1]));
  if(equipped_item($slot[acc3]) == $item[none])
    equip($slot[acc3], find_best_clothes($slot[acc1]));
}

void pvp_rollover()
{
  school_clothes();
}

void dress_for_pvp()
{
  switch(PVP_SEASON)
  {
    default:
      cli_execute("outfit birthday suit");
      return;
    case "School":
      cli_execute("outfit birthday suit");
      school_clothes();
      return;
  }
}

void pvp()
{

  if (hippy_stone_broken())
  {
    if (can_deck("clubs"))
      cheat_deck("clubs", "more PVP fights");

    if (pvp_attacks_left() > 0)
    {
      cli_execute("checkpoint");
      dress_for_pvp();
      cli_execute("pvp fame " + PVP_FIGHT);
      cli_execute("outfit checkpoint");
    }
    visit_url("peevpee.php?place=shop");
    log("PVP swagger: " + get_property("availableSwagger"));
    int totalSwag = to_int(get_property(PVP_SWAGGER));
    log(PVP_SEASON + " swagger: " + totalSwag);
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
