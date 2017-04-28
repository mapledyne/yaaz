import "util/yz_main.ash";
import "util/base/yz_war_support.ash";

import "quests/council/yz_L12_SQ_junkyard.ash";
import "quests/council/yz_L12_SQ_arena.ash";
import "quests/council/yz_L12_SQ_lighthouse.ash";
import "quests/council/yz_L12_SQ_orchard.ash";
import "quests/council/yz_L12_SQ_nuns.ash";

int sidequests(string side);
int sidequests();
boolean sidequest(string quest, string side);
boolean sidequest(string quest);
void do_war(string side);
void do_war();

void L12_Q_war_progress()
{
  if (quest_status("questL12War") == STARTED)
  {
    task("Start the Island War");
  }

  if (quest_active("warProgress"))
  {
      if (war_arena()
          && get_property("sidequestArenaCompleted") == "none"
          && have_flyers())
      {
        int flyerML = get_property("flyeredML").to_int() / 100;
        progress(flyerML, "flyers delivered");
      }

      if (war_nuns()
          && get_property("sidequestNunsCompleted") == "none"
          && (war_nuns_accessible() || war_nuns_trick()))
      {
        string nuns_msg = "Meat returned to the Nuns";
        float drop = 1 + (numeric_modifier("meat drop") / 100);
        float min_meat = $monster[dirty thieving brigand].min_meat * drop;
        float max_meat = $monster[dirty thieving brigand].max_meat * drop;
        int remaining = 100000 - to_int(get_property("currentNunneryMeat"));

        int max_turns = round(remaining / min_meat);
        int min_turns = round(remaining / max_meat);

        nuns_msg += " (est remaining turns: " + min_turns + "-" + max_turns + ")";
        progress(to_int(get_property("currentNunneryMeat")), 100000, nuns_msg);
      }

      if (war_orchard()
          && war_orchard_accessible()
          && get_property("sidequestOrchardCompleted") == "none")
      {
        int count = 0;
        if (have_effect($effect[filthworm larva stench]) > 0)
          count = 1;
        if (have_effect($effect[filthworm drone stench]) > 0)
          count = 2;
        if (have_effect($effect[filthworm guard stench]) > 0)
          count = 3;
        if (have($item[heart of the filthworm queen]))
          count = 4;

        progress(count, 4, "Orchard filthworm progress");
      }

      if (war_junkyard()
          && get_property("sidequestJunkyardCompleted") == "none")
      {
        progress(junkyard_items(), 4, "junkyard tools recovered");
      }

      if (war_lighthouse()
          && get_property("sidequestLighthouseCompleted") == "none")
      {
        progress(item_amount($item[barrel of gunpowder]), 5, "barrels of gunpowder");
      }

      string msg = "hippies defeated";
      if (war_side() == "hippy")
      {
        msg = "fratboys defeated";
      }

      int left = (1000 - war_defeated()) / war_multiplier();
      msg += " (" + war_multiplier() + "/turn, " + left + " turns remain)";

      progress(war_defeated(), 1000, msg);

      int sq_completed = 0;
      int sq_active = 0;
      string sq_msg = "";

      if (setting("war_nuns", "false") == "true"
          || get_property("sidequestNunsCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestNunsCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Nuns";
        } else {
          sq_msg += UNCHECKED + "Nuns";
        }
      }

      if (setting("war_orchard", "true") == "true"
          || get_property("sidequestOrchardCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestOrchardCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Orchard";
        } else {
          sq_msg += UNCHECKED + "Orchard";
        }
      }

      if (setting("war_lighthouse", "true") == "true"
          || get_property("sidequestLighthouseCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestLighthouseCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Lighthouse";
        } else {
          sq_msg += UNCHECKED + "Lighthouse";
        }
      }

      if (setting("war_arena", "true") == "true"
          || get_property("sidequestArenaCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestArenaCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Arena";
        } else {
          sq_msg += UNCHECKED + "Arena";
        }
      }

      if (setting("war_junkyard", "true") == "true"
          || get_property("sidequestJunkyardCompleted") != "none")
      {
        sq_active++;
        if (length(sq_msg) > 0) sq_msg += " ";
        if (get_property("sidequestJunkyardCompleted") != "none")
        {
          sq_completed++;
          sq_msg += CHECKED + "Junkyard";
        } else {
          sq_msg += UNCHECKED + "Junkyard";
        }
      }
      sq_msg = "war sidequests (" + sq_msg + ")";
      if (sq_active > 0) progress(sq_completed, sq_active, sq_msg);

  }

}

