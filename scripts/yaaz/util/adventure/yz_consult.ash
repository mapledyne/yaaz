import "util/base/yz_inventory.ash";
import "util/base/yz_monsters.ash";
import "special/locations/yz_terminal.ash";
import "util/base/yz_monsters.ash";
import "util/base/yz_war_support.ash";
import "util/base/yz_quests.ash";

string maybe_copy(monster foe)
{
  monster digitized = to_monster(get_property("_sourceTerminalDigitizeMonster"));
  int copiesmade = to_int(get_property("_sourceTerminalDigitizeMonsterCount"));

  if (digitized == foe && copiesmade <= 2) return "";
  if (to_monster(get_property("enamorangMonster")) == foe) return "";

  boolean pref_digitize = false;
  boolean can_digitize = false;
  string action = "";

  if (have_skill($skill[digitize])
      && digitize_remaining() > 0)
  {
    can_digitize = true;
    action = "skill digitize";
  }

  if (have($item[LOV Enamorang])
      && get_property("enamorangMonster") == "")
  {
    action = "item LOV enamorang";
  }

  if (action == "") return "";

  monster newyoumon = to_monster(get_property("_newYouQuestMonster"));

  if (newyoumon == foe
      && newyoumon != $monster[none] &&
      !to_boolean("_newYouQuestCompleted"))
  {
    return action;
  }

  switch (foe)
  {
    default:
      return "";
    case $monster[dirty thieving brigand]:
      if (to_int(get_property("currentNunneryMeat")) < (100000 - max_expected_nuns_meat() * 4)
          || !war_nuns_trick())
      {
        return "";
      }
      break;
    case $monster[ninja snowman assassin]:
      pref_digitize = true;
      break;
    case $monster[writing desk]:
    case $monster[lobsterfrogman]:
      int thingwanted = item_amount($item[barrel of gunpowder]);
      if (foe == $monster[writing desk])
      {
        thingwanted = to_int(get_property("writingDesksDefeated"));
      }

      // we want 5, but if we have 4 already then defeating one more will give us 5,
      // so only looking for 3 or less of the things we want.
      if (thingwanted >= 4) return "";
      if (thingwanted < 3) pref_digitize = true;
      break;
  }

  if (pref_digitize && can_digitize) action = "skill digitize";

  return action;
}

string maybe_duplicate(monster foe)
{
  if (!have_skill($skill[duplicate])) return "";
  int dupes = to_int(get_property("_sourceTerminalDuplicateUses"));
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
  else if (have($item[tennis ball]))
  {
    banish = "item tennis ball";
  }

  if (banish == "") return "";

  switch (foe)
  {
    default:
      return "";
    case $monster[A.M.C. Gremlin]:
      break;
  }
  log("Trying to banish the " + wrap(foe) + ".");
  return banish;
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

string maybe_sniff(monster foe)
{
  if (!have_skill($skill[Transcendent Olfaction])) return "";
  if (have_effect($effect[on the trail]) > 0) return "";

  switch (foe)
  {
    default:
      if (is_bounty_monster(foe)) break;
      return "";
    case $monster[blooper]:
      if (have($item[digital key])) return "";
      break;
    case $monster[knob goblin harem girl]:
      if (have_outfit("Knob Goblin Harem Girl Disguise")) return "";
      break;
    case $monster[dirty old lihc]:
      break;
    case $monster[dairy goat]:
      if (item_amount($item[goat cheese]) > 2) return "";
      break;
    case $monster[racecar bob]:
    case $monster[bob racecar]:
    case $monster[drab bard]:
      if (to_int(get_property("palindomeDudesDefeated")) >= 5) return "";
      break;
    case $monster[tomb rat]:
      if (quest_status("questL11Pyramid") > 3) return "";
      if (turners() >= 10) return "";
      break;
    case $monster[bearpig topiary animal]:
    case $monster[elephant (meatcar?) topiary animal]:
    case $monster[spider (duck?) topiary animal]:
      if (to_int(get_property("twinPeakProgress")) == 15) return "";
        break;
  }

  return "skill Transcendent Olfaction";
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
  if (to_boolean(get_property("_newYouQuestCompleted"))) return "";

  int last_sharp = to_int(setting("newyou_last_sharp", "0"));
  if (last_sharp == turns_played()) return "";

  save_daily_setting("newyou_last_sharp", turns_played());
  return "skill " + get_property("_newYouQuestSkill");
}

string yz_consult(int round, string mob, string text)
{
  // do something like this if we want to consider stealing, but WHAM should take care of this for us generally.
  // We *should* defer to WHAM when we can steal even when we want to do something else though
  // (say, steal before digitize, when applicable). Maybe send to WHAM when we have the option to steal?
//  if(contains_text(text, "value=\"steal"))  return "try to steal an item";

  monster foe = to_monster(mob);

  string maybe = maybe_run(foe);
  if (maybe != "") return maybe;

  maybe = maybe_sniff(foe);
  if (maybe != "") return maybe;

  maybe = maybe_extract(foe);
  if (maybe != "") return maybe;

  maybe = maybe_banish(foe);
  if (maybe != "") return maybe;

  maybe = maybe_copy(foe);
  if (maybe != "") return maybe;

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

  return "consult WHAM.ash";
}
