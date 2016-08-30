import "util/base/util.ash";

string pref_line(string pref, string def, string comment)
{
  return "<tr><td>dg_" + pref + "</td><td>" + setting(pref, def) + "</td><td>" + comment + "</td></tr></table>";
}


print_html("Options with <b>dg_ascend</b> can be set by changing various settings.");
print("Set an option by changing the variable like the following in the gCLI:");
print("");
print("set dg_war_side=hippy");
print("");
print("Settings:");
string table = "<table border=2 width=500px><tr><th>Option</th><th>Current</th><th>Notes</th></tr>";

table += pref_line("war_side", "fratboy", "Fight Island War as fratboy or hipppy.");
table += pref_line("do_heart", "true", "Do heart-y thing like using up your Smile of Mr. Accessory. Set to false to not be a heart while playing.");
table += pref_line("do_collectors", "true", "Give things to certain well-known collectors, particularly devs of KoLMafia. Set to false to not give to these collectors.");

table += "</table>";
print_html(table);
