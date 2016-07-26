import "util/main.ash";

void hero_keys()
{

  string keys = "";
  foreach k in $items[jarlsberg's key, sneaky pete's key, boris's key]
  {
    if (i_a(k) == 0)
    {
      if (length(keys) > 0)
      {
        keys += ", ";
      }
      keys += wrap(k);
    }
  }
  if (keys != "")
  {

    if (to_boolean(get_property("dailyDungeonDone")) && to_int(get_property("_deckCardsDrawn")) <= 10 && i_a($item[deck of every card]) > 0)
    {
      // we've done the daily dungeon but may be able to use the deck.
      advice("You're missing key(s) for the perplexing door (" + keys + "). You've done the daily dungeon today, but may be able to draw one from the " + wrap($item[deck of every card]) + ".");
      return;
    }

    if (to_boolean(get_property("dailyDungeonDone")))
    {
      if (have_familiar($familiar[Gelatinous Cubeling]) && !have_cubeling_items())
      {
        advice("Collecting the items from the " + wrap($familiar[Gelatinous Cubeling]) + " will speed getting the keys.");
      }
      return;
    }

    keys = "Missing hero key(s): " + keys + ". Get them from the daily dungeon";
    advice(keys);
    if (have_familiar($familiar[Gelatinous Cubeling]))
    {
      if (have_cubeling_items())
      {
        advice("You have the " + wrap($familiar[Gelatinous Cubeling]) + " items to help with " + wrap($location[the daily dungeon]) + ".");
      } else {
        advice("You should get the " + wrap($familiar[Gelatinous Cubeling]) + " items before adventuring in the daily dungeon.");
      }
    }
  }

}

void misc_advice()
{

}

void final_requirements()
{
  hero_keys();
}

void level_1_advice()
{

}


void get_advice()
{
  switch(my_level())
  {
    default: // do default first so anything higher than this will be captured
      print("d");
    case 13:
      print("13");
    case 12:
      print("12");
    case 11:
      print("11");
    case 10:
      print("10");
    case 9:
      print("9");
    case 8:
      print("8");
    case 7:
      print("7");
    case 6:
      print("6");
    case 5:
      print("5");
    case 4:
      print("4");
    case 3:
      print("3");
    case 2:
      print("2");
    case 1:
      level_1_advice();
      final_requirements();
      misc_advice();
  }
}

void main()
{
  get_advice();
}
