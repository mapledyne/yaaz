
import "util/base/util.ash";
import "util/base/settings.ash";
import "special/items/timespinner.ash";

import <zlib.ash>;

string[int] prank_msgs;
file_to_map(DATA_DIR + "pranks.txt", prank_msgs);

string[int] arrow_msgs;
file_to_map(DATA_DIR + "arrows.txt", arrow_msgs);

boolean blacklisted(string player)
{
  if (player ≈ my_name())
    return true;

  string target = to_lower_case(player);

  if(setting("hearted_" + target, "") != "")  return true;

  if (list_contains(setting("no_heart"), target)) return true;

  return false;
}

boolean random_heart_picker()
{
  // splay == odds that a given heart attempt is actually tried.
  int splay = to_int(setting("heart_splay", "4"));

  return random(splay) == 0;
}

boolean do_jerk_things()
{
  return to_boolean(setting("do_jerk","true"));
}

string pick_player()
{
  if (have_equipped($item[actual reality goggles]))
  {
    log("We can't reliably pick players while you're wearing the " + wrap($item[actual reality goggles]) + ".");
    wait(3);
    return "";
  }

  boolean[string] players;
  players = who_clan();

  string[int] friends = split_string(setting("contact_list"), ", ");
  foreach x, f in friends
  {
    players[f] = true;
  }

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
  log(HEART + " Being heart-y to " + wrap(player, COLOR_MONSTER) + " by " + msg + ".");
  save_daily_setting("hearted_" + player, msg);
}


boolean mail_heart_item(string player, int[item] toys, string message)
{
  boolean force_gift = false;
  int count = 0;
  string toy_list = "";
  foreach it, i in toys
  {
    if (it == $item[holiday fun!]) force_gift = true;

    if (item_amount(it) < i)
      return false;
    if (length(toy_list) > 0)
    {
      toy_list += ", ";
    }
    toy_list += i + " " + wrap(it, i);
    count += i;
  }

  if (count == 0)
    return false;

  heart_msg(player, "sending them: " + toy_list);
  string msg = message;
  string inside_msg = message;

  //  boolean kmail(string recipient ,string message ,int meat ,int [item]  goodies ,string inside_note )
  if (force_gift)
  {
    send_gift(player, msg, 0, toys, inside_msg);
  } else {
    kmail(player, msg, 0, toys, inside_msg);
  }
  return true;
}

boolean mail_heart_item(string player, item toy, string message)
{
  int[item] stuff;
  stuff[toy] = 1;
  return mail_heart_item(player, stuff, message);

  return false;
}

boolean mail_heart_item(string player, item toy)
{
  return mail_heart_item(player, toy, "Random heart-y-ness. Enjoy!");
}


