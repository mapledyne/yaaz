import "util/base/yz_util.ash";

void vip_fortune_progress()
{

}

string pick_fortune_clanmate()
{
  string targets = setting("fortune_clannies");
  if (targets == "")
  {
    if (setting("fortune_warn") != "true")
    {
      warning("You have a Fortune Teller in your Clan VIP basement.");
      warning("If you set " + wrap("yz_fortune_clannies", COLOR_LOCATION) + " to a list of clanmates");
      warning("separated by commas, I'll ask them their fortunes with you.");
      warning("example: set " + wrap("yz_fortune_clannies=bob,sue,degrassi", COLOR_LOCATION) + ")");
      wait(5);
      save_daily_setting("fortune_warn", "true");
    }
    return "";
  }

  string[int] target_list = split_string(targets, ",");

  boolean[string] clannies = who_clan();

  string fave = "";

  foreach k, v in target_list
  {
    if (clannies contains v)
    {
      if (fave == "")
      {
        fave = v;
      }
      else
      {
        if (!clannies[fave] && clannies[v]) fave = v;
      }
    }
  }

  return fave;
}

void vip_fortune_clan()
{
  if (prop_int("_clanFortuneConsultUses") >= 3) return;

  if (to_int(setting("fortune_last", "0")) + 25 > (my_turncount())) return;

  save_daily_setting("fortune_last", my_turncount());

  string target = pick_fortune_clanmate();
  if (target == "") return;

  save_daily_setting("fortune_target", target);

  log("About to ask our fortune with: " + wrap(target, COLOR_MONSTER));
  cli_execute("fortune " + target);

}

void vip_fortune(string want)
{
  if (get_property("_clanFortuneBuffUsed") != "false") return;
  if (!have($item[clan vip lounge key])) return;
  if (!(get_clan_lounge() contains $item[clan carnival game])) return;

  vip_fortune_clan();
  if (want == "") return;

  string doit = "";
  switch(want)
  {
    default:
      debug("I don't know how to get the fortune for: " + want);
      return;
    case("muscle"):
      doit="mus";
      break;
    case("moxie"):
      doit="mox";
      break;
    case("mysticality"):
      doit="mys";
      break;
    case("familiar"):
      doit="familiar";
      break;
    case("items"):
      doit="item";
      break;
    case("meat"):
      doit="meat";
      break;
  }
  if (doit != "") cli_execute("fortune buff " + doit);
}

void vip_fortune()
{
  vip_fortune("");
}

void main()
{
  vip_fortune_clan();
}
