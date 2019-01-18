import "util/base/yz_util.ash";

void vip_fortune_progress()
{

}

void vip_fortune_clan()
{
  if (to_int(get_property("_clanFortuneConsultUses")) >= 3) return;

  if (setting("fortune_clan_used") == "true") return;

  string targets = setting("fortune_clannies");

  string[int] target_list = split_string(targets, ",");
  if (count(target_list) < 3)
  {
    if (setting("fortune_warn") != "true")
    {
      warning("You have a Fortune Teller in your Clan VIP basement.");
      warning("If you set " + wrap("yz_fortune_clannies", COLOR_LOCATION) + " to a list of three clanmates");
      warning("separated by commas, I'll ask them their fortunes with you.");
      warning("example: set " + wrap("yz_fortune_clannies=bob,sue,degrassi", COLOR_LOCATION) + ")");
      wait(5);
      save_daily_setting("fortune_warn", "true");
    }
    return;
  }
  for x from to_int(get_property("_clanFortuneConsultUses")) to 2
  {
    log("About to ask our fortune with: " + wrap(target_list[x], COLOR_MONSTER));
    cli_execute("fortune " + target_list[x]);
  }
  save_daily_setting("fortune_clan_used", "true");

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
