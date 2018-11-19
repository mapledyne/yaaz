import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";

boolean[item] garbage_items = $items[deceased crimbo tree,
                                     broken champagne bottle,
                                     tinsel tights,
                                     wad of used tape,
                                     makeshift garbage shirt];


void january_garbage_progress()
{
}

void january_garbage_cleanup()
{

}

void get_garbage_item(item yuck)
{
  if (!have($item[January's Garbage Tote])) return;
  if (!be_good($item[January's Garbage Tote])) return;

  if (have(yuck)) return;

// choice adventure #1275
//  choice 1: Grab a deceased crimbo tree
//  choice 2: Grab a broken champagne bottle
//  choice 3: Grab a mass of tinsel
//  choice 4: Grab some used tape
//  choice 5: Assemble a shirt
//  choice 6: Ignore the garbage for now

  int target = 6;
  switch(yuck)
  {
    case $item[deceased crimbo tree]:
      target = 1;
      break;
    case $item[broken champagne bottle]:
      target = 2;
      break;
    case $item[tinsel tights]:
      target = 3;
      break;
    case $item[wad of used tape]:
      target = 4;
      break;
    case $item[makeshift garbage shirt]:
      target = 5;
      break;
    default:
      error("Trying to get a " + wrap(yuck) + " from the " + wrap($item[january's garbage tote]) + ", but that doesn't makes sense.");
      return;
  }

  log("Getting a " + wrap(yuck) + " from the " + wrap($item[january's garbage tote]));
  set_property("choiceAdventure1275", target);
  use(1, $item[january's garbage tote]);
}

void get_garbage_item()
{
  get_garbage_item($item[wad of used tape]);
}

boolean have_garbage_item()
{
  foreach yuck in garbage_items
  {
    if (have(yuck)) return true;
  }
  return false;
}

boolean january_garbage()
{
  if (!have($item[January's Garbage Tote])) return false;
  if (!be_good($item[January's Garbage Tote])) return false;

  // only thing to to here is get an arbitrary item if we don't already have one.
  if (!have_garbage_item()) get_garbage_item();

  return false;
}

void main()
{
  while(january_garbage());
}
