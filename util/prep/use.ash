import "util/base/inventory.ash";

void use_things()
{
  use_all($item[black pension check]);
  use_all($item[shiny stones]);
  use_all($item[ancient vinyl coin purse]);
  use_all($item[bag of park garbage]);
  use_all($item[black picnic basket]);
  use_all($item[bone with a price tag on it]);
  use_all($item[briefcase]);
  use_all($item[chest of the Bonerdagon]);
  use_all($item[carton of astral energy drinks]);
  use_all($item[collection of tiny spooky objects]);
  use_all($item[CSA discount card]);
  use_all($item[dungeon dragon chest]);
  use_all($item[duct tape wallet]);
  use_all($item[Effermint&trade; tablets]);
  use_all($item[fat wallet]);
  use_all($item[Frobozz Real-Estate Company Instant House (TM)]);
  use_all($item[gummi turtle]);
  use_all($item[irradiated turtle]);
  use_all($item[kobold treasure hoard]);
  use_all($item[letter from king ralph xi]);
  use_all($item[meat globe]);
  use_all($item[Newbiesport&trade; tent]);
  use_all($item[O'RLY manual]);
  use_all($item[orcish meat locker]);
  use_all($item[old coin purse]);
  use_all($item[old eyebrow pencil]);
  use_all($item[old leather wallet]);
  use_all($item[old rosewater cream]);
  use_all($item[pack of KWE trading card]);
  use_all($item[Penultimate Fantasy chest]);
  use_all($item[pork elf goodies sack]);
  use_all($item[red box]);
  use_all($item[Squat-Thrust Magazine]);
  use_all($item[very overdue library book]);
  use_all($item[warm subject gift certificate]);
  use_all($item[Ye Olde Bawdy Limerick]);

  if (item_amount($item[steel margarita]) > 0)
  {
    log("Drinking a " + wrap($item[steel margarita]) + ". Liver! Liver! Liver!");
    drink(1, $item[steel margarita]);
  }
  if (item_amount($item[steel-scented air freshener]) > 0)
  {
    log("Chewing a " + wrap($item[steel-scented air freshener]) + ". Spleen! Spleen! Spleen!");
    chew(1, $item[steel-scented air freshener]);
  }
  if (item_amount($item[steel lasagna]) > 0)
  {
    log("Eating a " + wrap($item[steel lasagna]) + ". Stomach! Stomach! Stomach!");
    eat(1, $item[steel lasagna]);
  }


  if (quest_status("questL09Topping") < 1)
  {
    use_all($item[smut orc keepsake box]);
  }

  if (item_amount($item[abridged dictionary]) > 0)
  {
    cli_execute("untinker abridged dictionary");
  }

  if (get_property("questL10Garbage") == "started" && item_amount($item[enchanted bean]) > 0)
  {
    use(1, $item[enchanted bean]);
  }

  if (get_property("hiddenTavernUnlock").to_int() < my_ascensions() && item_amount($item[book of matches]) > 0)
  {
    use(1, $item[book of matches]);
  }

  while (item_amount($item[Talisman o' Namsilat]) == 0 && item_amount($item[gaudy key]) > 0)
  {
    cli_execute("checkpoint");
    if (!have_equipped($item[pirate fledges]))
    {
      equip($item[pirate fledges]);
    }
    use(1, $item[gaudy key]);
    cli_execute("outfit checkpoint");
  }


  if (setting("used_tonic_djinn") != "true" && item_amount($item[tonic djinn]) > 0)
  {
    int choice = 1;
    if (my_meat() < 5000)
    {
      choice = 1;
    } else {
      switch(my_primestat())
      {
        case $stat[Muscle]:
          choice = 2;
          break;
        case $stat[Mysticality]:
          choice = 3;
          break;
        case $stat[Moxie]:
          choice = 4;
          break;
      }
    }
    string msg = "Meat";
    if (choice != 1)
      msg = to_string(my_primestat());
    set_property("choiceAdventure778", choice);
    warning("Using a " + wrap($item[tonic djinn]) + " to get some " + wrap(msg, COLOR_ITEM) + ".");
    use(1, $item[tonic djinn]);
    // mafia doesn't seem to know the tonic djinn goes away after use.
    cli_execute("refresh inv");
    save_daily_setting("used_tonic_djinn", "true");
  }

}
