import "util/base/inventory.ash";

boolean can_pulverize()
{
  return have_skill($skill[pulverize]);
}

void pulverize_things()
{

  if (!have_skill($skill[pulverize]))
    return;

  if (item_amount($item[tenderizing hammer]) == 0)
  {
    // don't do this unless we have surplus meat.
    if (my_meat() < 5000 && my_level() > 5)
      return;

    buy(1, $item[tenderizing hammer]);
  }

  // Always pulverize:
  pulverize_all($item[Lockenstock&trade; sandals]);
  pulverize_all($item[gaia beads]);
  pulverize_all($item[hippy medical kit]);
  pulverize_all($item[wicker shield]);

  // Always keep one:
  pulverize_all_but_one($item[compression stocking]);
  pulverize_all_but_one($item[goatskin umbrella]);
  pulverize_all_but_one($item[little black book]);
  pulverize_all_but_one($item[pygmy briefs]);

  // we may want some of these if not relying on muscle:
  pulverize_keep_if($item[punk rock jacket], my_primestat() != $stat[muscle]);

  // Only keep if we're not playing mysticality:
  pulverize_keep_if($item[giant gym membership card], my_primestat() != $stat[mysticality]);

  // Only keep if we're muscle:
  pulverize_keep_if($item[black sword], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[giant cactus quill], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[giant safety pin], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[giant turkey leg], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[pointed stick], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[ridiculously huge sword], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[spiked femur], my_primestat() == $stat[muscle]);
  pulverize_keep_if($item[wolf mask], my_primestat() == $stat[muscle]);

  // Only keep if we're mysticality:
  pulverize_keep_if($item[ancient ice cream scoop], my_primestat() == $stat[mysticality]);
  pulverize_keep_if($item[big bad voodoo mask], my_primestat() == $stat[mysticality]);
  pulverize_keep_if($item[brown felt tophat], my_primestat() == $stat[mysticality]);
  pulverize_keep_if($item[giant artisanal rice peeler], my_primestat() == $stat[mysticality]);

  // only keep if we're moxie:
  pulverize_keep_if($item[armgun], my_primestat() == $stat[moxie]);
  pulverize_keep_if($item[buoybottoms], my_primestat() == $stat[moxie]);
  pulverize_keep_if($item[happiness], my_primestat() == $stat[moxie]);
  pulverize_keep_if($item[magilaser blastercannon], my_primestat() == $stat[moxie]);
  pulverize_keep_if($item[frigid hanky&#363;], my_primestat() == $stat[moxie]);


  // Stuff below this are things we'll pulverize based on quest status:

  // may be useful for the peak.
  if (get_property("booPeakProgress") > 0)
  {
    pulverize_all_but_one($item[glowing red eye]);
  } else {
    pulverize_all($item[glowing red eye]);
  }

  // Keep surgeonosity items if we haven't finished the L11 doc quest.
  pulverize_keep_if($item[bloodied surgical dungarees], quest_status("questL11Doctor") < 10);
  pulverize_keep_if($item[half-size scalpel], quest_status("questL11Doctor") < 10 || my_primestat() == $stat[muscle]);


  // war items:
  pulverize_keep_if($item[bullet-proof corduroys], quest_status("questL12War") < 10);
  pulverize_keep_if($item[reinforced beaded headband], quest_status("questL12War") < 10);
  pulverize_keep_if($item[round purple sunglasses], quest_status("questL12War") < 10);

  // some more aggressive work if we aren't flush in wads:
  if (wad_total() < spleen_limit())
  {
    pulverize_all_but_one($item[twinkly nuggets]);
    pulverize_all_but_one($item[hot nuggets]);
    pulverize_all_but_one($item[cold nuggets]);
    pulverize_all_but_one($item[sleaze nuggets]);
    pulverize_all_but_one($item[spooky nuggets]);
    pulverize_all_but_one($item[stench nuggets]);
  }
}
