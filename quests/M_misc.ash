import "util/main.ash";
import "util/progress.ash";

boolean untinker()
{
  if (quest_status("questM01Untinker") == FINISHED)
    return false;

  if (quest_status("questM01Untinker") == UNSTARTED)
  {
    log("Visiting the " + wrap("Untinker", COLOR_LOCATION) + " to start his quest.");
    visit_url("place.php?whichplace=forestvillage&preaction=screwquest&action=fv_untinker_quest");
    if (knoll_available())
    {
      log("Visiting " + wrap("Innabox", COLOR_LOCATION) + " to get the " + wrap("screwdriver", COLOR_ITEM) + ".");
      visit_url("place.php?whichplace=knoll_friendly&action=dk_innabox");
    }
  }

  if (quest_status("questM01Untinker") == 1)
  {
    log("Returning the " + wrap($item[rusty screwdriver]) + " to the " + wrap("Untinker", COLOR_LOCATION) + ".");
    visit_url("place.php?whichplace=forestvillage&action=fv_untinker");
  }

  return false;
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
  if (have($item[Dingy dinghy]))
    return false;
  if (!have($item[bitchin' meatcar]))
    return false;
  if (my_adventures() < 30)
    return false;

  if (item_amount($item[dingy planks]) == 0 && my_meat() > 1000)
  {
    buy(1, $item[dingy planks]);
  }

  while (item_amount($item[Shore Inc. Ship Trip Scrip]) < 3 && !have($item[dinghy plans]))
  {
    log("Going on a shore vacation to get some " + wrap($item[Shore Inc. Ship Trip Scrip]) + ".");
    adventure(1, $location[The Shore\, Inc. Travel Agency]);
    progress_sheet();
  }
  if (!have($item[dinghy plans]))
  {
    log("Buying " + wrap($item[dinghy plans]) + ".");
    cli_execute("acquire dinghy plans");
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

boolean M_misc()
{
  if (toot()) return true;
  if (untinker()) return true;
  if (continuum()) return true;

  if (dingy()) return true;

  return false;
}

void main()
{
  M_misc();
}
