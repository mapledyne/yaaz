import "util/main.ash";

boolean has_stench_res()
{
  return (elemental_resistance($element[stench]) > 0);
}

void get_stench_res()
{
  if (has_stench_res())
    return;

  if (have_skill($skill[elemental saucesphere]))
  {
    get_saucepan();
    use_skill(1, $skill[elemental saucesphere]);
    return;
  }

  if (have_skill($skill[astral shell]))
  {
    use_skill(1, $skill[astral shell]);
    return;
  }

  if (item_amount($item[stench powder]) > 0)
  {
    use(1, $item[stench powder]);
    return;
  }

  if (i_a($item[knob goblin harem veil]) > 0)
  {
    equip($item[knob goblin harem veil]);
    return;
  }

  if (i_a($item[pine-fresh air freshener]) > 0)
  {
    equip($item[pine-fresh air freshener]);
    return;
  }

  if (i_a($item[asshat]) > 0)
  {
    equip($item[asshat]);
    return;
  }

  if (i_a($item[bum cheek]) > 0)
  {
    equip($item[bum cheek]);
    return;
  }

  log("Getting a " + wrap($item[Pine-Fresh air freshener]) + " for some stench resistance. Probably not optimal - go get some skills to help with this.");
  while (i_a($item[Pine-Fresh air freshener]) == 0)
  {
    dg_adventure($location[entryway], "items");
  }
  equip($item[Pine-Fresh air freshener]);

}

void do_bats()
{
  if (my_level() < 4)
  {
    warning("You need to be level 4 or better to defeat the bats.");
    return;
  }
  while(quest_status("questL04Bat") != FINISHED)
  {
    switch(quest_status("questL04Bat")
    {
      case unstarted:
        log("Staring the " + wrap("Boss Bat", COLOR_LOCATION) + " quest.");
        council();
        break;
      case STARTED:
      case 1:
        if (item_amount($item[sonar-in-a-buscuit]))
        {
          use(1, $item[sonar-in-a-biscuit]);
          break;
        }
        if (item_amount($item[disassembled clover]) > 0)
        {
          log("Going to clover for some " + wrap($item[sonar-in-a-biscuit]) + ".");
          use(1, $item[disassembled clover]);
          string protect = get_property("cloverProtectActive");
          set_property("cloverProtectActive", false);

          get_stench_res();
          dg_adventure($location[guano junction]);

          set_property("cloverProtectActive", protect);
          break;
        }
      case 2:
        if (item_amount($item[sonar-in-a-buscuit]))
        {
          use(1, $item[sonar-in-a-biscuit]);
          break;
        }
        location loc = $location[the batrat and ratbat burrow];
        maximize();
        if (quest_status("questL04Bat") == 1)
        {
          // we fell through from the case above
          loc = $location[guano junction]
          get_stench_res();
        }
        dg_adventure(loc);
        break;
      case 3:
        string max = "";
        if ($location[the boss bat's lair].turns_spent < 4)
        {
          log("The " + $monster[beefy bodyguard bat] + " are meaty. Let's get some.");
          max = "meat";
        } else {
          if (current_mcd() != 8)
          {
            log("May see the " + $monster[boss bat] + ", so setting the MCD accordingly. If you want something besides the " + wrap($item[boss bat bling]) + ", you'll have to edit the script accordingly to make it smarter.");
            change_mcd(8);
          }
        }
        dg_adventure($location[the boss bat's lair], max);
        break;
      case 4:
        log(wrap($monster[boss bat]) + " defeated. Going back to the council.");
        council();
        break;
    }
  }
  log(wrap($monster[boss bat]) + " defeated.");
}

main()
{
  do_bats();
}
