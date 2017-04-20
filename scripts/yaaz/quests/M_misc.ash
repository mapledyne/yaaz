import "util/main.ash";

void M_misc_progress()
{

}

void M_misc_cleanup()
{

}

boolean toot()
{
  if (quest_status("questL02Larva") == UNSTARTED && my_level() > 1)
  {
    log("Visiting " + wrap("The Toot Oriole", COLOR_LOCATION) + " to kick things off.");
    visit_url("tutorial.php?action=toot");
    council();
  }
  return false;
}

boolean continuum()
{
  if (have($item[continuum transfunctioner])
      || quest_status("questL02Larva") == UNSTARTED)
    return false;

  log("Going to get the " + wrap($item[continuum transfunctioner]) + " from the mystic.");

  visit_url("place.php?whichplace=forestvillage&action=fv_mystic");
  visit_url("choice.php?pwd="+my_hash()+"&whichchoice=664&option=1&choiceform1=Sure%2C+old+man.++Tell+me+all+about+it.");
  visit_url("choice.php?pwd="+my_hash()+"&whichchoice=664&option=1&choiceform1=Against+my+better+judgment%2C+yes.");
  visit_url("choice.php?pwd="+my_hash()+"&whichchoice=664&option=1&choiceform1=Er,+sure,+I+guess+so...");

  return false;
}

boolean dingy()
{
  if (have($item[Dingy dinghy])) return false;
  if (to_int(get_property("lastDesertUnlock")) < my_ascensions()) return false;

  if (my_adventures() < 30)
    return false;

  if (item_amount($item[dingy planks]) == 0 && my_meat() > 1000)
  {
    buy(1, $item[dingy planks]);
  }

  maybe_pull($item[Shore Inc. Ship Trip Scrip], 3);

  if (item_amount($item[Shore Inc. Ship Trip Scrip]) < 3)
  {

    switch (my_primestat())
    {
      case $stat[muscle]:
        set_property("choiceAdventure793", 1);
        break;
      case $stat[mysticality]:
        set_property("choiceAdventure793", 2);
        break;
      case $stat[moxie]:
        set_property("choiceAdventure793", 3);
        break;
    }
    log("Going on a shore vacation to get some " + wrap($item[Shore Inc. Ship Trip Scrip]) + ".");
    adventure(1, $location[The Shore\, Inc. Travel Agency]);
    return true;
  }

  if (!have($item[dinghy plans]))
  {
    log("Buying " + wrap($item[dinghy plans]) + ".");
    cli_execute("acquire dinghy plans");
    return true;
  }

  if (have($item[dinghy plans])
      && have($item[dingy planks]))
  {
    log("Making a " + wrap($item[Dingy dinghy]) + ".");
    use(1, $item[dinghy plans]);
    return true;
  }

  return false;
}

boolean nagamar()
{
  if (quest_status("questL10Garbage") != FINISHED) return false;
  if (have($item[wand of nagamar])) return false;
  if (!have($item[disassembled clover])) return false;
  if (!can_adventure()) return false;
  if (my_path() == "Nuclear Autumn") return false;

  log("Going to get the pieces of the " + wrap($item[wand of nagamar]) + ".");
  boolean clove = yz_clover($location[The Castle in the Clouds in the Sky (Basement)]);
  if (clove)
  {
    log("Making a " + wrap($item[wand of nagamar]) + ".");
    create(1, $item[wand of nagamar]);
    return true;
  }
  return true;
}

boolean M_misc()
{
  if (toot()) return true;
  if (continuum()) return true;
  if (dingy()) return true;
  if (nagamar()) return true;

  return false;
}

void main()
{
  while(M_misc());
}
