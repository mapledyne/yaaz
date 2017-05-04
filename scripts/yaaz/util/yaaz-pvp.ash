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
    save_daily_setting("pvp_swagger", "numericSeason");
    save_daily_setting("pvp_fight", "back to");
    return;
  }

  if (contains_text(v,"bear season"))
  {
    save_daily_setting("pvp_season", "Bear");
    save_daily_setting("pvp_swagger", "bearSeason");
    save_daily_setting("pvp_fight", "Barely Dressed");
    return;
  }

  if (contains_text(v,"ice season"))
  {
    save_daily_setting("pvp_season", "Ice");
    save_daily_setting("pvp_swagger", "iceSeason");
    save_daily_setting("pvp_fight", "Ready to Melt");
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

void dress_for_pvp()
{
  cli_execute("UberPvPOptimizer.ash");
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
    case "Pirate":
      max_effects("booze");
      max_effects("-combat");
      break;
  }
}

void pvp_rollover()
{
  dress_for_pvp();
  effects_for_pvp();
}

void pvp()
{

  if (!hippy_stone_broken()) return;

  if (!svn_exists("uberpvpoptimizer"))
  {
    if (!to_boolean(setting("uberpvpoptimizer_svn_warning", "false")))
    {
      save_daily_setting("uberpvpoptimizer_svn_warning", "true");
      warning("You want to run PVP but I don't know how to automate dessing up.");
      warning("If you install the " + wrap("UberPvPOptimizer", COLOR_ITEM) + " script, I'll call it to automatically do this for you.");
      warning("In the meantime, you'll have to do this yourself, if interested.");
      wait(10);
    }
    return;
  }

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
