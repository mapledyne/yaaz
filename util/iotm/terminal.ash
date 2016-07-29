import "util/print.ash";
import "util/maximize.ash";

boolean can_extrude();
int extrudes_remaining();
boolean can_terminal();
item terminal_extrude(item it);
item terminal_extrude(string s);
string terminal_enquiry(string enq);
string terminal_enquiry();
void terminal();
void main();

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

  while(can_extrude() && i_a($item[source essence]) > 10)
  {
    if (i_a($item[hacked gibson]) > 2)
    {
      if (i_a($item[browser cookie]) > 2)
      {
        warning("You seem flush in extruded food/booze. Not extruding anything else since it's not clear what to get. Extrude something!");
        warning("You have " + extrudes_remaining() + " extrudes remaining.");
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
    terminal_enquiry("stats");
  }

}

void main()
{
  terminal();
}
