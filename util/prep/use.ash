import "util/inventory.ash";

void use_things()
{
  use_all($item[black pension check]);
  use_all($item[shiny stones]);
  use_all($item[ancient vinyl coin purse]);
  use_all($item[bag of park garbage]);
  use_all($item[bone with a price tag on it]);
  use_all($item[briefcase]);
  use_all($item[chest of the Bonerdagon]);
  use_all($item[carton of astral energy drinks]);
  use_all($item[collection of tiny spooky objects]);
  use_all($item[CSA discount card]);
  use_all($item[dungeon dragon chest]);
  use_all($item[duct tape wallet]);
  use_all($item[fat wallet]);
  use_all($item[gummi turtle]);
  use_all($item[irradiated turtle]);
  use_all($item[kobold treasure hoard]);
  use_all($item[meat globe]);
  use_all($item[O'RLY manual]);
  use_all($item[orcish meat locker]);
  use_all($item[old coin purse]);
  use_all($item[old leather wallet]);
  use_all($item[red box]);
  use_all($item[very overdue library book]);
  use_all($item[warm subject gift certificate]);


  use_all($item[old eyebrow pencil]);
  use_all($item[old rosewater cream]);

  use_all($item[Squat-Thrust Magazine]);
  use_all($item[Ye Olde Bawdy Limerick]);

  use_all($item[Frobozz Real-Estate Company Instant House (TM)]);

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


  // choiceAdventure778 <-- to make choices for the tonic djinn.

}
