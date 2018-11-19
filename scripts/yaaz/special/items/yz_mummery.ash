import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_inventory.ash";

string parse_costume(string ef)
{
  switch
  {
    case index_of(ef, "Meat Drop") > -1:
      return "meat";
    case index_of(ef, "HP Regen") > -1:
      return "hp";
    case index_of(ef, "MP Regen") > -1:
      return "mp";
    case index_of(ef, "Moxie") > -1:
      return "moxie";
    case index_of(ef, "Muscle") > -1:
      return "muscle";
    case index_of(ef, "Mysticality") > -1:
      return "mysticality";
    case index_of(ef, "Item") > -1:
      return "items";
    default:
      debug("Costume effect (" + wrap(ef, COLOR_EFFECT) + ") unknown.");
      return "unknown";
  }
}

string mummery_current(familiar fam)
{
  string[int] split_map = split_string(get_property("_mummeryMods"), ",");

  foreach s in split_map
  {
    print(split_map[s]);
    int start = index_of(split_map[s], "fam(") + 4;
    int end = last_index_of(split_map[s], ")");
    familiar target = to_familiar(substring(split_map[s], start, end));
    if (target == fam)
    {
      return parse_costume(split_map[s]);
    }
  }

  return "";
}

string mummery_current()
{
  return mummery_current(my_familiar());
}

void mummery_progress()
{

  if (!have($item[mumming trunk])) return;
  if (!be_good($item[mumming trunk])) return;
  if (mummery_current() == "")
    task("Apply a costume from the " + wrap($item[mumming trunk]));
}

void mummery()
{
  if (!have($item[mumming trunk])) return;
  if (!be_good($item[mumming trunk])) return;
}

void main()
{
  mummery();
}
