import "util/base/print.ash";
import <zlib.ash>;

boolean can_extrude();
int extrudes_remaining();
boolean can_terminal();
item terminal_extrude(item it);
item terminal_extrude(string s);
string terminal_enquiry(string enq);
string terminal_enquiry();
void terminal_enhance(effect ef);
string to_enhancement(effect ef);
boolean have_enhancement(string enh);
boolean can_enhance();
int enhances_remaining();
boolean have_educate(string edu);
void terminal_educate(string edu1, string edu2);
void terminal_educate(string edu);
void terminal_educate();
void terminal();
void main();

boolean have_educate(string edu)
{
  return list_contains(get_property("sourceTerminalEducateKnown"), edu, ",");
}

boolean educated(string edu)
{
  if (get_property("sourceTerminalEducate1") == edu)
    return true;
  if (get_property("sourceTerminalEducate2") == edu)
    return true;
  return false;


}

void terminal_educate(string edu1, string edu2)
{
  if (!can_terminal())
    return;

  if (educated(edu1))
  {
    if (!list_contains(get_property("sourceTerminalChips"), "DRAM", ","))
      return;
    if (educated(edu2))
      return;
  }

  if (have_educate(edu1))
  {
    log("Adding " + wrap($item[source terminal]) + " education: " + wrap(edu1, COLOR_ITEM) + ".");
    cli_execute("terminal educate " + edu1);
  }
  if (have_educate(edu2) && (list_contains(get_property("sourceTerminalChips"), "DRAM", ",")))
  {
    log("Adding " + wrap($item[source terminal]) + " education: " + wrap(edu2, COLOR_ITEM) + ".");
    cli_execute("terminal educate " + edu2);
  }
}

void terminal_educate(string edu)
{
  terminal_educate(edu, "extract.edu");
}

void terminal_educate()
{
  terminal_educate("extract.edu", "digitize.edu");
}

void terminal_enhance(effect ef, boolean force)
{
  string enh = to_enhancement(ef);
  if (enh == "")
    return;

  if (have_effect(ef) > 0 && !force)
    return;

  if (!have_enhancement(enh))
    return;

  if (!can_enhance())
    return;

  log("Using " + wrap($item[Source Terminal]) + " to enhance " + wrap(ef) + ".");
  cli_execute("terminal enhance " + enh);

}

void terminal_enhance(effect ef)
{
  terminal_enhance(ef, false);
}

boolean have_enhancement(string enh)
{
  return list_contains(get_property("sourceTerminalEnhanceKnown"), enh, ",");
}

string to_enhancement(effect ef)
{
  if (contains_text(to_string(ef), ".enh"))
  {
    return to_string(ef);
  }

  warning("Unsure how to turn " + wrap(ef) + " into a Terminal enhancement.");
  return "";
}

boolean consider_one_enhancement(effect ef)
{
  string ef_s = to_enhancement(ef);
  if (have_effect(ef) > 0)
    return false;
  if (!have_enhancement(ef_s))
    return false;
  return true;
}

effect pick_one_enhancement()
{
  if (consider_one_enhancement($effect[items.enh]))
    return $effect[items.enh];
  if (consider_one_enhancement($effect[substats.enh]))
    return $effect[substats.enh];
  if (consider_one_enhancement($effect[init.enh]))
    return $effect[init.enh];
  if (my_meat() < 20000)
  {
    if (consider_one_enhancement($effect[meat.enh]))
      return $effect[meat.enh];
  }
  if (consider_one_enhancement($effect[damage.enh]))
    return $effect[damage.enh];
  if (consider_one_enhancement($effect[critical.enh]))
    return $effect[critical.enh];

  // we have all the effects we need, so see what we have the fewest of and up that one.
  // no sense in letting them go to waste.
  effect[int] enhs;
  int count = 0;
  foreach e in $effects[items.enh, substats.enh, meat.enh, init.enh, damage.enh, critical.enh]
  {
    if (have_enhancement(e))
    {
      enhs[count] = e;
      count += 1;
    }
  }
  sort enhs by have_effect(value);

  if (count == 0)
    return $effect[none];

  return enhs[0];
}

void consume_enhances()
{
  while (can_enhance())
  {
    effect enh = pick_one_enhancement();
    if (enh == $effect[none])
    {
        warning("Tried to find a good enhancement from the Terminal, but I couldn't.") ;
        warning("You should use these up - it'd be a shame to let them go to waste.");
        wait(5);
        return;
    }
    terminal_enhance(enh, true);
    // mafia doesn't seem to pick up new enhancements, so...
    refresh_status();
  }
}

boolean can_enhance()
{
  if (get_campground() contains $item[Source Terminal])
  {
    return (enhances_remaining() > 0);
  }
  return false;
}

