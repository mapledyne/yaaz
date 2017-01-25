import "util/main.ash";
import "util/base/war_support.ash";

import "quests/L12_SQ_junkyard.ash";
import "quests/L12_SQ_arena.ash";
import "quests/L12_SQ_lighthouse.ash";
import "quests/L12_SQ_orchard.ash";
import "quests/L12_SQ_nuns.ash";

int sidequests(string side);
int sidequests();
boolean sidequest(string quest, string side);
boolean sidequest(string quest);
void do_war(string side);
void do_war();

int sidequests(string side)
{
  int count = 0;

  if (sidequest("Arena"))
    count += 1;
  if (sidequest("Farm"))
    count += 1;
  if (sidequest("Junkyard"))
    count += 1;
  if (sidequest("Lighthouse"))
    count += 1;
  if (sidequest("Nuns"))
    count += 1;
  if (sidequest("Orchard"))
    count += 1;

  return count;
}

int sidequests()
{
  return sidequests(war_side());
}

boolean sidequest(string quest, string side)
{
  string prop = "sidequest" + quest + "Completed";

  if (get_property(prop) == side)
    return true;
  return false;
}
boolean sidequest(string quest)
{
    return sidequest(quest, war_side());
}

void get_hippy_disguise()
{
  if (!have_outfit("filthy hippy disguise"))
  {
    log("Getting a " + wrap("filthy hippy disguise", COLOR_ITEM) + ".");
    while (!have_outfit("filthy hippy disguise"))
    {
      boolean b = yz_adventure($location[hippy camp]);
      if (!b)
        return;
    }
  }
}

boolean start_the_war(string side)
{
  string outfit = war_outfit();

  location camp = $location[hippy camp];
  if (side == "fratboy")
    camp = $location[frat house];

  maximize("", "filthy hippy disguise");
  if (!have_outfit(war_outfit()))
  {
    log("Off to get the " + wrap(outfit, COLOR_ITEM) + " from the " + wrap(camp) + ".");

    set_property("choiceAdventure141", 2); // random food
    set_property("choiceAdventure142", 2); // random food
    set_property("choiceAdventure145", 2); // random food
    set_property("choiceAdventure146", 2); // random food

  }
  while (!have_outfit(war_outfit()))
  {
    maximize("", "filthy hippy disguise");
    boolean b = yz_adventure(camp);
    if (!b)
      return true;
  }

  // we have the outfit. Now to start the war...

  camp = $location[wartime hippy camp];
  if (side == "hippy")
    camp = $location[wartime frat house];

  // should check to see if we have hippy war outfit and maybe change 139, 140?
  set_property("choiceAdventure139", 3); // fight space cadet
  set_property("choiceAdventure140", 3); // fight drill sergeant
  set_property("choiceAdventure141", 3); // start the war
  set_property("choiceAdventure142", 3); // start the war

  set_property("choiceAdventure143", 3); // fight war pledge
  set_property("choiceAdventure144", 3); // fight drill sergeant
  set_property("choiceAdventure145", 3); // start the war
  set_property("choiceAdventure146", 3); // start the war

  while (quest_status("warProgress") == UNSTARTED)
  {
    maximize("items, -combat", war_outfit());
    boolean b = yz_adventure(camp);
    if (!b)
      return true;
  }
  return true;
}

boolean L12_Q_war(string side)
{
  if (to_int(get_property("lastIslandUnlock")) >= my_ascensions())
    get_hippy_disguise();

  if (i_a($item[Talisman o' Namsilat]) == 0)
  {
    // we want to get this (from the Gaudy Pirates) before the war starts
    return false;
  }

  if (my_level() < 12)
    return false;

  if (quest_status("questL12War") == FINISHED)
    return false;

  if (quest_status("questL12War") == UNSTARTED)
  {
    log("Going to the council to start the War quest.");
    council();
  }

  if (quest_status("questL12War") == STARTED)
  {
    return start_the_war(side);
  }


  if (war_arena())
  {
    if (L12_SQ_arena())
      return true;
  }

  if (war_lighthouse())
  {
    if (L12_SQ_lighthouse())
      return true;
  }

  if (war_junkyard())
  {
    if (L12_SQ_junkyard())
      return true;
  }

  if (war_nuns())
  {
    if (L12_SQ_nuns())
      return true;
  }

  if (war_orchard())
  {
    if (L12_SQ_orchard())
      return true;
  }

  // handle case where the arena sidequest is paused while we wait for flyers to be delivered.
  if (war_arena() && get_property("sidequestArenaCompleted") == "none")
    return false;

  // handle case where the nuns sidequest is paused while we wait for digitized brigands
  if (war_nuns() && get_property("sidequestNunsCompleted") == "none")
    return false;

  // handle case where the lighthouse sidequest is paused while we wait for digitized lobsterfrogmen
  if (war_lighthouse() && get_property("sidequestLighthouseCompleted") == "none")
    return false;

  location battle = $location[The Battlefield (Frat Uniform)];

  if (side == "hippy")
  {
    battle = $location[The Battlefield (Hippy Uniform)];
  }

  // TODO: should do this for all the sidequests...
  if (war_orchard() && !war_orchard_accessible())
  {
    while(!war_orchard_accessible())
    {
      maximize("", war_outfit());
      boolean b = yz_adventure(battle);
      if (!b)
        return true;
    }
    return true;
  }

  while(war_defeated() < 1000)
  {
    maximize("", war_outfit());
    boolean b = yz_adventure(battle);
    if (!b)
      return true;
  }

  // turn in any last items...
  prep($location[none]);
  log("Warriors defeated. Now on to the final boss.");
  maximize("", war_outfit());

  if (side == "hippy")
  {
    visit_url("bigisland.php?place=camp&whichcamp=2");
  } else {
    visit_url("bigisland.php?place=camp&whichcamp=1");
  }
  visit_url("bigisland.php?action=bossfight&pwd");
  run_combat();
  if (quest_status("questL12War") > 10)
  {
    log("War quest complete!");
  } else {
    warning("I wasn't able to complete the war quest.");
  }
  return true;
}

boolean L12_Q_war()
{
  return L12_Q_war(war_side());
}

void main()
{
  L12_Q_war();
}
