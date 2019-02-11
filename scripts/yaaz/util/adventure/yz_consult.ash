import "util/base/yz_inventory.ash";
import "util/base/yz_monsters.ash";
import "special/locations/yz_terminal.ash";
import "util/base/yz_monsters.ash";
import "util/base/yz_war_support.ash";
import "util/base/yz_quests.ash";

import <SmartStasis.ash>;

boolean attracted(monster foe)
{
  monster digitized = to_monster(get_property("_sourceTerminalDigitizeMonster"));
  int copiesmade = prop_int("_sourceTerminalDigitizeMonsterCount");
  if (digitized == foe && copiesmade <= 2) return true;
  if (to_monster(get_property("enamorangMonster")) == foe) return true;
  if (to_monster(get_property("_latteMonster")) == foe) return true;

  return false;
}

string attract_action(monster foe)
{
  if (have_skill($skill[digitize])
      && digitize_remaining() > 0)
  {
    return "skill digitize";
  }

  if (have_skill($skill[offer latte to Opponent])
      && !prop_bool("_latteCopyUsed"))
  {

    return "skill offer latte to opponent";
  }

  if (have($item[LOV Enamorang])
      && get_property("enamorangMonster") == "")
  {
    return "item LOV enamorang";
  }
  if (have_skill($skill[Transcendent Olfaction])
      && have_effect($effect[on the trail]) == 0
      && my_mp() > mp_cost($skill[Transcendent Olfaction]))
  {
    return "skill Transcendent Olfaction";
  }

  return "";
}

string maybe_attract(monster foe)
{
  if (foe == $monster[none]) return "";

  string action = attract_action(foe);

  if (action == "") return "";

  if (attracted(foe)) return "";

  monster newyoumon = to_monster(get_property("_newYouQuestMonster"));
  if (get_property("_newYouQuestCompleted") != "false") newyoumon = $monster[none];

  if (is_bounty_monster(foe)) return action;

  if (newyoumon == foe) return action;
  if (monster_attract contains foe) return action;

  return "";
}

