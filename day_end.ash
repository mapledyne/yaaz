import "util/main.ash";

void check_item(slot s)
{
  item i = equipped_item(s);
  float mod = numeric_modifier(i, "Adventures") + numeric_modifier(i, "PvP Fights");

  if (i == $item[your cowboy boots])
  {
    if (equipped_item($slot[bootspur]) == $item[ticksilver spurs])
    {
      mod = mod + 5;
    }
  }

  if (mod == 0)
  {
    equip(s, $item[none]);
  }
}

void main()
{
  prep($location[none]);
  build_requirements();

  if (!drunk())
  {
    witchess();
    snojo();
  }

  // if there are any source terminal enhances left
  consume_enhances();

  pvp();

  log("Dressing for rollover.");
  maximize("rollover");
  log("Taking off anything not needed for rollover (helpful for PvP)");
  check_item($slot[hat]);
  check_item($slot[weapon]);
  check_item($slot[off-hand]);
  check_item($slot[back]);
  check_item($slot[shirt]);
  check_item($slot[pants]);
  check_item($slot[acc1]);
  check_item($slot[acc2]);
  check_item($slot[acc3]);

  if (get_property("_detectiveCasesCompleted").to_int() < 3)
  {
    warning("You have detective cases you can complete at the precinct.");
    warning("This isn't automated by this script.");
  }
}
