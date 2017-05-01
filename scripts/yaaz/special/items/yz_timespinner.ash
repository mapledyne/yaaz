import "util/base/yz_settings.ash";
import "util/base/yz_print.ash";
import "util/adventure/yz_consult.ash";

import <zlib.ash>

void timespinner_progress()
{
  if (!have($item[time-spinner])) return;

  int used = to_int(get_property("_timeSpinnerMinutesUsed"));

  if (used < 10)
  {
    progress(used, 10, wrap($item[time-spinner]) + " minutes used", "blue");
    if (!to_boolean(get_property("_timeSpinnerReplicatorUsed")))
    {
      task("use Time Spinner replicator");
    }
  }
}

int time_minutes()
{
  if (item_amount($item[time-spinner]) == 0)
    return 0;

  return 10 - to_int(get_property("_timeSpinnerMinutesUsed"));
}

boolean is_spinner_food(item yum)
{
  if (!list_contains(get_property("_timeSpinnerFoodAvailable"), to_int(yum), ","))
    return false;
  if (time_minutes() < 3)
    return false;

  return true;
}

boolean spinner_eat(item yum)
{
  if (!is_spinner_food(yum)) return false;

  string url = "choice.php?pwd&whichchoice=1197&option=1&foodid=" + to_int(yum);

  visit_url("inv_use.php?pwd=&which=3&whichitem=9104");
  visit_url("choice.php?pwd&whichchoice=1195&option=2");
  string ret = visit_url(url);

  return true;

}

boolean can_spin_time(int min)
{
  if (item_amount($item[time-spinner]) == 0)
    return false;
  if (time_minutes() < min)
    return false;
  return true;
}

boolean can_spin_time()
{
  return can_spin_time(1);
}

boolean can_time_fight(monster mob, location loc)
{
  return list_contains(loc.combat_queue, mob, '; ');
}

boolean time_combat(monster mob)
{
	if(is_unrestricted($item[Time-Spinner])
     && (item_amount($item[Time-Spinner]) > 0)
     && (time_minutes() >= 3))
	{
    buffer page = visit_url("inv_use.php?pwd=&whichitem=9104");
    page = run_choice(1);
    if (contains_text(page, 'option value="' + mob.id + '"')) {
      log("Using the " + wrap($item[time-spinner]) + " to try to fight another " + wrap(mob) + ".");
        page = visit_url("choice.php?pwd=&whichchoice=1196&option=1&monid=" + mob.id);
        page = run_combat('yz_consult');
        return true;
    } else {
      warning("Trying to use the " + wrap($item[time-spinner]) + " to fight another " + wrap(mob) + ", but it's not in the list of available fights.");
      run_choice(2); // skip out.
      return false;
    }
	}
	return false;
}

boolean time_combat(monster mob, location loc)
{
  if (!can_time_fight(mob, loc))
    return false;
  return time_combat(mob);
}

boolean time_prank(string player, string msg)
{
  if (!can_spin_time()) false;

  string url = "choice.php?pwd&whichchoice=1198&option=1&pl=" + player + "&th=" + msg;

  visit_url("inv_use.php?pwd=&which=3&whichitem=9104");
  visit_url("choice.php?pwd&whichchoice=1195&option=5");
  string ret = visit_url(url);
  string oops = "someone else hiding in their timestream already";

  if (contains_text(ret, oops))
  {
    log("Trying to send a " + wrap("Time Prank", COLOR_ITEM) + " to " + wrap(player, COLOR_MONSTER) + ", but someone beat you to it.");
    visit_url("choice.php?pwd&whichchoice=1198&option=2");
    return false;
  }

  oops = "has already been pranked enough today";

  if (contains_text(ret, oops))
  {
    log("Trying to send a " + wrap("Time Prank", COLOR_ITEM) + " to " + wrap(player, COLOR_MONSTER) + ", but they've been pranked too much today.");
    visit_url("choice.php?pwd&whichchoice=1198&option=2");
    return false;
  }


  oops = "You didn't think of a real player";
  if (contains_text(ret, oops))
  {
    log("Trying to send a " + wrap("Time Prank", COLOR_ITEM) + " to " + wrap(player, COLOR_MONSTER) + ", but that doesn't seem to be a player.");
    visit_url("choice.php?pwd&whichchoice=1198&option=2");
    return false;
  }

  if (!contains_text(ret, "You send a paradoxical time copy of yourself"))
  {
    // some other reply that we need to handle intelligently.
    print(ret);
    wait(30);
  }

  return true;
}

boolean timespinner_future()
{
  if (item_amount($item[time-spinner]) == 0) return false;

  if (!to_boolean(setting("far_future", "true"))) return false;

  if (time_minutes() < 2) return false;

  if (get_property("_timeSpinnerReplicatorUsed") == "true") return false;

  if (!svn_exists("Ezandora-Far-Future-branches-Release"))
  {
    if (!to_boolean(setting("far_future_svn_warning", "false")))
    {
      save_daily_setting("far_future_svn_warning", "true");
      warning("You have a " + wrap($item[time-spinner]) + " but I don't know how to automate going into the far future.");
      warning("If you install Ezandora's " + wrap("Far Future", COLOR_ITEM) + " script, I'll call it to automatically do this for you.");
      warning("In the meantime, you'll have to do this yourself, if interested.");
      wait(10);
    }
    return false;
  }

  string replicate = "food";

  if (hippy_stone_broken())
    replicate = "drink";

  log("Using the " + wrap($item[time-spinner]) + " to visit the far future. Going to try to replicate some " + replicate + ".");
  return cli_execute("FarFuture.ash " + replicate);
}

void timespinner()
{
  timespinner_future();
}

void main()
{
  timespinner();
}
