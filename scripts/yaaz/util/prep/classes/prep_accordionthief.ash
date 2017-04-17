import "util/base/inventory.ash";
import "util/base/print.ash";
import "util/base/util.ash";

boolean knows_song()
{
  foreach s in $skills[]
  {
    if (!have_skill(s)) continue;
    if (!is_thief_buff(s)) continue;

    // we have a skill that's a song, so ...:
    return true;
  }
  return false;
}

void get_accordion()
{
  if (npc_price($item[toy accordion]) == 0)
    return;

  foreach a in $items[Antique Accordion,
                      toy accordion]
  {
    if (have(a)) return;
  }

  // need to make a  better list here.
  if (my_class() == $class[accordion thief])
  {
    foreach a in $items[stolen accordion]
    {
      if (have(a)) return;
    }
  }

  if ($classes[Avatar of Boris,
               Avatar of Jarlsberg,
               Avatar of Sneaky Pete,
               Ed,
               gelatinous noob] contains my_class()) return;

  if (!knows_song()) return;

	if(my_meat() > npc_price($item[toy accordion]) * 3)
	{
    log("Getting an accordion.");
		stock_item($item[toy accordion]);
	}
}


void prep_accordionthief(location loc)
{
  get_accordion();

  if (my_class() != $class[accordion thief]) return;

  // ... class specific stuff ...
}

void prep_accordionthief()
{
  prep_accordionthief($location[none]);
}

void main()
{
  prep_accordionthief();
}
