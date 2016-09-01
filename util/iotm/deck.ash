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
  if (my_meat() < 2000 && my_path() != "Way of the Surprising Fist" && can_deck("1952"))
  {
    cheat_deck("1952", "get some meat");
    sell_all($item[1952 mickey mantle card]);
    return true;
  }

  // maybe get a hero key
  if (!have_familiar($familiar[gelatinous cubeling]) || to_familiar(setting("100familiar")) != $familiar[none])
  {
    if (hero_keys() < 3 && can_deck("tower"))
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
      return true;
    }
  }

  if (!have_skill($skill[ancestral recall]) && can_deck("ancestral recall"))
  {
    cheat_deck("ancestral recall", "learn a skill for more adventures");
    return true;
  }

  if (have_skill($skill[ancestral recall]))
  {
    if (can_deck("ancestral recall"))
    {
      cheat_deck("ancestral recall", "get some " + wrap($item[blue mana]) + " for more adventures");
      return true;
    }
    // don't get two mana if we're doing PVP to leave room for the clubs/PVP card.
    if (can_deck("island") && !hippy_stone_broken())
    {
      cheat_deck("island", "get some " + wrap($item[blue mana]) + " for more adventures");
      return true;
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

  while (have_skill($skill[ancestral recall]) && to_int(get_property("_ancestralRecallCasts")) < 10 && item_amount($item[blue mana]) > 0)
  {
    log("Casting " + wrap($skill[ancestral recall]) + " to get us a few more adventures.");
    use_skill(1, $skill[ancestral recall]);
  }

  if (!can_deck())
    return;

  log("Checking out your " + wrap($item[deck of every card]) + ".");

  while (can_deck() && pick_a_card())
  {
    // work in pick_a_card();
  }
}

void consume_cards()
{
  if (!can_deck())
    return;

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


  log("You have " + left + " draws left of the "+ wrap($item[deck of every card]) + ".");
  log("This is enough to cheat for something, but I'm undecided what to cheat for.");
  log("Maybe get something heart-y like the " + wrap($item[gift card]) + ", or more");
  log("meat with the " + wrap($item[1952 mickey mantle card]) + ", or something else.");
  wait(10);
}

void main()
{
  deck();
}
