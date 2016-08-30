import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/familiars.ash";

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

void cheat_deck(string s, string msg)
{
  if (setting("decked_" + s) == "true")
  {
    warning("Trying to cheat the " + wrap($item[deck of every card]) + " for '" + s +"', but you've already drawn that today.");
    return;
  }
  log("Cheating with the " + wrap($item[deck of every card]) + " (" + s + ") to " + msg + ".");
  save_daily_setting("decked_" + s, "true");
  cli_execute("cheat " + s);
}


boolean can_deck()
{
  if (i_a($item[deck of every card]) > 0 && to_int(get_property("_deckCardsDrawn")) < 15)
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

boolean pick_a_card()
{
  // maybe get some stats?
  if (my_level() < 4 && my_path() != "The Source")
  {
    cheat_deck(cheat_stat(), "get some stats");
    return true;
  }

  // get some meat if we're low
  if (my_meat() < 2000 && my_path() != "Way of the Surprising Fist")
  {
    cheat_deck("1952", "get some meat");
    sell_all($item[1952 mickey mantle card]);
    return true;
  }

  // maybe get a hero key
  if (!have_familiar($familiar[gelatinous cubeling]) || to_familiar(setting("100familiar")) != $familiar[none])
  {
    if (hero_keys() < 3)
    {
      cheat_deck("tower", "get a hero key");
      return true;
    }
  }

  if (quest_status("questL08Trapper") < 1 && can_deck("mine"))
  {
    item ore = $item[asbestos ore];
    if (item_amount(ore) < 3)
    {
      // we have less than three of this, so can assume we have less than
      // three of all of them.
      cheat_deck("mine", "get some ore for the trapper quest");
    }
  }

  log("Out of things to automatically cheat with the deck.");
  if (can_deck())
  {
    int draws = 15 - to_int(get_property("_deckCardsDrawn"));
    log("You still have " + wrap(to_string(draws), COLOR_ITEM) + " draws remaining. Cheating uses 5 draws.");
    wait(3);
  }
  return false;
}

void deck()
{
  if (!can_deck())
    return;

  log("Checking out your " + wrap($item[deck of every card]) + ".");

  while (can_deck() && pick_a_card())
  {
    // work in pick_a_card();
  }
}

void main()
{
  deck();
}
