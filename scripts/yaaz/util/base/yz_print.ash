import "util/base/yz_settings.ash";

string COLOR_ITEM = "green";
string COLOR_LOCATION = "blue";
string COLOR_EFFECT = "blue";
string COLOR_MONSTER = "blue";
string COLOR_SKILL = "green";
string COLOR_CLASS = "green";
string COLOR_COINMASTER = "blue";
string COLOR_STAT = "green";

string COLOR_ERROR = "red";
string COLOR_WARNING = "purple";
string COLOR_LOG = "#CD853F";
string COLOR_ADVICE = "purple";
string COLOR_TASK = "black";
string COLOR_INFO = COLOR_LOG;
string COLOR_DEBUG = COLOR_LOG;

string CLUB = "♣";
string HEART = "♥";

// Unicode has some nice choices, but they render irregularly in the gCLI:
string CHECKED = "[X]";
string UNCHECKED = "[ ]";

string pluralize(int count, item it)
{
  if (count == 1)
    return it.name;
  return to_plural(it);
}

string add_link(string target, string name)
{
  string target_encoded = replace_string(replace_string(target, " ", "_"), "'", "%27");
  return "<a href='http://kol.coldfront.net/thekolwiki/index.php/" + target_encoded + "'>" + name + "</a>";
}

string add_link(string target)
{
  return add_link(target, target);
}

string wrap(string i, string color)
{
	return ("<font color='" + color + "'>" + i + "</font>");
}

string wrap(item i)
{
	return wrap(add_link(i.name), COLOR_ITEM);
}

string wrap(item i, int qty)
{
  return wrap(add_link(i.name, pluralize(qty, i)), COLOR_ITEM);
}

string wrap(bounty b)
{
  return wrap(b, COLOR_ITEM);
}

string wrap(familiar f)
{
	return wrap(add_link(f), COLOR_ITEM);
}

string wrap(thrall t)
{
	return wrap(add_link(t), COLOR_ITEM);
}

string wrap(monster m)
{
  return wrap(add_link(m), COLOR_MONSTER);
}

string wrap(stat s)
{
  return wrap(s, COLOR_STAT);
}

string wrap(skill s)
{
  return wrap(add_link(s), COLOR_SKILL);
}

string wrap(slot s)
{
  return wrap(s, COLOR_STAT);
}

string wrap(class c)
{
  return wrap(c, COLOR_CLASS);
}

string wrap(location l)
{
	return wrap(add_link(l), COLOR_LOCATION);
}

string wrap(effect e)
{
  return wrap(add_link(e), COLOR_EFFECT);
}

string wrap(coinmaster c)
{
  return wrap(c, COLOR_COINMASTER);
}

void yz_print(string msg, string color)
{
  print_html("<font color='" + color + "'>" + msg + "</font>");
}

void log(string msg)
{
	yz_print(msg, COLOR_LOG);
}

void log_adv(int turns, string msg)
{
  string adv = "adventures";
  if (turns == 1)
    adv = "adventure";
  log("It took " + turns + " " + adv + " " + msg);
}

void error(string msg)
{
  yz_print(msg, COLOR_ERROR);
}

void warning(string msg)
{
  yz_print(msg, COLOR_WARNING);
}

void advice(string msg)
{
  yz_print(msg, COLOR_ADVICE);
}

void task(string msg)
{
  yz_print(UNCHECKED + " " + msg, COLOR_TASK);
}

void info(string msg)
{
  string level = setting("log_level", "");
  if (level == 'info' || level == 'debug')
    yz_print(wrap("[INFO] ", COLOR_WARNING) + msg, COLOR_INFO);
}

void debug(string msg)
{
  string level = setting("log_level", "");
  if (level == 'debug')
    yz_print(wrap('[DEBUG] ', COLOR_WARNING) + msg, COLOR_DEBUG);
}

void progress(int percent);
void progress(int percent, string msg);
void progress(int qty, int total);
void progress(int qty, int total, string msg);

void progress(int percent)
{
  progress(percent, 100);
}

void progress(int qty, int total)
{
  progress(qty, total, "");
}

void progress(int percent, string msg)
{
  progress(percent, 100, msg);
}

void progress(int qty, int total, string msg, string color)
{
  if (qty > total)
    qty = total;

  int percent = ((to_float(qty) / to_float(total)) * 100.0);

  string footer;
  if (total == 100)
  {
    footer = "&nbsp;" + qty + "%";
  } else {
    footer = "&nbsp;" + qty + "/" + total;
  }
  if (msg != "")
  {
    footer += "&nbsp;" + msg;
  }

  string div_style="border: 1px solid black; background-color: silver; width: 200px; position: relative; padding: 3px";
  string bar_style="background-color: " + color + "; width: " + percent + "%;";
  print_html("<div style='"+div_style+"'><div style='" + bar_style + "'>&nbsp;</div></div>&nbsp;" + footer);

}

void progress(int qty, int total, string msg)
{
  progress(qty, total, msg, "green");
}

string comma_format(int i)
{
  if ( i < 1000 )
  return "" + i;

  int mod = 0;

  string piece = "";
  string result = "";

  while ( i >= 1000 )
  {
  mod = i % 1000;

  if ( mod < 10 )
  piece = "00" + mod;
  else if ( mod < 100 )
  piece = "0" + mod;
  else
  piece = "" + mod;

  if ( result == "" )
  result = piece;
  else
  result = piece + "," + result;

  i = i - (i % 1000);
  i = i / 1000;
  }

  if ( i != 0 )
  result = i + "," + result;

  return result;
}