int enhances_remaining()
{
  int max = 1;
  if (list_contains(get_property("sourceTerminalChips"), "SCRAM", ","))
    max += 1;
  if (list_contains(get_property("sourceTerminalChips"), "CRAM", ","))
    max += 1;

  return max - to_int(get_property("_sourceTerminalEnhanceUses"));
}

boolean can_extrude()
{
  return extrudes_remaining() > 0;
}

int extrudes_remaining()
{
  int uses = get_property("_sourceTerminalExtrudes").to_int();
  return 3 - uses;
}

boolean can_terminal()
{
  return get_campground() contains $item[source terminal];
}

boolean terminal_extrude(item it)
{
  if (!can_extrude())
    return false;


  switch (it)
  {
    case $item[hacked gibson]:
      return cli_execute("terminal extrude booze");
    case $item[browser cookie]:
      return cli_execute("terminal extrude food");
    case $item[Source terminal GRAM chip]:
      return cli_execute("terminal extrude gram");
    case $item[Source terminal PRAM chip]:
      return cli_execute("terminal extrude pram");
    case $item[Source terminal SPAM chip]:
      return cli_execute("terminal extrude spam");
    case $item[Source terminal CRAM chip]:
      return cli_execute("terminal extrude cram");
    case $item[Source terminal DRAM chip]:
      return cli_execute("terminal extrude dram");
    case $item[Source terminal TRAM chip]:
      return cli_execute("terminal extrude tram");
    case $item[source shades]:
      return cli_execute("terminal extrude gogles");
    case $item[software bug]:
      return cli_execute("terminal extrude familiar");
    default:
      error("I don't know how to extrude " + wrap(it) + ".");
      return false;
  }
}

string terminal_enquiry(string enq)
{
  if (enq == "")
  {
    return get_property("sourceTerminalEnquiry");
  }

  cli_execute("terminal enquiry " + enq);

  return get_property("sourceTerminalEnquiry");
}

string terminal_enquiry()
{
  return terminal_enquiry("");
}

boolean have_terminal_file(string f)
{
  if (list_contains(get_property("sourceTerminalEducateKnown"), f, ","))
    return true;
  if (list_contains(get_property("sourceTerminalEnhanceKnown"), f, ","))
    return true;
  if (list_contains(get_property("sourceTerminalEnquiryKnown"), f, ","))
    return true;
  if (list_contains(get_property("sourceTerminalExtrudeKnown"), f, ","))
    return true;
  return false;
}

boolean have_terminal_chip(string chip)
{
  if (list_contains(get_property("sourceTerminalChips"), chip, ","))
    return true;
  return false;
}

void terminal()
{
  if (!can_terminal())
    return;

  while(can_extrude() && item_amount($item[source essence]) > 10)
  {

    item ext = $item[hacked gibson];
    if (item_amount($item[hacked gibson]) > item_amount($item[browser cookie]))
    {
      ext = $item[browser cookie];
    }

    if (item_amount(ext) >= 5)
    {
    // if we have plenty of food/booze, maybe consider getting something else:
      if (!have_terminal_chip("CRAM") && item_amount($item[source essence]) > 1000 && have_terminal_file("cram.ext"))
      {
        ext = $item[Source terminal CRAM chip];
      }
      else if (!have_terminal_chip("DRAM") && item_amount($item[source essence]) > 1000 && have_terminal_file("dram.ext"))
      {
        ext = $item[Source terminal DRAM chip];
      }
      else if (!have_terminal_chip("TRAM") && item_amount($item[source essence]) > 1000 && have_terminal_file("tram.ext"))
      {
        ext = $item[Source terminal TRAM chip];
      }
      else if (to_int(get_property("sourceTerminalGram")) <  10 && item_amount($item[source essence]) > 100 && have_terminal_file("gram.ext"))
      {
        ext = $item[Source terminal GRAM chip];
      }
      else if (to_int(get_property("sourceTerminalPram")) <  10 && item_amount($item[source essence]) > 100 && have_terminal_file("pram.ext"))
      {
        ext = $item[Source terminal PRAM chip];
      }
      else if (to_int(get_property("sourceTerminalSpam")) <  10 && item_amount($item[source essence]) > 100 && have_terminal_file("spam.ext"))
      {
        ext = $item[Source terminal SPAM chip];
      }
    }

    if (i_a($item[source shades]) == 0 && item_amount($item[source essence]) > 100)
      ext = $item[source shades];

    if (my_path() == "Nuclear Autumn" && ext == $item[hacked gibson] || ext == $item[browser cookie])
    {
      warning("You can't use the food and booze from the Terminal in Nuclear Autumn, but it's not obvious what else to extrude.");
      wait(3);
    }

    terminal_extrude(ext);
  }

  if (terminal_enquiry() == "")
  {
    log("Setting your " + wrap($item[Source Terminal]) + " enquiry to 'stats'. Be sure to change if you want it to be something else.");
    wait(10);
    terminal_enquiry("stats");
  }

  terminal_educate();

}

void main()
{
  terminal();
}
