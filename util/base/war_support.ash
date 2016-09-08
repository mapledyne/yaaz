import "util/base/settings.ash";

string war_side()
{
  string side = setting("war_side", "fratboy");
  if (side == "fratboy" || side == "hippy")
    return side;
  abort("War side setting (" + SETTING_PREFIX + "_war_side) is not valid. It's currently set to '" + side + "', but must be either 'hippy' or 'fratboy'.");
  return "";
}

string war_outfit()
{
  if (war_side() == 'hippy')
    return 'War Hippy Fatigues';
  return 'Frat Warrior Fatigues';
}

boolean war_junkyard()
{
  return to_boolean(setting("war_junkyard", "true"));
}

boolean war_orchard()
{
  return to_boolean(setting("war_orchard", "true"));
}

boolean war_arena()
{
  return to_boolean(setting("war_arena", "true"));
}

boolean war_lighthouse()
{
  return to_boolean(setting("war_lighthouse", "true"));
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