void do_heart_thing(string player)
{

  if (player == "")
  {
    log("No one found to be heart-y to right now. Sad.");
    return;
  }

  if (smiles_remaining() > 0 && random_heart_picker())
  {
    heart_msg(player, "casting " + wrap($skill[The Smile of Mr. A.]));
    use_skill(1, $skill[The Smile of Mr. A.], player);
    progress_sheet("smiles");
    return;
  }

/*

  // removing this at least temporarily since we're getting better at using
  // it to help our ascension...


  // only spin pranks once our stomach is full in case we want to re-eat
  // food from the past first (or if we already don't have the minutes to
  // re-eat, then don't sweat it and prank-away!)
  if (can_spin_time(3)
      && my_fullness() >= fullness_limit())
  {
    int num = random(count(prank_msgs));
    string prank_msg = prank_msgs[num];
    heart_msg(player, "sending a " + wrap("Time Prank", COLOR_ITEM) + " to them ('" + prank_msg + "').");
    time_prank(player, prank_msg);
    return;
  }
*/
  if (random_heart_picker()) if (mail_heart_item(player, $item[almost-dead walkie-talkie], "Go get yourself a ghost. Somewhere. Or pass it on to someone else. :)")) return;
  if (random_heart_picker()) if (mail_heart_item(player, $item[gift card], "I wonder what it'll be... :)")) return;

  // only do these if active in chat:
  if (who_clan()[player])
  {
    if (random_heart_picker()) if (mail_heart_item(player, $item[holiday fun!], "Holiday chat messages! Happy Holiday, whatever one is coming up next.")) return;

    if (item_amount($item[aggressive carrot]) > 0
        && random_heart_picker()
        && do_jerk_things())
    {
      heart_msg(player, "snapping an " + $item[aggressive carrot] + " and whispering their name...");
      string v = visit_url('inv_use.php?whichitem=7971');
      if (contains_text(v, 'Whisper:'))
      {
        visit_url('choice.php?pwd&whichchoice=1043&option=1&who=' + player);
        cli_execute('refresh inv');
        return;
      }
    }

    if (item_amount($item[glass of warm water]) > 0
        && random_heart_picker()
        && do_jerk_things())
    {
      heart_msg(player, "sticking their hand in a " + wrap($item[glass of warm water]) + ". Jerk");
      cli_execute("throw glass of warm water at " + player);
      return;
    }

  }

  if (item_amount($item[roll of toilet paper]) > 0
      && random_heart_picker()
      && do_jerk_things())
  {
    heart_msg(player, "throwing a " + wrap($item[roll of toilet paper]) + " at them. Jerk");
    cli_execute("throw roll of toilet paper at " + player);
    return;
  }

  if (item_amount($item[&quot;KICK ME&quot; sign]) > 0
      && random_heart_picker()
      && do_jerk_things())
  {
    heart_msg(player, "placing a " + wrap($item[&quot;KICK ME&quot; sign]) + " on them. Jerk");
    cli_execute("throw &quot;KICK ME&quot; sign at " + player);
    return;
  }

  // throw personalized coffee mug at abulafia || abcd | efgh | ijkl
  // visit_url("curse.php?action=use&pwd&whichitem=7697&targetplayer=abulafia&message=test");
  if (do_jerk_things())
  {
    foreach toy in $items[yellow snowcone,
                          black candy heart,
                          mood ring,
                          encoder ring,
                          defective skull,
                          jazz soap,
                          joybuzzer,
                          whoopie cushion,
                          fake hand,
                          explosion-flavored chewing gum,
                          fake fake vomit]
    {
       if (random_heart_picker()) if (mail_heart_item(player, toy, "Random 'heart'-y ness.")) return;
    }
  }

  if (item_amount($item[arrowgram]) > 0 && random_heart_picker())
  {
    int num = random(count(arrow_msgs));
    string arrow_msg = prank_msgs[num];
    heart_msg(player, "sending an " + wrap($item[arrowgram]) + " to them ('" + arrow_msg + "').");
    visit_url("curse.php?action=use?&pwd&whichitem=4940&targetplayer=" + player + "&arrowtext=" + arrow_msg);
    return;
  }

  log(HEART + " Apparently we're out of heart-y things to do right now. Sad.");
}

void heart(boolean force)
{
  string be_hearty = setting("do_heart");

  if (be_hearty == 'false')
    return;

  if (setting("heart_warning") == 'true'
      && be_hearty == '') return;

  if (be_hearty == '')
  {
    warning(HEART + " You haven't set if you want to do heart-y things during your run, like casting Smiles and such.");
    warning(HEART + " Set the variable " + SETTING_PREFIX + "_do_heart to 'true' or 'false' depending on which way you want to be.");
    warning(HEART + " Doing so will clear this message, for example:");
    log("set " + SETTING_PREFIX + "_do_heart=true");
    wait(10);
    save_daily_setting("heart_warning", 'true');
    return;
  }

  int last = to_int(setting("last_heart", 0));
  int how_fast = to_int(setting("heart_speed", "10"));

  if (my_turncount() < last + how_fast && !force)
    return;

  log(HEART + " Considering doing something heart-y");
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

void fill_from_contact_list()
{
  if (setting("contact_list") != "")
    return;

  string list = visit_url( "account_contactlist.php" );
  list = substring( list, 0 , index_of( list , "Ignore List" ) );

  int index = -1;
  int i = 0;
  string contacts = "";
  repeat {
      index = index_of( list , "showplayer" );
      if ( index < 0 ) break;
      int start = index_of( list , "<b>" , index ) + 3;
      int end   = index_of( list , "</b>" , start );
      string player = substring( list , start , end );
      contacts = list_add(contacts, player);
      list = substring( list , end );
      i = i + 1;
  } until ( index < 0 );

  save_daily_setting("contact_list", contacts);
}

void heart()
{
  fill_from_contact_list();
  collectors();
  heart(false);
}

void main()
{
  heart(true);
}
