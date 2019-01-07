import "util/base/yz_print.ash";

void pantogram_progress() {
  if (!can_daily_kgb()) return;
}

string pant_alignment()
{
  switch(my_primestat())
  {
    case $stat[Muscle]:
      return "1";
    case $stat[Mysticality]:
      return "2";
    case $stat[Moxie]:
      return "3";

  }
  return "3";
}

string pant_element(element el)
{
  switch(el)
  {
    case $element[hot]:
      return "1";
    case $element[cold]:
      return "2";
    case $element[spooky]:
      return "3";
    case $element[sleaze]:
      return "4";
    case $element[stench]:
      return "5";
  }

  return "3";
}

string pant_element()
{
  // maybe make this smarter?
  return pant_element($element[spooky]);
}

string pant_sacrifice1()
{
  return "-1,0";
}

string pant_sacrifice2()
{
  if (my_primestat() == $stat[mysticality]) return "-2,0";

  return "-1,0";
}

string pant_sacrifice3()
{
  return "-1,0";
}

void make_pantogram()
{
  string url = "choice.php?whichchoice=1270&option=1&pwd";
  url += "&m=" + pant_alignment();
  url += "&e=" + pant_element();
  url += "&s1=" + url_encode(pant_sacrifice1());
  url += "&s2=" + url_encode(pant_sacrifice2());
  url += "&s3=" + url_encode(pant_sacrifice3());

  log("Off to make some pants with the " + wrap($item[portable pantogram]) + ".");
  visit_url("inv_use.php?pwd&which=3&whichitem=9573");
  visit_url(url);
}

void pantogram()
{
  if (!have($item[portable pantogram])) return;
  if (!be_good($item[portable pantogram])) return;
  if (get_property("_pantogramModifier") != "") return;

  make_pantogram();
}

void main() {
  pantogram();
}
