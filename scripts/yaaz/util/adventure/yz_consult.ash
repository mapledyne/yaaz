import "util/base/yz_inventory.ash";
import "util/base/yz_monsters.ash";
import "special/locations/yz_terminal.ash";
import "util/base/yz_monsters.ash";
import "util/base/yz_war_support.ash";
import "util/base/yz_quests.ash";

//import <SmartStasis.ash>;

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
  else if (have_skill($skill[snokebomb]) && my_mp() > mp_cost($skill[snokebomb]) && get_property("_snokebombUsed") < 3  )
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

string maybe_steal(monster foe, string page)
{
  if (!contains_text(page, "type=submit value=\"Pick")) return "";

  if ($monsters[] contains foe) return "";
  return "try to steal an item";
}

string yz_consult(int round, string mob, string text)
{

  monster foe = to_monster(mob);

  string maybe = maybe_run(foe);
  if (maybe != "") return maybe;

  maybe = maybe_steal(foe, text);
  if (maybe != "")
  {
    log("Going to try to " + wrap("pickpocket", COLOR_SKILL));
    return maybe;
  }

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

  debug("Handing off to your default CCS script to decide what to do.");
  return get_ccs_action(round);
}