void L12_Q_war_cleanup()
{
  foreach hmph in $items[communications windchimes,
                          didgeridooka,
                          green clay bead,
                          hippy protest button,
                          fire poi,
                          flowing hippy skirt,
                          oversized pipe,
                          pink clay bead,
                          purple clay bead,
                          red class ring,
                          blue class ring,
                          white class ring]
  {
    sell_all(hmph);
  }

  foreach smashy in $items[reinforced beaded headband,
                            round purple sunglasses,
                            bullet-proof corduroys,
                            wicker shield]
  {
    pulverize_all(smashy, 1);
  }

  stock_item($item[gauze garter], 10 - item_amount($item[filthy poultice]));
  stock_item($item[filthy poultice], 10 - item_amount($item[gauze garter]));

  if (total_shadow_helpers() >= 10)
  {
    item trophy = $item[commemorative war stein];
    if (war_side() == "hippy") trophy = $item[fancy seashell necklace];

    coinmaster master = trophy.seller;
    int tokens = master.available_tokens;
    int qty = tokens / (sell_price(master, trophy));
    buy(master, qty, trophy);
  }
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

boolean get_hippy_disguise()
{
  maybe_pull($item[filthy corduroys]);
  maybe_pull($item[filthy knitted dread sack]);
  if (have_outfit("filthy hippy disguise")) return false;

  log("Getting a " + wrap("filthy hippy disguise", COLOR_ITEM) + ".");
  yz_adventure($location[hippy camp], "items");
  return true;
}

boolean start_the_war(string side)
{
  string outfit = war_outfit();

  location camp = $location[wartime hippy camp];
  if (side == "fratboy")
    camp = $location[wartime frat house];

  foreach key,doodad in outfit_pieces(outfit)
  {
    maybe_pull(doodad);
  }

  if (!have_outfit(war_outfit()))
  {
    if (dangerous(camp))
    {
      info("Will try collecting the " + wrap(war_outfit(), COLOR_ITEM) + " when it's a bit less dangerous.");
      return false;
    }
    log("Off to get the " + wrap(outfit, COLOR_ITEM) + " from the " + wrap(camp) + ".");

    set_property("choiceAdventure141", 2); // random food
    set_property("choiceAdventure142", 2); // random food
    set_property("choiceAdventure145", 2); // random food
    set_property("choiceAdventure146", 2); // random food

    maximize("", "filthy hippy disguise");
    yz_adventure(camp);
    return true;
  }

  // we have the outfit. Now to start the war...

  camp = $location[wartime hippy camp];
  if (side == "hippy")
    camp = $location[wartime frat house];

  if (dangerous(camp))
  {
    info("Will try starting the war when it's a bit less dangerous.");
    return false;
  }

  // should check to see if we have hippy war outfit and maybe change 139, 140?
  set_property("choiceAdventure139", 3); // fight space cadet
  set_property("choiceAdventure140", 3); // fight drill sergeant
  set_property("choiceAdventure141", 3); // start the war
  set_property("choiceAdventure142", 3); // start the war

  set_property("choiceAdventure143", 3); // fight war pledge
  set_property("choiceAdventure144", 3); // fight drill sergeant
  set_property("choiceAdventure145", 3); // start the war
  set_property("choiceAdventure146", 3); // start the war

  maximize("items, -combat", war_outfit());
  yz_adventure(camp);
  return true;
}

boolean L12_Q_war(string side)
{

  if (to_int(get_property("lastIslandUnlock")) >= my_ascensions())
    if (get_hippy_disguise()) return true;

  if (!have($item[Talisman o' Namsilat]))
  {
    // we want to get this (from the Gaudy Pirates) before the war starts
    return false;
  }

  if (my_level() < 12) return false;

  if (quest_status("questL12War") == FINISHED) return false;

  if (quest_status("questL12War") == UNSTARTED)
  {
    log("Going to the council to start the War quest.");
    council();
    return true;
  }

  if (quest_status("questL12War") == STARTED)
  {
    return start_the_war(side);
  }

  int stuffing_used = to_int(setting("stuffing_used"));

  while(have($item[stuffing fluffer])
        && war_defeated() < 64)
  {
    log("Throwing a " + wrap($item[stuffing fluffer]) + " into the war.");
    boolean u = use(1, $item[stuffing fluffer]);
    if (u)
    {
      stuffing_used += 1;
      save_setting("stuffing_used", stuffing_used);
    }
  }


  if (war_arena())
  {
    if (L12_SQ_arena()) return true;
  }

  if (war_lighthouse())
  {
    if (L12_SQ_lighthouse()) return true;
  }

  if (war_junkyard())
  {
    if (L12_SQ_junkyard()) return true;
  }

  if (war_nuns())
  {
    if (L12_SQ_nuns()) return true;
  }

  if (war_orchard())
  {
    if (L12_SQ_orchard()) return true;
  }

  // handle case where the arena sidequest is paused while we wait for flyers to be delivered.
  if (war_arena()
      && get_property("sidequestArenaCompleted") == "none")
    return false;

  // These next two try to let us finish other quests (nuns & lighthouse) while we have the right thing
  // copied, but if we're done with everything (shorthanding this to the L11 quest since it's by far
  // the most likely) we'll do the war anyway since the copy will show up and at least fighting in the
  // war will make some progress. Can't do this in the arena as easily since working in the war there
  // won't advance the arena quest.

  // handle case where the nuns sidequest is paused while we wait for digitized brigands
  if (war_nuns()
      && get_property("sidequestNunsCompleted") == "none"
      && to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand]
      && quest_status("questL11MacGuffin") != FINISHED)
    return false;

  // handle case where the lighthouse sidequest is paused while we wait for digitized lobsterfrogmen
  if (war_lighthouse()
      && get_property("sidequestLighthouseCompleted") == "none"
      && to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[lobsterfrogman]
      && quest_status("questL11MacGuffin") != FINISHED)
    return false;

  location battle = $location[The Battlefield (Frat Uniform)];

  if (side == "hippy")
  {
    battle = $location[The Battlefield (Hippy Uniform)];
  }

  if (war_defeated() < 1000)
  {
    int killed = war_defeated();
    maximize("", war_outfit());
    boolean b = yz_adventure(battle);
    if (!b
        && can_adventure()
        && killed == war_defeated())
    {
      // there are a few situations where mafia doesn't count the kills right,
      // notably there's a strangeness with the stuffing fluffer that will
      // cause us not to be able to reach 1000 killed, even when we actually have
      // Hopefully we can pull this sort of hack out at some point.

      string prop = "hippiesDefeated";
      if (setting("war_side") == "hippy")
        prop = "fratboysDefeated";
      warning("Mafia seems out of sync with our kills on the battlefield.");
      warning("Manually incrementing kills until we're caught up with reality.");
      set_property(prop, war_defeated() + 1);
    }
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
  run_combat('yz_consult');
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
  while (L12_Q_war()) {L12_Q_war_cleanup();}
}
