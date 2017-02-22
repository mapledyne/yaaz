string setting(string value, string def);
string setting(string value);
string save_setting(string key, string value);
string save_daily_setting(string key, string value);

string SETTING_PREFIX = "yz";

string setting(string value, string def)
{
  // daily values override permanent ones:
  string key = SETTING_PREFIX + "_" + value;
  key = replace_string(key, " ", "_");

  string prop = get_property("_" + key);
  if (prop != "")
    return prop;

  prop = get_property(key);
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
  string prop = SETTING_PREFIX + "_" + key;
  prop = replace_string(prop, " ", "_");
  set_property(prop, value);
  return value;
}

string save_daily_setting(string key, string value)
{
  string prop = "_" + SETTING_PREFIX + "_" + key;
  prop = replace_string(prop, " ", "_");
  set_property(prop, value);
  return value;
}
