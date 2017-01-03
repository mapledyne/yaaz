import "util/base/print.ash";
import "util/iotm/deck.ash";
import "util/base/settings.ash";
import "util/base/maximize.ash";

//  Numeric: ("Numeric", "numericSwagger", "back to")

string PVP_SEASON = "Bear";
string PVP_SWAGGER = "bearSwagger";
string PVP_FIGHT = "Barely Dressed";

void pvp();
void effects_for_pvp();
string school_letter(int threshold);
string school_letter();
item find_best_clothes(slot s);
void school_clothes(string letter);


string school_letter(int threshold)
{
  string info = visit_url("peevpee.php?place=rules");
  matcher letter = create_matcher("<b>([A-Z])<\/b> in their equipment.", info);
  string current = "A";
  if(letter.find())
  {
    current = letter.group(1);
  }

  letter = create_matcher("Changing to <b>([A-Z])<\/b>", info);
  string next = "";
  if(letter.find())
  {
    next = letter.group(1);
  }

  letter = create_matcher("in ([0-9]+) seconds", info);
  int sec = 0;
  if(letter.find())
  {
    sec = to_int(letter.group(1));
  }

  if (sec > 0 && sec < threshold)
  {
    log(CLUB + " The current school letter is " + wrap(current, COLOR_ITEM) + " but it's changing soon to " + wrap(next, COLOR_ITEM) + ", so we'll use that letter instead.");
    current = next;
  }

  return current;
}

string school_letter()
{
  return school_letter(0);
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
    if (!can_equip(i))
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


void school_clothes(string letter)
{
  log(CLUB + " Optimizing wardrobe for PvP. School letter is currently: " + wrap(letter, COLOR_ITEM));

  if(equipped_item($slot[hat]) == $item[none])
    equip($slot[hat], find_best_clothes($slot[hat]));
  if(equipped_item($slot[weapon]) == $item[none])
    equip($slot[weapon], find_best_clothes($slot[weapon]));
  if (weapon_hands(equipped_item($slot[weapon])) == 1
      && equipped_item($slot[off-hand]) == $item[none])
    equip($slot[off-hand], find_best_clothes($slot[off-hand]));
  if(equipped_item($slot[pants]) == $item[none])
    equip($slot[pants], find_best_clothes($slot[pants]));
  if (have_skill($skill[torso awaregness])
      && equipped_item($slot[shirt]) == $item[none])
    equip($slot[shirt], find_best_clothes($slot[shirt]));
  if(equipped_item($slot[back]) == $item[none])
    equip($slot[back], find_best_clothes($slot[back]));
  if(equipped_item($slot[familiar]) == $item[none])
    equip($slot[familiar], find_best_clothes($slot[familiar]));
  if(equipped_item($slot[acc1]) == $item[none])
    equip($slot[acc1], find_best_clothes($slot[acc1]));
  if(equipped_item($slot[acc2]) == $item[none])
    equip($slot[acc2], find_best_clothes($slot[acc1]));
  if(equipped_item($slot[acc3]) == $item[none])
    equip($slot[acc3], find_best_clothes($slot[acc1]));
}

void school_clothes()
{
  int time = 60 * 60; // one hour
  string letter = school_letter(time);
  school_clothes(letter);
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
    case "Holiday":
      maximize("cold res, -combat");
      return;
    case "Bear":
      cli_execute("outfit birthday suit");
      return;
  }
}

void effects_for_pvp()
{
  switch(PVP_SEASON)
  {
    default:
      break;
    case "School":
      max_effects("hot damage");
      max_effects("hot spell damage");
      break;
    case "Holiday":
      max_effects("cold res");
      max_effects("-combat");
      // should we add to booze or to familiar exp? Unsure.
      if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
      {
        cli_execute("friars booze");
      }
      max_effects("familiar exp");
      break;
    case "Bear":
      max_effects("damage");
      max_effects("cold res");
      break;
  }
}

void pvp_rollover()
{
//  dress_for_pvp();
  effects_for_pvp();
}

void pvp()
{

  if (hippy_stone_broken())
  {
    if (can_deck("clubs"))
      cheat_deck("clubs", "more PVP fights");

    if (pvp_attacks_left() > 0)
      log (CLUB + " Using up our PVP attacks.");

    if (pvp_attacks_left() > 0)
    {
      cli_execute("checkpoint");
      dress_for_pvp();
      effects_for_pvp();
      cli_execute("pvp fame " + PVP_FIGHT);
      cli_execute("outfit checkpoint");
    }
    visit_url("peevpee.php?place=shop");
    log(CLUB + " PVP swagger: " + get_property("availableSwagger"));
    int totalSwag = to_int(get_property(PVP_SWAGGER));
    log(CLUB + " " + PVP_SEASON + " swagger: " + totalSwag);
    if (totalSwag > 1000)
    {
      log(CLUB + " You've earned enough swagger to get the seasonal item if you haven't already picked it up.");
    }
    wait(5);
  }

}

void main()
{
  pvp();
}
