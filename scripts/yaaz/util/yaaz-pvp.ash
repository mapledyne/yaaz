import "util/base/yz_print.ash";
import "special/items/yz_deck.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_maximize.ash";

//  Numeric: ("Numeric", "numericSwagger", "back to")
//  Bear:    ("Bear", "bearSwagger", "Barely Dressed")
//  Ice:     ("Ice", "iceSwagger", "Ready to Melt")

void pvp();
void effects_for_pvp();
string pvp_equip_letter(int threshold);
string pvp_equip_letter();
item find_best_clothes(slot s);
void school_clothes(string letter);

void collect_pvp_info()
{
  string v = visit_url("/peevpee.php?place=shop");

  if (contains_text(v,"Swagger Jack"))
  {
    save_daily_setting("pvp_season", "Pirate");
    save_daily_setting("pvp_swagger", "pirateSwagger");
    save_daily_setting("pvp_fight", "Letter of the Moment");
    return;
  }
}

string pvp_season()
{
  if (setting("pvp_season", "") != "")
  {
    return setting("pvp_season");
  }

  collect_pvp_info();
  return setting("pvp_season");
}

string pvp_swagger()
{
  if (setting("pvp_swagger", "") != "")
  {
    return setting("pvp_swagger");
  }

  collect_pvp_info();
  return setting("pvp_swagger");
}

string pvp_fight()
{
  if (setting("pvp_fight", "") != "")
  {
    return setting("pvp_fight");
  }

  collect_pvp_info();
  return setting("pvp_fight");
}

string pvp_equip_letter(int threshold)
{
  string info = visit_url("peevpee.php?place=rules");
  matcher letter = create_matcher("<b>([A-Z])<\/b>s? in their equipment.", info);
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
    log(CLUB + " The current " + pvp_season() + " equipment letter is " + wrap(current, COLOR_ITEM) + " but it's changing soon to " + wrap(next, COLOR_ITEM) + ", so we'll use that letter instead.");
    current = next;
  }

  return current;
}

string pvp_equip_letter()
{
  return pvp_equip_letter(0);
}


item find_best_clothes(slot s)
{
  string letter = pvp_equip_letter();
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


void letter_equip_clothes(string letter)
{
  log(CLUB + " Optimizing wardrobe for PvP. " + pvp_season() + " letter is currently: " + wrap(letter, COLOR_ITEM));

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

void letter_equip_clothes()
{
  int time = 60 * 60; // one hour
  string letter = pvp_equip_letter(time);
  letter_equip_clothes(letter);
}

void dress_for_pvp()
{
  switch(pvp_season())
  {
    default:
      cli_execute("outfit birthday suit");
      return;
    case "School":
      cli_execute("outfit birthday suit");
      letter_equip_clothes();
      return;
    case "Holiday":
      maximize("cold res, -combat");
      return;
    case "Bear":
      cli_execute("outfit birthday suit");
      return;
    case "Ice":
      maximize("cold res, 0.2 hot dmg, 0.2 hot spell dmg");
      return;
    case "Pirate":
      cli_execute("outfit birthday suit");
      letter_equip_clothes();
      max_effects("booze");
      max_effects("-combat");
  }
}

void effects_for_pvp()
{
  switch(pvp_season())
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
    case "Ice":
      max_effects("hot damage");
      max_effects("hot spell damage");
      max_effects("cold res");
      max_effects("booze");
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

  if (!hippy_stone_broken()) return;

  if (can_deck("clubs"))
    cheat_deck("clubs", "more PVP fights");

  if (pvp_attacks_left() > 0)
    log (CLUB + " Using up our PVP attacks.");

  if (pvp_attacks_left() > 0)
  {
    log("About to get dressed and set up effects for PVP.");
    wait(5);
    cli_execute("checkpoint");
    dress_for_pvp();
    effects_for_pvp();
    string fame = "fame";
    if (can_interact()) fame = "loot";
    cli_execute("pvp " + fame + " " + pvp_fight());
    cli_execute("outfit checkpoint");
  }
  visit_url("peevpee.php?place=shop");
  log(CLUB + " PVP swagger: " + get_property("availableSwagger"));
  int totalSwag = to_int(get_property(pvp_swagger()));
  log(CLUB + " " + pvp_season() + " swagger: " + totalSwag);
  wait(5);
}

void main()
{
  pvp();
}
