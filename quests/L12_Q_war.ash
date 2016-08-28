import "util/main.ash";
import "util/war_support.ash";

import "quests/L12_SQ_junkyard.ash";
import "quests/L12_SQ_arena.ash";

int defeated(string side);
int defeated();
int sidequests(string side);
int sidequests();
boolean sidequest(string quest, string side);
boolean sidequest(string quest);
void do_war(string side);
void do_war();

int defeated(string side)
{
  string prop = "hippiesDefeated";
  if (side == "hippy")
    prop = "fratboysDefeated";
  return (get_property(prop).to_int());
}
int defeated()
{
  return defeated(war_side());
}

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

boolean L12_Q_war(string side)
{
  if (my_level() < 12)
    return false;

  if (i_a($item[Talisman o' Namsilat]) == 0)
  {
    // we want to get this (from the Gaudy Pirates) before the war starts
    return false;
  }

  if (quest_status("questL12War") < 1)
  {
    warning("This script can't (yet) start the island war. Go do that.");
    wait(10);
    return false;
  }


  if (quest_status("questL12War") == FINISHED)
  {
    return false;
  }

  if (war_junkyard())
  {
    if (L12_SQ_junkyard(side))
      return true;
  }

  if (war_arena())
  {
    if (L12_SQ_arena(side))
      return true;

    // special case to skip out if the arena's not done, but we want to avoid
    // going forward with the war...
    if (get_property("sidequestArenaCompleted") == "none")
    {
      return false;
    }
  }


  string sq = setting("war_lighthouse");
  if (sq == "")
  {
    setting("war_lighthouse", "true");
    sq = "true";
  }
  if (sq == "true")
  {
    if (get_property("sidequestLighthouseCompleted") == "none")
    {
      cli_execute("call quests/L12_SQ_lighthouse.ash");
      if (get_property("sidequestLighthouseCompleted") == "none")
      {
        warning("Can't continue the war until the " + wrap("Lighthouse", COLOR_LOCATION) + " is complete.");
        return false;
      }
    }
  }


  if (sidequests() < 5)
  {
    warning("This script doesn't handle the sidequests yet. You should do those before running this.");
    abort();
  }

  location battle = $location[The Battlefield (Frat Uniform)];

  if (side == "hippy")
  {
    battle = $location[The Battlefield (Hippy Uniform)];
  }
  while(defeated() < 1000)
  {
    string msg = "hippies defeated";
    if (side == "hipppy")
    {
      msg = "fratboys defeated";
    }
    maximize("", war_outfit());
    dg_adventure(battle);
    progress(defeated(), 1000, msg);
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
