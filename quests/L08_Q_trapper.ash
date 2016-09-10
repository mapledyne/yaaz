import "util/main.ash";
string TRAPPER_URL="place.php?whichplace=mclargehuge&action=trappercabin";

void visit_trapper()
{
  log("Visiting the Trapper.");
  visit_url(TRAPPER_URL);
}

int get_cheese()
{
  item cheese = $item[goat cheese];
  location goatlet = $location[the goatlet];

  if (item_amount(cheese) >= 3)
    return item_amount(cheese);

print("1cheesssssseeeee....");
  add_attract($monster[dairy goat]);
  print("2cheesssssseeeee....");
  while(item_amount(cheese) < 3 && can_adventure())
  {
    dg_adventure(goatlet, "items");
    progress(item_amount(cheese), 3, "goat cheese");
  }
  print("3cheesssssseeeee....");
  remove_attract($monster[dairy goat]);
  return item_amount(cheese);
}

boolean L08_Q_trapper()
{
  if (my_level() < 8)
    return false;

  if (quest_status("questL08Trapper") == FINISHED)
    return false;

  if (quest_status("questL08Trapper") == UNSTARTED)
  {
    log("Trapper quest isn't started yet. Talking to the council.");
    council();
  }

  if (quest_status("questL08Trapper") == STARTED)
  {
    log("Talking to the trapper to see what ore he wants.");
    visit_trapper();
    log("Trapper wants " + wrap(to_item(get_property("trapperOre"))) + ".");
    return true;
  }

  if (quest_status("questL08Trapper") == 1)
  {
    item ore = to_item(get_property("trapperOre"));
    int goat_qty = get_cheese();

    while (item_amount(ore) < 3)
    {
      if (can_deck("mine"))
      {
        cheat_deck("mine", "get some ore for the trapper.");
        continue;
      }

      if (item_amount($item[disassembled clover]) > 0)
      {
        dg_clover($location[Itznotyerzitz Mine]);
        continue;
      }

      warning("No good ways remain to get the " + wrap(ore) + " without mining.");
      warning("I don't want to do that, so waiting until tomorrow for some clover.");
      warning("Mine manually if you want to go about this a different way.");
      return false;
    }

    if (goat_qty < 3)
    {
      warning("You should have three " + wrap($item[goat cheese]) + " at this point, but you don't.");
      abort();
    }

    log("Three " + wrap($item[goat cheese]) + " and three " + wrap(ore) + " found.");
    log("Returning these to the trapper.");
    visit_trapper();
    return true;
  }

  if (quest_status("questL08Trapper") == 5)
  {
    log("Returning " + wrap($item[groar's fur]) + " to the Trapper.");
    visit_trapper();
    return true;
  }

  warning("There's something else we should do with the trapper, it's just not coded yet.");
  wait(10);
  return false;
}

void main()
{
  L08_Q_trapper();
}
