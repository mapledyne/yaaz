import "util/base/settings.ash";

int war_defeated();

string war_side()
{
  string side = setting("war_side", "fratboy");
  if (side == "fratboy" || side == "hippy")
    return side;
  abort("War side setting (" + SETTING_PREFIX + "_war_side) is not valid. It's currently set to '" + side + "', but must be either 'hippy' or 'fratboy'.");
  return "";
}

string war_outfit(string side)
{
  if (side == 'hippy')
    return 'War Hippy Fatigues';
  return 'Frat Warrior Fatigues';
}

string war_outfit()
{
  return war_outfit(war_side());
}

boolean war_orchard_accessible()
{
  if (war_side() == 'hippy')
    return true;
  return war_defeated() >= 64;
}

boolean war_nuns_accessible()
{
  if (war_side() == 'hippy')
    return true;
  return war_defeated() >= 192;
}

boolean war_arena_accessible()
{
  if (war_side() == 'fratboy')
    return true;
  return war_defeated() >= 458;
}

boolean war_junkyard_accessible()
{
  if (war_side() == 'fratboy')
    return true;
  return war_defeated() >= 192;
}

boolean war_lighthouse_accessible()
{
  if (war_side() == 'fratboy')
    return true;
  return war_defeated() >= 64;
}

boolean war_nuns_trick()
{

  if (war_side() != "fratboy") return false; // no need
  if (!to_boolean(setting("war_nuns_trick", false))) return false; // setting not enabled.

  if (!have_outfit("war hippy fatigues")) return false;

/*
  if (!educated("digitize.edu"))
  {
    warning("You've said you want to do the Nuns Trick, but you can't digitize foes.");
    warning("There may be other ways to do this, but I don't know them.");
    abort("Do the Nuns manually, change the setting (yz_war_nuns_trick), or get a Source Terminal.");
  }
*/
  return true;
}


boolean war_junkyard()
{
  if (my_path() == "Bees Hate You")
    return false;
  return to_boolean(setting("war_junkyard", "true"));
}

boolean war_orchard()
{
  return to_boolean(setting("war_orchard", "true"));
}

boolean war_arena()
{
if (my_path() == "Bees Hate You")
  return false;
  return to_boolean(setting("war_arena", "true"));
}

boolean war_lighthouse()
{
  return to_boolean(setting("war_lighthouse", "true"));
}

boolean war_nuns()
{
  return to_boolean(setting("war_nuns", "false"));
}

int war_defeated()
{
  string prop = "hippiesDefeated";
  if (setting("war_side") == "hippy")
    prop = "fratboysDefeated";
  return (get_property(prop).to_int());
}

int war_multiplier()
{
  int mult = 1;
  if (get_property("sidequestArenaCompleted") == war_side())
    mult = mult * 2;
  if (get_property("sidequestOrchardCompleted") == war_side())
    mult = mult * 2;
  if (get_property("sidequestNunsCompleted") == war_side())
    mult = mult * 2;
  if (get_property("sidequestLighthouseCompleted") == war_side())
    mult = mult * 2;
  if (get_property("sidequestJunkyardCompleted") == war_side())
    mult = mult * 2;
  if (get_property("sidequestFarmCompleted") == war_side())
    mult = mult * 2;

  return mult;
}
