import "util/yz_main.ash";
import "util/base/yz_bounty.ash";

void M_bounty_cleanup()
{

}

void M_bounty_progress()
{

  foreach hardness in $strings[currentSpecialBountyItem,
                               currentHardlBountyItem,
                               currentEasyBountyItem]
  {
    bounty b = to_bounty(get_property(hardness));
    if (b == $bounty[none]) continue;

    // find a way to count the bounties...
  }
}

void pick_bounty()
{

}

boolean M_bounty()
{
  string flag = to_lower_case(setting("do_bounty", "false"));

  // never to anything with the bounty:
  if (flag == "never") return false;

  update_bounties();

  // Only opportunistically try the bounty. Won't get many this way, but now and then.
  // Don't take any extra turns, though:
  if (flag == "false") return false;

  if (flag != "aggressive" && flag != "true")
  {
    warning("I don't understand what your preference is regarding the bounty.");
    warning("You've chosen '" + wrap(flag, COLOR_ITEM) + "', but the options are 'never, false, true, aggressive'.");
    warning("Setting this to the default ('false'). If you'd like this to be anything else, hit " + wrap('ESC', COLOR_ITEM) + " now and change it.");
    warning("For example: " + wrap('set yz_do_bounty=false', 'black'));
    wait(10);
    save_setting("do_bounty", "false");
    return true;
  }

  if (flag == "aggressive") pick_bounty();

  location hunt = $location[none];

  foreach hardness in $strings[currentSpecialBountyItem,
                               currentHardlBountyItem,
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
print(hunt);
abort();
return false;
//  yz_adventure(hunt, "");
//  return true;
}

void main()
{
  while (M_bounty());
}
