import "quests/council/yz_L11_SQ_black_market.ash";
import "quests/council/yz_L11_SQ_copperhead.ash";
import "quests/council/yz_L11_SQ_desert.ash";
import "quests/council/yz_L11_SQ_hidden_city.ash";
import "quests/council/yz_L11_SQ_palindome.ash";
import "quests/council/yz_L11_SQ_summoning.ash";
import "quests/council/yz_L11_SQ_pyramid.ash";
import "quests/council/yz_L11_SQ_zeppelin.ash";

void L11_Q_macguffin_progress()
{
  if (!quest_active("questL11MacGuffin")) return;

  task("Recover the " + wrap("Holy MacGuffin", COLOR_ITEM) + ".");

  if (quest_active("questL11Black"))
    progress(get_property("blackForestProgress").to_int(), 5, "progress through " + wrap($location[the black forest]));

  if (quest_status("questL11Black") > UNSTARTED
      && !have($item[beehive]))
  {
    task("Find a " + wrap($item[beehive]));
  }

  if (quest_active("questL11Desert"))
  {
    int desert = to_int(get_property("desertExploration"));
    progress(desert, "desert explored");
  }

  if (quest_status("questL11Worship") >= 3 && quest_status("questL11Worship") < FINISHED)
  {
    if (!have($item[antique machete])) task("Find an " + wrap($item[antique machete]));
    progress(item_amount($item[stone triangle]), 4, "stone triangles from the Hidden City");

    if (quest_status("questL11Doctor") == UNSTARTED)
      progress($location[An Overgrown Shrine (Southwest)].turns_spent, 3, "defeated southwest/hospital " + wrap($monster[dense liana]));
    if (quest_status("questL11Spare") == UNSTARTED)
      progress($location[An Overgrown Shrine (Southeast)].turns_spent, 3, "defeated southeast/bowling " + wrap($monster[dense liana]));
    if (quest_status("questL11Business") == UNSTARTED)
      progress($location[An Overgrown Shrine (Northeast)].turns_spent, 3, "defeated northeast/office " + wrap($monster[dense liana]));
    if (quest_status("questL11Curses") == UNSTARTED)
      progress($location[An Overgrown Shrine (Northwest)].turns_spent, 3, "defeated northwest/apartment " + wrap($monster[dense liana]));

    int surgeon = to_int(get_property("hiddenHospitalProgress"));
    if (quest_active("questL11Doctor"))
    {
      int s = numeric_modifier("surgeonosity");
      progress(s, 5, "surgeonosity (" + (s * 10) + "% to find protector spirit)");
    }

    if (quest_active("questL11Spare"))
    {
      progress(to_int(get_property("hiddenBowlingAlleyProgress")), 5, "bowling balls rolled");
    }

    if (quest_active("questL11Business"))
    {
      if (!have($item[McClusky file (complete)]))
      {
        if (!have($item[boring binder clip]))
        {
          task("get boring binder clip");
        }
        progress(mcclusky_items(), 5, "McClusky file pages");
      } else {
        task("fight the Protector Spirit in the Office Building");
      }
    }

    if (quest_active("questL11Curses"))
    {
      int curse = 0;
      if (have_effect($effect[once-cursed]) > 0)
        curse = 1;
      if (have_effect($effect[twice-cursed]) > 0)
        curse = 2;
      if (have_effect($effect[thrice-cursed]) > 0)
        curse = 3;
      progress(curse, 3, "curses for the penthouse");
    }

  }

  if (quest_active("questL11Palindome"))
  {
    if (quest_status("questL11Palindome") < 1)
    {
      progress(to_int(get_property("palindomeDudesDefeated")), 5, "Palindome dudes defeated");
      progress(palindome_items(), 5, "Palindome items found");
    }
  }

  if (quest_active("questL11Shen"))
  {
    task("Find the " + wrap(shen_item()) + " in " + wrap(shen_to_location()) + " for Shen.");
  }

  if (quest_active("questL11Ron"))
  {
    if (quest_status("questL11Ron") == 1)
    {
      int prot = to_int(get_property("zeppelinProtestors"));
      progress(prot, 80, "Protestors defeated from " + wrap($location[A Mob of Zeppelin Protesters]));
    }

  }


  if (quest_active("questL11Manor"))
  {
    if (quest_status("questL11Manor") == 2)
    {
      if (!can_make_wine_bomb())
      {
        progress(scavenger_hunt_items(), 6, "manor scavenger hunt items");
      } else {
        if (!have($item[unstable fulminate]))
        {
          task("make unstable fulminate");
        } else {
          task("make wine bomb");
        }
      }
    }
  }

  if (quest_active("questL11Pyramid") && !get_property("pyramidBombUsed").to_boolean())
  {
    progress(turners(), 10, "wheel turning things");
  }

}

void L11_Q_macguffin_cleanup()
{

}

boolean L11_Q_macguffin()
{

  if (my_level() < 11)
    return false;

  if (quest_status("questL11MacGuffin") == UNSTARTED)
  {
    log("Going to the council to start the MacGuffin quest.");
    council();
  }

  if (L11_SQ_copperhead()) return true;
  if (L11_SQ_black_market()) return true;
  if (L11_SQ_hidden_city()) return true;
  if (L11_SQ_palindome()) return true;
  if (L11_SQ_zeppelin()) return true;
  if (L11_SQ_summoning()) return true;
  if (to_int(get_property("lastDesertUnlock")) >= my_ascensions())
  {
    if (L11_SQ_desert()) return true;
    if (L11_SQ_pyramid()) return true;
  }

  if (item_amount($item[[2334]Holy MacGuffin]) > 0)
  {
    log("Returning the " + wrap($item[[2334]Holy MacGuffin]) + " to the council.");
    council();
    return true;
  }

  return false;
}

void main()
{
  while (L11_Q_macguffin());
}
