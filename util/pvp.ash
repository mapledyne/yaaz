import "util/print.ash";

void pvp();
void pvp(string name, string swag, string attack);


void pvp()
{
  pvp("Numeric", "numericSwagger", "back to");
}

void pvp(string name, string swag, string attack)
{

  if (hippy_stone_broken())
  {
    if (pvp_attacks_left() > 0)
    {
      cli_execute("checkpoint");
      cli_execute("outfit birthday suit");
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
