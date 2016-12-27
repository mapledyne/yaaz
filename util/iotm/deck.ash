import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/familiars.ash";
import "util/base/quests.ash";
import "util/base/util.ash";

boolean can_deck()
{
  if (can_adventure() && item_amount($item[deck of every card]) > 0 && to_int(get_property("_deckCardsDrawn")) < 15)
    return true;
  return false;
}

boolean can_deck(string card)
{
  if (!can_deck())
    return false;
  if (setting("decked_" + card) == "true")
    return false;
  return true;
}


string cheat_stat(stat s)
{
  switch (s)
  {
    default:
      abort("Trying to find a card for stat " + s + " but I don't know what that is.");
    case $stat[muscle]:
      return "world";
    case $stat[mysticality]:
      return "empress";
    case $stat[moxie]:
      return "lovers";
  }
}

string cheat_stat()
{
  return cheat_stat(my_primestat());
}

boolean cheat_deck(string s, string msg)
{
  if (!can_deck(s))
    return false;

  log("Cheating with the " + wrap($item[deck of every card]) + " (" + s + ") to " + msg + ".");
  save_daily_setting("decked_" + s, "true");
  return cli_execute("cheat " + s);
}



boolean pick_a_card()
{
  // maybe get some stats?
  if (my_level() < 4 && my_path() != "The Source")
  {
    return cheat_deck(cheat_stat(), "get some stats");
  }

  // get some meat if we're low
  if (my_meat() < 2000 && my_path() != "Way of the Surprising Fist")
  {
    boolean b = cheat_deck("1952", "get some meat");
    sell_all($item[1952 mickey mantle card]);
    return b;
  }

  // maybe get a hero key
  if (!have_familiar($familiar[gelatinous cubeling]) || to_familiar(setting("100familiar")) != $familiar[none])
  {
    if (hero_keys() < 3)
    {
      return cheat_deck("tower", "get a hero key");
    }
  }

  if (quest_status("questL08Trapper") < 1)
  {
    item ore = $item[asbestos ore];
    if (item_amount(ore) < 3)
    {
      // we have less than three of this, so can assume we have less than
      // three of all of them.
      return cheat_deck("mine", "get some ore for the trapper quest");
    }
  }
  return false;
}

void deck()
{

  if (!can_deck())
    return;

  while (can_deck() && pick_a_card())
  {
    // work in pick_a_card();
  }
}

void consume_cards()
{
  if (!can_deck())
    return;

  log("Using up our " + wrap($item[deck of every card]) + " draws.");

  if (quest_status("questL11Worship") < 2 && item_amount($item[stone wool]) < 2)
  {
    cheat_deck("sheep", "stone wool to help with the hidden city");
  }

  if (hippy_stone_broken())
  {
    cheat_deck("clubs", "more PVP fights");
  }

  cheat_deck("ancestral recall", "more adventures");
  cheat_deck("island", "more adventures");

  int left = 15 - to_int(get_property("_deckCardsDrawn"));

  if (left < 5 && can_adventure())
  {
    log("You have some cards left from the " + wrap($item[deck of every card]) + ", but not enough to cheat for anything. Using up your draws.");
    while(can_deck())
    {
      cli_execute("cheat random");
    }
    return;
  }

  if (!can_deck())
    return;

/*
  log("You have " + left + " draws left of the "+ wrap($item[deck of every card]) + ".");
  log("This is enough to cheat for something, but I'm undecided what to cheat for.");
  log("Maybe get something heart-y like the " + wrap($item[gift card]) + ", or more");
  log("meat with the " + wrap($item[1952 mickey mantle card]) + ", or something else.");
  wait(10);
*/

  log("You have some cards left from the " + wrap($item[deck of every card]) + ". I've cheated for what I want, so just using the rest up randomly.");
  wait(5);
  while(can_deck() && can_adventure())
  {
    use(1, $item[deck of every card]);
  }

}

void main()
{
  deck();
}
