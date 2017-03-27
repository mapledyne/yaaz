import "util/base/inventory.ash";
import "util/base/quests.ash";

void sell_things()
{
  int[item] sell_items;
  file_to_map(DATA_DIR + "sell.txt", sell_items);

  foreach it, i in sell_items
  {
    sell_all(it, i);
  }

  while (my_meat() < 5000 && have($item[1952 Mickey Mantle card]))
    sell_one($item[1952 Mickey Mantle card]);

  while (my_meat() < 5000 && have($item[commemorative war stein]))
    sell_one($item[commemorative war stein]);



  if (my_primestat() == $stat[moxie])
  {
    sell_all($item[finger cymbals], 1);
  } else {
    sell_all($item[finger cymbals]);
  }

  if (item_amount($item[digital key]) > 0)
  {
    sell_all($item[Blue Pixel]);
    sell_all($item[Red Pixel]);
    sell_all($item[Green Pixel]);
  }


  if (have_familiar($familiar[misshapen animal skeleton]))
  {
    sell_all($item[pile of dusty animal bones]);
  }

  if (have_familiar($familiar[stab bat]))
  {
    sell_all($item[batblade], 1);
  }

  // keep three around for catburgling.
  sell_all($item[hot wing], 3);

  if (have($item[wand of nagamar]))
  {
    sell_all($item[ruby w]);
    sell_all($item[metallic a]);
    sell_all($item[lowercase n]);
    sell_all($item[heavy d]);
  } else {
    sell_all($item[ruby w], 1);
    sell_all($item[metallic a], 1);
    sell_all($item[lowercase n], 1);
    sell_all($item[heavy d], 1);
  }
  sell_all($item[original g]);

  if (my_primestat() != $stat[moxie])
  {
    sell_all($item[4-dimensional guitar]);
    sell_all($item[finger cymbals]);
  }
  else
  {
    sell_all($item[4-dimensional guitar], 1);
    sell_all($item[finger cymbals], 1);
  }


  if (quest_status("questM02Artist") == FINISHED)
  {
    sell_all($item[rat whisker]);
  }

  // bridge built
  if (quest_status("questL09Topping") > 1)
  {
    sell_all($item[orc wrist]);
  }

  if (!have_familiar($familiar[gluttonous green ghost]))
  {
    sell_all($item[pie man was not meant to eat]);
  }

  if (have_familiar($familiar[wereturtle]))
  {
    sell_all($item[sleeping wereturtle]);
  }
  if (have_familiar($familiar[syncopated turtle]))
  {
    sell_all($item[syncopated turtle]);
  }

  if (quest_status("questL11Doctor") == FINISHED)
  {
    sell_all($item[bloodied surgical dungarees]);
  } else {
    sell_all($item[bloodied surgical dungarees], 1);
  }

  // if we've started adventuring and are low on funds
  // (wait a few turns to allow time for things like the 1952 card and such)
  if (my_meat() < 1000 && my_turncount() > 5)
  {
    sell_all($item[hamethyst]);
    sell_all($item[baconstone]);
    sell_all($item[porquoise]);
  }

}
