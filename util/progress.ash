
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

void progress(int qty, int total, string msg)
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
  string bar_style="background-color: green; width: " + percent + "%;";
  print_html("<div style='"+div_style+"'><div style='" + bar_style + "'>&nbsp;</div></div>&nbsp;" + footer);
}
