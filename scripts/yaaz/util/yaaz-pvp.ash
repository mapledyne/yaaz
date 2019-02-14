import "util/base/yz_print.ash";
import "special/items/yz_deck.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_maximize.ash";

void pvp();
void effects_for_pvp();
string pvp_equip_letter(int threshold);
string pvp_equip_letter();

void collect_pvp_info()
{
  string v = visit_url("/peevpee.php?place=shop");

  if (contains_text(v,"pirate season"))
  {
    save_daily_setting("pvp_season", "Pirate");
    save_daily_setting("pvp_swagger", "pirateSwagger");
    save_daily_setting("pvp_fight", "Letter of the Moment");
    return;
  }

  if (contains_text(v,"numeric season"))
  {
    save_daily_setting("pvp_season", "Numeric");
    save_daily_setting("pvp_swagger", "numericSwagger");
    save_daily_setting("pvp_fight", "back to");
    return;
  }

  if (contains_text(v,"bear season"))
  {
    save_daily_setting("pvp_season", "Bear");
    save_daily_setting("pvp_swagger", "bearSwagger");
    save_daily_setting("pvp_fight", "Barely Dressed");
    return;
  }

  if (contains_text(v,"ice season"))
  {
    save_daily_setting("pvp_season", "Ice");
    save_daily_setting("pvp_swagger", "iceSwagger");
    save_daily_setting("pvp_fight", "Ready to Melt");
    return;
  }


  if (contains_text(v,"safari season"))
  {
    save_daily_setting("pvp_season", "Safari");
    save_daily_setting("pvp_swagger", "safariSwagger");
    save_daily_setting("pvp_fight", "Letter of the Moment");
    return;
  }

  if (contains_text(v, "optimal season"))
  {
    save_daily_setting("pvp_season", "Optimal");
    save_daily_setting("pvp_swagger", "optimalSwagger");
    save_daily_setting("pvp_fight", "Optimal Dresser");
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
  } else {
    return "";
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

int gear_letter_count(item gear, string letter)
{
	if (gear == $item[none])
		return 0;
	matcher entity = create_matcher("&[^ ;]+;", gear);
	string output = replace_all(entity, "");
	matcher htmltag = create_matcher("\<[^\>]*\>", output);
	output = replace_all(htmltag, "");
	int letters_counted = 0;
	for i from 0 to length(output) - 1 {
		if (char_at(output,i).to_lower_case()==letter.to_lower_case()) letters_counted+=1;  
	}
	return letters_counted;
}

void dress_for_letter(string letter)
{
  item[int] choices;
  foreach s in $slots[hat, weapon, off-hand, shirt, back, pants]
  {
    clear(choices);
    foreach i in get_inventory()
    {
      if (to_slot(i) != s) continue;
      if (!be_good(i)) continue;
      if (!can_equip(i)) continue;
      choices[count(choices)] = i;
    }
    sort choices by -gear_letter_count(value, letter);
    item want = choices[0];
    if (gear_letter_count(want, letter) == 0) want = $item[none];
    if (want == $item[none])
    {
      log("Removing our " + wrap(s) + " item since nothing there will help with PvP.");
    } else {
      log("Equipping for " + letter + ": " + wrap(want));
    }
    equip(s, want);
  }

  clear(choices);

  foreach i in get_inventory()
  {
    if (to_slot(i) != $slot[acc1]) continue;
    if (!be_good(i)) continue;
    if (!can_equip(i)) continue;
    choices[count(choices)] = i;
  }
  sort choices by -gear_letter_count(value, letter);

  int count = 1;
  slot[int] accs;
  accs[1] = $slot[acc1];
  accs[2] = $slot[acc2];
  accs[3] = $slot[acc3];
  
  foreach s in $slots[acc1, acc2, acc3] { equip(s, $item[none]); }
  foreach toy in choices
  {
    log("Equipping for " + letter + ": " + wrap(choices[toy]));
    equip(accs[count], choices[toy]);
    count++;
    if (count > 3) break;
  }

}

void dress_for_letter()
{
  dress_for_letter(pvp_equip_letter());
}

void pvp_prep()
{
  log("Getting equipped and adding effects for PvP");

  string letter = pvp_equip_letter();
  if (letter != "")
  {
    log("Letter of the moment: " + wrap(letter, 'blue'));
    dress_for_letter();
  } else {
    outfit("birthday suit");
  }

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
      max_effects("familiar exp");

      // should we add to booze or to familiar exp (re: friars)? Unsure.
      max_effects("booze");
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
    case "Pirate":
      max_effects("booze");
      max_effects("-combat");
      break;
    case "Safari":
      max_effects("familiar");
      max_effects("familiar weight");
      max_effects("items");
      break;
  }
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
    log("About to get dressed and set up effects for PVP (" + pvp_season() + " Season).");
    wait(5);
    cli_execute("checkpoint");
    pvp_prep();
    string fame = "fame";
    if (can_interact()) fame = "loot";
    cli_execute("pvp " + fame + " " + pvp_fight());
    cli_execute("outfit checkpoint");
  }
  visit_url("peevpee.php?place=shop");
  log(CLUB + " PVP swagger: " + get_property("availableSwagger"));
  int totalSwag = prop_int(pvp_swagger());
  log(CLUB + " " + pvp_season() + " swagger: " + totalSwag);
  wait(5);
}

void main()
{
  pvp();
}
