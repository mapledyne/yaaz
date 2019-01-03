import "util/base/yz_util.ash";

void vip_fortune_progress()
{

}

void vip_fortune(string want)
{
  if (get_property("_clanFortuneBuffUsed") != "false") return;
  if (!have($item[clan vip lounge key])) return;
  if (!(get_clan_lounge() contains $item[clan carnival game])) return;

  string doit = "";
  switch(want)
  {
    default:
      debug("I don't know how to get the fortume for: " + want);
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

}


void main()
{
  vip_fortune();
}
