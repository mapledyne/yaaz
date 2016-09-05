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

boolean war_arena()
{
  return to_boolean(setting("war_arena", "true"));
}
