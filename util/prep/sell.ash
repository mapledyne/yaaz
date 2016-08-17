import "util/inventory.ash";

void sell_things()
{
  if (my_meat() < 5000)
    sell_all($item[1952 Mickey Mantle card]);

  sell_all($item[fat stacks of cash]);
  sell_all($item[dense meat stack]);
  sell_all($item[meat stack]);

  sell_all($item[Anticheese]);
  sell_all($item[Antique greaves]);
  sell_all($item[Antique helmet]);
  sell_all($item[Antique spear]);
  sell_all($item[Antique shield]);
  sell_all($item[Awful Poetry Journal]);
  sell_all($item[Beach Glass Bead]);
  sell_all($item[Black Pixel]);
  sell_all($item[Blue Pixel]);
  sell_all($item[Clay Peace-Sign Bead]);
  sell_all($item[Decorative Fountain]);
  sell_all($item[Empty Cloaca-Cola Bottle]);
  sell_all($item[Enchanted Barbell]);
  sell_all($item[Fancy Bath Salts]);
  sell_all($item[Frigid Ninja Stars]);
  sell_all($item[Giant Moxie Weed]);
  sell_all($item[Green Pixel]);
  sell_all($item[Half of a Gold Tooth]);
  sell_all($item[Imp Ale]);
  sell_all($item[Keel-Haulin\' Knife]);
  sell_all($item[Kokomo Resort Pass]);
  sell_all($item[Mad Train Wine]);
  sell_all($item[Margarita]);
  sell_all($item[Martini]);
  sell_all($item[Meat Paste]);
  sell_all($item[Mineapple]);
  sell_all($item[Moxie Weed]);
  sell_all($item[Ninja mop]);
  sell_all($item[Patchouli Incense Stick]);
  sell_all($item[Phat Turquoise Bead]);
  sell_all($item[Photoprotoneutron Torpedo]);
  sell_all($item[Procrastination Potion]);
  sell_all($item[Ratgut]);
  sell_all($item[Red Pixel]);
  sell_all($item[Smelted Roe]);
  sell_all($item[Spicy Jumping Bean Burrito]);
  sell_all($item[Spicy Bean Burrito]);
  sell_all($item[Strongness Elixir]);
  sell_all($item[Sunken Chest]);
  sell_all($item[Tambourine Bells]);
  sell_all($item[Tequila Sunrise]);
  sell_all($item[Windchimes]);
  sell_all($item[valuable trinket]);

  // keep one:
  sell_all($item[cold ninja mask], 1);

  // starter items (keep one):
  sell_all($item[turtle totem], 1);
  sell_all($item[seal-clubbing club], 1);
  sell_all($item[saucepan], 1);
  sell_all($item[stolen accordion], 1);
  sell_all($item[disco ball], 1);


  // battlefield items for coins:
  sell_all($item[bullet-proof corduroys], 1);
  sell_all($item[communications windchimes]);
  sell_all($item[didgeridooka]);
  sell_all($item[green clay bead]);
  sell_all($item[hippy protest button]);
  sell_all($item[fire poi]);
  sell_all($item[flowing hippy skirt]);
  sell_all($item[oversized pipe]);
  sell_all($item[pink clay bead]);
  sell_all($item[purple clay bead]);
  sell_all($item[reinforced beaded headband], 1);
  sell_all($item[round purple sunglasses], 1);
  sell_all($item[wicker shield]);

  // keep three around for catburgling.
  sell_all($item[hot wing], 3);


  if (my_primestat() == $stat[moxie])
    sell_all($item[4-dimensional guitar]);
  else
    sell_all($item[4-dimensional guitar], 1);


  if (quest_status("questM02Artist") == FINISHED)
  {
    sell_all($item[rat whisker]);
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

}
