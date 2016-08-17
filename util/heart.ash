
import "util/util.ash";

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
//    use_skill(1, $skill[The Smile of Mr. A.], player);
    log("You have " + wrap(smiles_remaining(), COLOR_ITEM) + " smiles from your " + wrap($item[golden mr. accessory]) + " remaining today.");
  }

}

void heart(boolean force)
{
  int last = to_int(setting("last_heart", 0));
  int how_fast = to_int(setting("heart_speed", "10"));

  if (my_turncount() < last + how_fast && !force)
    return;

  log("Considering doing something heart-y");
  save_daily_setting("last_heart", my_turncount());

  do_heart_thing(pick_player());
}

void heart()
{
  heart(false);
}

void main()
{
  heart(true);
}
