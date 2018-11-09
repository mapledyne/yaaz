import "util/yz_main.ash";
import "util/base/yz_bounty.ash";

void M_bounty_cleanup()
{

}

void M_bounty_progress()
{

  foreach hardness in $strings[currentSpecialBountyItem,
                               currentHardBountyItem,
                               currentEasyBountyItem]
  {
    string bounty_prop = get_property(hardness);
    if (bounty_prop == "") continue;
    string[2] bounty_split = split_string(bounty_prop,":");
    bounty bounty_item = to_bounty(bounty_split[0]);
    int bounty_count = to_int(bounty_split[1]);

    progress(bounty_count, bounty_item.number, wrap(bounty_item) + " collected for the " + wrap("Bounty Hunter", COLOR_MONSTER));

  }
}

void pick_bounty()
{
  // if we have a bounty already, don't get another one.
  foreach hardness in $strings[currentSpecialBountyItem,
                               currentHardBountyItem,
                               currentEasyBountyItem]
  {
    string bounty_prop = get_property(hardness);
    if (bounty_prop != "") return;
  }


  foreach hardness in $strings[Hard,
                               Easy]
  {
    string prop = "_untaken" + hardness + "BountyItem";
    bounty b = to_bounty(get_property(prop));
    if (b == $bounty[none]) continue;
    location l = b.location;

    if (!location_open(l)) continue;
    string bounty_string = wrap(b.number, COLOR_ITEM) + " " + wrap(b) + " from " + wrap(b.location);
    log("Accepting the " + wrap(hardness, COLOR_ITEM) + " bounty: " + bounty_string);
    cli_execute("bounty " + to_lower_case(hardness));
    return;
  }
}

boolean M_bounty()
{

  string flag = to_lower_case(setting("do_bounty", "false"));

  // never to anything with the bounty:
  if (flag == "never") return false;

  if (flag == "aftercore")
  {
    if (quest_status("questL13Final") == FINISHED)
    {
      flag = "aggressive";
    } else {
      flag = "false";
    }
  }

  update_bounties();

  // Only opportunistically try the bounty. Won't get many this way, but now and then.
  // Don't take any extra turns, though:
  if (flag == "false") return false;


  if (flag != "aggressive" && flag != "true")
  {
    warning("I don't understand what your preference is regarding the bounty.");
    warning("You've chosen '" + wrap(flag, COLOR_ITEM) + "', but the options are 'never, false, true, aggressive, aftercore'.");
    warning("Setting this to the default ('false'). If you'd like this to be anything else, hit " + wrap('ESC', COLOR_ITEM) + " now and change it.");
    warning("For example: " + wrap('set yz_do_bounty=false', 'black'));
    wait(10);
    save_setting("do_bounty", "false");
    return true;
  }

  if (flag == "aggressive") pick_bounty();

  location hunt = $location[none];

  foreach hardness in $strings[currentSpecialBountyItem,
                               currentHardBountyItem,
                               currentEasyBountyItem]
  {
    location l = to_bounty(get_property(hardness)).location;

    if (l == $location[none]) continue;
    if (dangerous(l)) continue;
    if (!location_open(l)) continue;

    hunt = l;
    break;
  }

  if (hunt == $location[none]) return false;
  yz_adventure(hunt, "");
  return true;
}

void main()
{
  while (M_bounty());
}
