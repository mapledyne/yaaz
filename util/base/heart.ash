
import "util/base/util.ash";
import "util/base/settings.ash";
import "util/iotm/timespinner.ash"Copyright (c) 2016 Copyright Holder All Rights Reserved.
import <zlib.ash>;

int smiles_remaining()
{

  int total_casts_available = to_int(get_property("goldenMrAccessories")) * 5;
  int casts_used = to_int(get_property("_smilesOfMrA"));

  return total_casts_available - casts_used;
}

boolean blacklisted(string player)
{
  // this should check an aggregate, but I'm sick and can't think straight.
  switch(to_lower_case(player))
  {
    default:
      if(setting("hearted_" + player) == "true")
      {
        return true;
      }
      return false;
    case "degrassi":
    case "ertest1":
    case "lord enzo":
    case "major meat":
    case "pacosr":
    case "ultibot":
    case "searchingchat":
    case "s t u p i d":
      return true;
  }
}

string pick_player()
{
  boolean[string] players;
  players = who_clan();

  // force extra players that aren't in clan:
  players["muddytm"] = true;

  string[int] possible;
  int count = 0;
  foreach p in players
  {
    if (blacklisted(p))
    {
      continue;
    }

    possible[count] = p;
    count += 1;
  }

  if (count( possible ) == 0)
  {
    return "";
  }

  if (count( possible ) == 1)
  {
    return possible[0];
  } else {
    return possible[random(count(possible))];
  }
}

void heart_msg(string player, string msg)
{
  log("Being heart-y to " + wrap(player, COLOR_MONSTER) + " by " + msg + ".");
  save_daily_setting("hearted_" + player, "true");
}

boolean mail_heart_item(string player, item toy)
{
  if (item_amount(toy) == 0)
    return false;

  //  boolean kmail(string recipient ,string message ,int meat ,int [item]  goodies ,string inside_note )
  heart_msg(player, "sending them one " + wrap(toy));
  string msg = "Random heart-y-ness. Enjoy!";
  string inside_msg = "Random heart-y-ness. Enjoy!";
  int[item] stuff;
  stuff[toy] = 1;
  kmail(player, msg, 0, stuff, inside_msg);
  return true;

}

void do_heart_thing(string player)
{

  if (player == "")
  {
    log("No one found to be heart-y to right now. Sad.");
    return;
  }

  if (smiles_remaining() > 0)
  {
    heart_msg(player, "casting " + wrap($skill[The Smile of Mr. A.]));
    use_skill(1, $skill[The Smile of Mr. A.], player);
    log("You have " + wrap(smiles_remaining(), COLOR_ITEM) + " smiles from your " + wrap($item[golden mr. accessory]) + " remaining today.");
    return;
  }
  if (mail_heart_item(player, $item[almost-dead walkie-talkie])) return;
  if (mail_heart_item(player, $item[gift card])) return;
  if (item_amount($item[roll of toilet paper]) > 0)
  {
    heart_msg(player, "throwing a " + wrap($item[roll of toilet paper]) + " at them. Jerk");
    cli_execute("throw roll of toilet paper at " + player);
  }
  if (can_spin_time())
  {
    heart_msg(player, "sending a time prank.");
    time_prank(player, "time is residual...");
  }

  log("Apparently we're out of heart-y things to do right now. Sad.");
}

void heart(boolean force)
{
  if (setting("do_heart") == "false")
    return;

  int last = to_int(setting("last_heart", 0));
  int how_fast = to_int(setting("heart_speed", "10"));

  if (my_turncount() < last + how_fast && !force)
    return;

  log("Considering doing something heart-y");
  save_daily_setting("last_heart", my_turncount());

  do_heart_thing(pick_player());
  wait(3);
}

void collect(string player, item toy)
{
  int qty = item_amount(toy);

  if (qty == 0)
    return;

  log("Sending  " + qty + " " + wrap(toy, qty) + " to " + wrap(player, COLOR_MONSTER) + " since they're awesome and collect these.");
  wait(3);
  string msg = "You're awesome. Here's a thing.";
  string inside_msg = "Awesome thing for awesome person.";
  int[item] stuff;
  stuff[toy] = qty;
  kmail(player, msg, 0, stuff, inside_msg);
}

void collectors()
{
  if (setting("do_collectors") == "false")
    return;

  // KoLMafia devs:
  collect("veracity", $item[rubber emo roe]);
  collect("veracity", $item[rubber WWtNSD? bracelet]);
  collect("bale", $item[stuffed hodgman]); // prolific scripter
//  collect("holatuwol", $item[stuffed cocoabo]); // no longer playing?

}

void heart()
{
  collectors();
  heart(false);
}

void main()
{
  heart(true);
}
