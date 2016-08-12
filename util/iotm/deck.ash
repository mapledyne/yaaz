import "util/print.ash";
import "util/inventory.ash";
import "util/familiars.ash";

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
  log("Cheating with the " + wrap($item[deck of every card]) + " (" + s + ") to " + msg + ".");
  cli_execute("cheat " + s);
}

boolean can_deck()
{
  if (i_a($item[deck of every card]) > 0 && to_int(get_property("_deckCardsDrawn")) < 15)
    return true;
  return false;
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

  log("Out of things to automatically cheat with the deck.");
  if (can_deck())
  {
    log("You still have draws remaining.");
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
