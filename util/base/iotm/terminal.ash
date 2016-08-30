import "util/print.ash";
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

void terminal_enhance(effect ef)
{
  string enh = to_enhancement(ef);
  if (enh == "")
    return;

  if (have_effect(ef) > 0)
    return;

  if (!have_enhancement(enh))
    return;

  if (!can_enhance())
    return;

  log("Using " + wrap($item[Source Terminal]) + " to enhance " + wrap(ef) + ".");
  cli_execute("terminal enhance " + enh);

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
  return $effect[none];
}

void consume_enhances()
{
  while (can_enhance())
  {
    effect enh = pick_one_enhancement();
    if (enh == $effect[none])
    {
      log("We're using up your " + wrap($item[source terminal]) + " enhances, but you seem to have all of them running that you can.");
      log("Loading up more " + wrap($effect[items.enh]) + " as a default. Maybe this could be smarter?");
      wait(3);
      enh = $effect[items.enh];
    }
    terminal_enhance(enh);
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

item terminal_extrude(item it)
{
  if (!can_extrude())
    return $item[none];

  item gibson = $item[hacked gibson];
  item cookie = $item[browser cookie];

  switch (it)
  {
    case gibson:
      int b = item_amount(gibson);
      cli_execute("terminal extrude booze");
      if (b < item_amount(gibson))
      {
        return gibson;
      }
      else
      {
        warning("Tried to extrude a " + wrap(gibson) + ", but it didn't seem to work.");
        return $item[none];
      }
    case cookie:
      int c = item_amount(cookie);
      cli_execute("terminal extrude food");
      if (c < item_amount(cookie))
      {
        return cookie;
      }
      else
      {
        warning("Tried to extrude a " + wrap(cookie) + ", but it didn't seem to work.");
        return $item[none];
      }

    default:
      error("I don't know how to extrude " + wrap(it) + ".");
      return $item[none];
  }
}

item terminal_extrude(string s)
{
  switch(s)
  {
    case "booze":
      return terminal_extrude($item[hacked gibson]);
    case "food":
      return terminal_extrude($item[browser cookie]);

    default:
      error("Trying to extrude '" + s + "' but I don't know what that is.");
      return $item[none];
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

void terminal()
{
  if (!can_terminal())
    return;

  log("Checking the " + $item[Source Terminal] + ".");

  while(can_extrude() && item_amount($item[source essence]) > 10)
  {
    if (my_path() == "Nuclear Autumn")
    {
      warning("You can extrude things from the terminal, but I don't know what's good to do in this path.");
      warning("Skipping, but you have " +  extrudes_remaining() + " extrude(s) remaining and " + item_amount($item[source essence]) + " source essence.");
      break;
    }
    if (item_amount($item[hacked gibson]) > 2)
    {
      if (item_amount($item[browser cookie]) > 2)
      {
        warning("You seem flush in extruded food/booze. Not extruding anything else since it's not clear what to get. Extrude something!");
        warning("You have " + extrudes_remaining() + " extrude(s) remaining and " + item_amount($item[source essence]) + " source essence.");
        break;
      } else {
        terminal_extrude("food");
      }
    } else {
      terminal_extrude("booze");
    }
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
