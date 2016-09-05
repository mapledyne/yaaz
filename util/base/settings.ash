string setting(string value, string def);
string setting(string value);
string save_setting(string key, string value);
string save_daily_setting(string key, string value);

string SETTING_PREFIX = "yz";

string setting(string value, string def)
{
  // daily values override permanent ones:
  string prop = get_property("_" + SETTING_PREFIX + "_" + value);
  if (prop != "")
    return prop;

  prop = get_property(SETTING_PREFIX + "_" + value);
  if (prop != "")
    return prop;

  return def;
}

string setting(string value)
{
  return setting(value, "");
}

string save_setting(string key, string value)
{
  set_property(SETTING_PREFIX + "_" + key, value);
  return value;
}

string save_daily_setting(string key, string value)
{
  set_property("_" + SETTING_PREFIX + "_" + key, value);
  return value;
}
