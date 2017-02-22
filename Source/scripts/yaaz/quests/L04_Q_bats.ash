import "util/main.ash";

boolean has_stench_res()
{
  return (elemental_resistance($element[stench]) > 0);
}

boolean get_stench_res()
{
  if (has_stench_res())
    return true;

  if (have_skill($skill[elemental saucesphere]))
  {
    get_saucepan();
    use_skill(1, $skill[elemental saucesphere]);
    return true;
  }

  if (have_skill($skill[astral shell]))
  {
    use_skill(1, $skill[astral shell]);
    return true;
  }

  if (item_amount($item[stench powder]) > 0)
  {
    use(1, $item[stench powder]);
    return true;
  }

  if (i_a($item[knob goblin harem veil]) > 0)
  {
    equip($item[knob goblin harem veil]);
    return true;
  }

  if (i_a($item[asshat]) > 0)
  {
    equip($item[asshat]);
    return true;
  }

  if (i_a($item[bum cheek]) > 0)
  {
    equip($item[bum cheek]);
    return true;
  }

  if (i_a($item[pine-fresh air freshener]) > 0 && my_basestat($stat[mysticality]) < 10)
  {
    return false;
  }

  if (i_a($item[pine-fresh air freshener]) > 0)
  {
    equip($item[pine-fresh air freshener]);
    return true;
  }

  log("Getting a " + wrap($item[Pine-Fresh air freshener]) + " for some stench resistance. Probably not optimal - go get some skills to help with this.");
  wait(3);
  while (i_a($item[Pine-Fresh air freshener]) == 0)
  {
    boolean b = yz_adventure($location[the bat hole entrance], "items");
    if (!b)
      return false;
  }
  return get_stench_res();
}

boolean L04_Q_bats()
{
  if (my_level() < 4)
    return false;

  if (quest_status("questL04Bat") == FINISHED)
    return false;

  while(quest_status("questL04Bat") != FINISHED)
  {
    switch(quest_status("questL04Bat"))
    {
      case UNSTARTED:
        log("Staring the " + wrap("Boss Bat", COLOR_LOCATION) + " quest.");
        council();
        break;
      case STARTED:
      case 1:
        if (item_amount($item[sonar-in-a-biscuit]) > 0)
        {
          use(1, $item[sonar-in-a-biscuit]);
          break;
        }
        if (item_amount($item[disassembled clover]) > 0)
        {
          if (!get_stench_res())
            return false;
          log("Going to clover for some " + wrap($item[sonar-in-a-biscuit]) + ".");
          yz_clover($location[guano junction]);
          break;
        }
        log("We don't have a clover to get a " + wrap($item[sonar-in-a-biscuit]) + ", so doing it the hard way.");
        maximize("");
        while(i_a($item[sonar-in-a-biscuit]) == 0 && can_adventure())
        {
          if (!get_stench_res())
            return false;
          yz_adventure($location[guano junction]);
          break;
        }
      case 2:
        if (item_amount($item[sonar-in-a-biscuit]) > 0)
        {
          use(1, $item[sonar-in-a-biscuit]);
          break;
        }
        location loc = $location[the batrat and ratbat burrow];
        maximize();
        if (quest_status("questL04Bat") == 1)
        {
          // we fell through from the case above
          loc = $location[guano junction];
          get_stench_res();
        }
        yz_adventure(loc);
        break;
      case 3:
        string max = "";
        if ($location[the boss bat's lair].turns_spent < 4)
        {
          log("The " + $monster[beefy bodyguard bat] + " is meaty. Let's get some.");
          max = "meat";
        } else {
          if (current_mcd() != 8)
          {
            log("May see the " + $monster[boss bat] + ", so setting the MCD accordingly. If you want something besides the " + wrap($item[boss bat bling]) + ", you'll have to edit the script accordingly to make it smarter.");
            change_mcd(8);
          }
        }
        yz_adventure($location[the boss bat's lair], max);
        break;
      case 4:
        log(wrap($monster[boss bat]) + " defeated. Going back to the council.");
        council();
        break;
    }
  }
  log(wrap($monster[boss bat]) + " defeated.");
  return true;
}

void main()
{
  L04_Q_bats();
}
