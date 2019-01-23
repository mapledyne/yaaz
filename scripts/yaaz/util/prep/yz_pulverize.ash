import "util/base/yz_inventory.ash";
import "util/base/yz_quests.ash";

boolean can_pulverize()
{
  return have_skill($skill[pulverize]);
}

void pulverize_things()
{

  if (!have_skill($skill[pulverize]))
    return;

  if (!have($item[tenderizing hammer]))
  {
    // don't do this unless we have surplus meat.
    if (my_meat() < 5000 && my_level() > 5)
      return;

    buy(1, $item[tenderizing hammer]);
  }


  int[item] pulv_items;
  file_to_map(DATA_DIR + "yz_pulverize.txt", pulv_items);

  foreach it, i in pulv_items
  {
    pulverize_all(it, i);
  }

  // we may want some of these if not relying on muscle:


  boolean[item] muscle_items = $items[black sword,
                                      giant cactus quill,
                                      giant gym membership card,
                                      giant safety pin,
                                      giant turkey leg,
                                      pointed stick,
                                      ridiculously huge sword,
                                      spiked femur,
                                      wolf mask];

  boolean[item] moxie_items = $items[a butt tuba,
                                     armgun,
                                     bone flute,
                                     buoybottoms,
                                     frigid hanky&#363;,
                                     happiness,
                                     hippy bongo,
                                     magilaser blastercannon,
                                     punk rock jacket,
                                     world's smallest violin];

  boolean[item] mysticality_items = $items[ancient ice cream scoop,
                                           big bad voodoo mask,
                                           brown felt tophat,
                                           giant artisanal rice peeler];

  if (my_primestat() != $stat[muscle])
  {
    foreach it in muscle_items
    {
      pulverize_all(it, 0);
    }
  }

  if (my_primestat() != $stat[mysticality])
  {
    foreach it in mysticality_items
    {
      pulverize_all(it, 0);
    }
  }

  if (my_primestat() != $stat[moxie])
  {
    foreach it in moxie_items
    {
      pulverize_all(it, 0);
    }
  }

  if (my_class() != $class[accordion thief])
  {
    foreach it in $items[autocalliope]
    {
      pulverize_all(it, 0);
    }
  }


  // Stuff below this are things we'll pulverize based on quest status:

  // may be useful for the peak.
  if (get_property("booPeakProgress") > 0)
  {
    pulverize_all($item[glowing red eye], 1);
  } else {
    pulverize_all($item[glowing red eye]);
  }

  // bridge built
  if (quest_status("questL09Topping") > 1)
  {
    pulverize_all($item[orcish stud-finder], 1);
  }


  // Keep surgeonosity items if we haven't finished the L11 doc quest.
  pulverize_keep_if($item[bloodied surgical dungarees], quest_status("questL11Doctor") < 10);
  pulverize_keep_if($item[half-size scalpel], quest_status("questL11Doctor") < 10 || my_primestat() == $stat[muscle]);

  // some more aggressive work if we aren't flush in wads:
  if (prop_int("lastGuildStoreOpen") == my_ascensions()
      && my_primestat() == $stat[muscle]
      && wad_total() < spleen_limit())
  {
    foreach nug in $items[twinkly powder,
                          stench powder,
                          spooky powder,
                          hot powder,
                          cold powder,
                          sleaze powder,
                          twinkly nuggets,
                          hot nuggets,
                          cold nuggets,
                          sleaze nuggets,
                          spooky nuggets,
                          stench nuggets]
    {
      if (item_amount(nug) > 5
          && wad_total() < spleen_limit())
        pulverize_all(nug);
    }
  }
}