string maybe_duplicate(monster foe)
{
  if (!have_skill($skill[duplicate])) return "";
  int dupes = prop_int("_sourceTerminalDuplicateUses");
  int max_dupes = 1;
  if (my_path() == "The Source") max_dupes = 5;

  if (dupes >= max_dupes) return "";

  // bail if the monster is likely to kill us.
  if (expected_damage(foe) > my_hp() / 2) return "";

  switch (foe)
  {
    default:
      return "";
    case $monster[gaudy pirate]:
      if (have($item[Talisman o' Namsilat])) return "";
      if (have($item[snakehead charrrm])) return "";
      break;
  }

  return "skill duplicate";
}

string maybe_extract(monster foe)
{
  if (have_skill($skill[extract jelly]))
  {
    if (foe.attack_element != $element[none])
      return "skill extract jelly";
  }
  return "";
}

string maybe_shadow(monster foe)
{
  // this could obviously use some much better finesse.
  if (foe != $monster[your shadow]) return "";

  if (have_skill($skill[Ambidextrous Funkslinging]))
  {
    item healing1 = $item[gauze garter];
    item healing2 = $item[gauze garter];

    if (item_amount($item[gauze garter]) < 2) healing2 = $item[filthy poultice];
    if (item_amount($item[gauze garter]) < 1) healing1 = $item[filthy poultice];

    return "item " + healing1 + ", " + healing2;
  }
  abort("Combat with Your Shadow without the skill Ambidextrous Funkslinging isn't yet supported. Handle this battle yourself.");
  return "";
}

string maybe_yellow_ray(monster foe)
{
  if (have_effect($effect[everything looks yellow]) > 0) return "";

  item yr = yellow_ray_item();
  if (yr == $item[none]) return "";

  switch (foe)
  {
    default:
      return "";
    case $monster[frat warrior drill sergeant]:
    case $monster[war pledge]:
    case $monster[War Frat 151st Infantryman]:
      if (war_side() != "fratboy") return "";
      if (have_outfit(war_outfit())) return "";
      break;
    case $monster[war hippy drill sergeant]:
    case $monster[war hippy (space) cadet]:
      if (war_side() != "hippy") return "";
      if (have_outfit(war_outfit())) return "";
      break;
  }
  return "item " + yr;
}

string maybe_banish(monster foe)
{
// $skill[breath out]

  string banish = "";
  if (have_skill($skill[breathe out]))
  {
    banish = "skill breathe out";
  }
  else if (have_skill($skill[snokebomb]) && my_mp() > mp_cost($skill[snokebomb]))
  {
    banish = "skill snokebomb";
  }
  else if (my_fury() >= 5 && have_skill($skill[batter up!]))
  {
    banish = "skill batter up!";
  }
  else if (have($item[tennis ball]))
  {
    banish = "item tennis ball";
  }
  else if (have_skill($skill[throw latte on opponent])
           && get_property("_latteBanishUsed") == "false")
  {
    banish = "skill throw latte on opponent";
  }
  else if (have($item[Daily Affirmation: Be a Mind Master]))
  {
    banish = "item Daily Affirmation: Be a Mind Master";
  }
  else if (have_skill($skill[Macrometeorite]))
  {
    // not exactly a banish, but similar.
    banish = "skill Macrometeorite";
  }
  else if (have($item[Daily Affirmation: Adapt to Change Eventually]))
  {
    // not exactly a banish, but similar.
    banish = "item Daily Affirmation: Adapt to Change Eventually";
  }
  else if (have_skill($skill[reflex hammer]) && prop_int("_reflexHammerUsed") < 3)
  {
    banish = "skill reflex hammer";
  }

  if (banish == "") return "";

  if (monster_banish contains foe)
  {
    log("Trying to banish the " + wrap(foe) + " with " + wrap(banish, COLOR_MONSTER) + ".");
    return banish;
  }

  return "";
}

string maybe_lta_item(monster foe)
{
  if (foe == $monster[Villainous Minion])
  {
    // Use a spy item if we have one, for the quest
    if (
      have($item[Knob Goblin firecracker])
      && !get_property("_villainLairFirecrackerUsed").to_boolean()
    )
    {
      return "item Knob Goblin firecracker";
    }

    if (
      have($item[spider web])
      && !get_property("_villainLairWebUsed").to_boolean()
    )
    {
      return "item spider web";
    }

    if (
      have($item[razor-sharp can lid])
      && !get_property("_villainLairCanLidUsed").to_boolean()
    )
    {
      return "item razor-sharp can lid";
    }
  }
  return "";
}

string maybe_run(monster foe)
{
  // check for spooky jellied to see if we want to run so we defeat someone else?
  return "";
}

string maybe_latte(monster foe)
{
  if (!have_skill($skill[gulp latte])) return "";
  if (get_property("_latteBanishUsed") == "false") return "";
  if (get_property("_latteCopyUsed") == "false") return "";

  if (my_mp() < (my_maxmp() / 2) || my_hp() < (my_maxhp() / 2))
    return "skill gulp latte";

  return "";
}

string maybe_grab(monster foe)
{
  string grab = "";

  if (my_familiar() == $familiar[xo skeleton]
      && prop_int("_xoHugsUsed") < 11)
  {
    grab = "skill hugs and kisses!";
  }
  else if (have($item[Daily Affirmation: Always be Collecting]))
  {
    grab = "item Daily Affirmation: Always be Collecting";
  }

  if (grab == "") return "";

  if (monster_grab contains foe) return grab;

  switch(foe)
  {
    case $monster[blooper]:
      if (!have($item[digital key]))
        return grab;
      break;
    case $monster[toothy sklelton]:
    case $monster[spiny skelelton]:
    case $monster[pygmy witch surgeon]:
      return grab;
    case $monster[pygmy bowler]:
      if (prop_int("hiddenBowlingAlleyProgress") < 6)
        return grab;
      break;
  }

  if (get_location_monsters($location[hippy camp]) contains foe) return grab;

  return "";
}

string maybe_portscan(monster foe)
{
  if (!have_skill($skill[portscan])) return "";

  // this skill isn't really optimal, so skip if we're trying to be hardcore:
  if (to_boolean(setting("aggressive_optimize"))) return true;

  // if we can't, the skill shouldn't show up, but an easy safeguard:
  if (portscans_remaining() < 1) return "";

  if (my_mp() < mp_cost($skill[portscan]) * 3) return "";

  // skip if we won't easily kill the current monster - there'll be other opportunities:
  if (expected_damage(foe) > my_hp() * 4) return "";

  monster scanned = $monster[government agent];
  if (my_path() == "The Source") scanned = $monster[source agent];
  if (dangerous(scanned)) return "";

  return "skill portscan";
}

string maybe_sharpen(monster foe)
{
  monster sharp = to_monster(get_property("_newYouQuestMonster"));
  if (sharp != foe) return "";
  if (prop_bool("_newYouQuestCompleted")) return "";

  int last_sharp = to_int(setting("newyou_last_sharp", "0"));
  if (last_sharp == turns_played()) return "";

  save_daily_setting("newyou_last_sharp", turns_played());
  return "skill " + get_property("_newYouQuestSkill");
}

/*
string consult_fight() {
	string result;

	if(monster_stat("hp") <= 0)
  {
    error("I can't determine the monster's HP. Please finish this fight manually and rerun yaaz to continue.");
    quit();
  }

	if(finished())
		return "";

	kill_it = Calculate_Options(monster_stat("hp")); //Set up the damage dealt

	if((count(kill_it) > 0))
		Perform_Actions();
	else {
		if(to_int(vars["verbosity"]) >= 3) {
			vprint("WHAM: Unable to determine a valid combat strategy. For your benefit here are the numbers for your combat options.", "purple", 3);

			allMyOptions(-1);
			sort iterateoptions by -dmg_dealt(get_action(value).dmg);
			foreach num,sk in iterateoptions {
				matcher aid = create_matcher("(skill |use |attack|jiggle)(?:(\\d+),?(\\d+)?)?",sk);
				if(find(aid)) {
					switch(aid.group(1)) {
						case "skill ":	vprint("WHAM: " + to_string(to_skill(to_int(excise(sk,"skill ","")))) + ": " + to_string(dmg_dealt(get_action(sk).dmg), "%.2f") + " potential damage (raw damage: " + spread_to_string(get_action(sk).dmg) + ") and a hitchance of " + to_string(hitchance(sk)*100, "%.2f") + "%.", (hitchance(sk) > hitchance ? "blue" : "red"), 3); break;
						case "use ":	vprint("WHAM: " + to_string(to_item(to_int(excise(sk,"use ","")))) + ": " + to_string(dmg_dealt(get_action(sk).dmg), "%.2f") + " potential damage (raw damage: " + spread_to_string(get_action(sk).dmg) + ") and a hitchance of " + to_string(hitchance(sk)*100, "%.2f") + "%.", (hitchance(sk) > hitchance && vars["WHAM_noitemsplease"] == "false" ? "blue" : "red"), 3); break;
						case "attack":	vprint("WHAM: Attack with your weapon: " + to_string(dmg_dealt(get_action(sk).dmg), "%.2f") + " potential damage (raw damage: " + spread_to_string(get_action(sk).dmg) + ") and a hitchance of " + to_string(hitchance(sk)*100, "%.2f") + "%.", (hitchance(sk) > hitchance ? "blue" : "red"), 3); break;
						case "jiggle":	vprint("WHAM: Jiggle your chefstaff: " + to_string(dmg_dealt(get_action(sk).dmg), "%.2f") + " potential damage (raw damage: " + spread_to_string(get_action(sk).dmg) + ") and a hitchance of " + to_string(hitchance(sk)*100, "%.2f") + "%.", (hitchance(sk) > hitchance ? "blue" : "red"), 3); break;
					}
				}
			}
			vprint("WHAM: You now have the knowledge needed to go forward and be victorious","purple",3);
			quit("Unable to figure out a combat strategy. Helpful information regarding your skills have been printed to the CLI");
		} else
			quit("WHAM: Unable to figure out a valid combat strategy. Try it yourself instead. If you set verbosity to 3 or more you will get a nice output of your available skills next time.");
	}
	return page;
}


string yz_consult_2(int round, string mob, string text)
{
  // replacement consult script to more fully take over combat control
  act(pg);
//  vprint_html("Profit per round: "+to_html(baseround()),5);
  // custom actions

  build_custom();
  switch (m) {    // add boss monster items here since BatMan is not being consulted
     case $monster[conjoined zmombie]: for i from 1 upto item_amount($item[half-rotten brain])
        custom[count(custom)] = get_action("use 2562"); break;
     case $monster[giant skeelton]: for i from 1 upto item_amount($item[rusty bonesaw])
        custom[count(custom)] = get_action("use 2563"); break;
     case $monster[huge ghuol]: for i from 1 upto item_amount($item[can of Ghuol-B-Gone&trade;])
        custom[count(custom)] = get_action("use 2565"); break;
  }

  if (count(queue) > 0 && queue[0].id == "pickpocket" && my_class() == $class[disco bandit]) try_custom();
   else enqueue_custom();

  // combos
  build_combos();
  if (($familiars[hobo monkey, gluttonous green ghost, slimeling] contains my_fam() && !happened("famspent")) || have_equipped($item[crown of thrones])) try_combos();
   else enqueue_combos();

  // stasis loop
  stasis();
  if (round < mdata.maxround && !is_our_huckleberry() && adj.stun < 1 && stun_action(false).stun > to_int(dmg_dealt(buytime.dmg) == 0) &&
      kill_rounds(smack) > 1 && min(buytime.stun-1, kill_rounds(smack)-1)*m_dpr(0,0)*meatperhp > buytime.profit) enqueue(buytime);

  macro();
  info("SmartStasis complete.");

  info("Starting evaluation and performing of attack");

//  page = Evaluate_Options();

  repeat
  {
    if(!(contains_text(page, "WINWINWIN") || page == "" || my_hp() == 0 || have_effect($effect[Beaten Up]) == 3))
      info("Current " + wrap(foe) + " HP: " + wrap(monster_stat("hp"), COLOR_MONSTER));

    consult_fight()

    int max_rounds = to_int(setting("max_combat_rounds"));
    if(round >= min(mdata.maxround, max_rounds) && !finished())
    {
      error("The fight has gone on longer than we expecte and we're not sure what to do next. Finish this fight then rereun yaaz to continue.");
      quit();
    }

  } until(finished() || die_rounds() <= 1 || round >= min(mdata.maxround, WHAM_maxround));

}
*/
string yz_consult(int round, string mob, string text)
{
  // do something like this if we want to consider stealing, but WHAM should take care of this for us generally.
  // We *should* defer to WHAM when we can steal even when we want to do something else though
  // (say, steal before digitize, when applicable). Maybe send to WHAM when we have the option to steal?
//  if(contains_text(text, "value=\"steal"))  return "try to steal an item";

  monster foe = to_monster(mob);

  string maybe = maybe_run(foe);
  if (maybe != "") return maybe;

  if (round == 1)
  {
    maybe = maybe_grab(foe);
    if (maybe != "") return maybe;
  }

  maybe = maybe_extract(foe);
  if (maybe != "") return maybe;

  maybe = maybe_banish(foe);
  if (maybe != "") return maybe;

  maybe = maybe_attract(foe);
  if (maybe != "")
  {
    info("Going to try to attract " + wrap(foe) + " with " + wrap(maybe, COLOR_MONSTER));
    return maybe;
  }

  maybe = maybe_duplicate(foe);
  if (maybe != "") return maybe;

  maybe = maybe_yellow_ray(foe);
  if (maybe != "") return maybe;

  maybe = maybe_shadow(foe);
  if (maybe != "") return maybe;

  maybe = maybe_portscan(foe);
  if (maybe != "") return maybe;

  maybe = maybe_lta_item(foe);
  if (maybe != "") return maybe;

  maybe = maybe_sharpen(foe);
  if (maybe != "") return maybe;

  maybe = maybe_latte(foe);
  if (maybe != "") return maybe;

  if (hippy_stone_broken())
  {
    if (have($item[Daily Affirmation: Keep Free Hate in your Heart]))
    {
      log("Throwing a " + wrap($item[Daily Affirmation: Keep Free Hate in your Heart]) + " for more PvP fun.");
      return "item Daily Affirmation: Keep Free Hate in your Heart";
    }
  }
  return "consult WHAM.ash";
}
