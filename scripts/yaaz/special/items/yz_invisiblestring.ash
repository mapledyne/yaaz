import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_inventory.ash";

void invisiblestring_progress()
{
  if (have($item[invisible string]))
  {
    task("You have an " + wrap($item[invisible string]) + ".");
  }

}

void invisiblestring()
{
  debug("I might want to do something with the " + wrap($item[invisible string]) + " ...");
}

void main()
{
  invisiblestring();
}
