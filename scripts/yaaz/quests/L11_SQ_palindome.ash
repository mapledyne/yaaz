import "util/main.ash";
import "quests/M_pirates.ash";



//palindomeDudesDefeated

boolean get_photographs()
{
  if (palindome_items() == 5 && to_int(get_property("palindomeDudesDefeated")) <= 5)
    return false;
  if (quest_status("questL11Palindome") >= 1)
    return false;

  while (can_adventure()
         && (palindome_items() < 5
             || to_int(get_property("palindomeDudesDefeated")) < 5
             || !have($item[stunt nuts])))
  {
    string max = "items, -combat";
    if (palindome_items() >= 4)
    {
      max = "items";
    }
    maximize(max, $item[talisman o' namsilat]);
    boolean b = yz_adventure($location[inside the palindome]);
    if (!b)
      return true;
  }

  return true;
}

boolean stunt_nut_stew()
{
  if (quest_status("questL11Palindome") >= 4)
    return false;

  log("Off to get some ingredients to cook up some " + wrap($item[wet stunt nut stew]) + ".");
  maybe_pull($item[wet stew]);

  while(can_adventure() && item_amount($item[wet stunt nut stew]) == 0)
  {
    if (creatable_amount($item[wet stunt nut stew]) > 0)
    {
      log("Cooking one " + wrap($item[wet stunt nut stew]) + " just like Mr. Alarm's grandmother used to make.");
      create(1, $item[wet stunt nut stew]);
      continue;
    }
    if (!to_boolean(get_property("friarsBlessingReceived")))
    {
      log("Going to get a blessing from the Friars.");
      visit_url("friars.php?pwd&action=buffs&bro=1&button='Blessed Be'");
    }
    boolean b = yz_adventure($location[whitey's grove], "combat, items");
    if (!b)
      return true;
  }
  log("Giving the " + wrap($item[wet stunt nut stew]) + " to " + wrap("Mr. Alarm", COLOR_MONSTER) + ".");
  visit_url("place.php?whichplace=palindome&action=pal_mrlabel");
  cli_execute("refresh inv");
  return true;
}

boolean L11_SQ_palindome()
{
  if (get_talisman()) return true;

  if (i_a($item[Talisman o' Namsilat]) == 0)
    return false;

  switch(quest_status("questL11Palindome"))
  {
    default:
      log("This palindome quest status isn't scripted yet: " + quest_status("questL11Palindome"));
      wait(5);
      return false;
    case FINISHED:
      return false;
    case STARTED:
    case UNSTARTED:
      log("Getting the photographs for " + wrap($monster[Dr. Awkward]) + "'s office.");
      get_photographs();
      if(item_amount($item[[7262]&quot;I Love Me\, Vol. I&quot;]) == 0)
        return false;

      equip($item[Talisman o' Namsilat]);
      log("Using the " + wrap($item[[7262]&quot;I Love Me\, Vol. I&quot;]) + ".");
      use(1, $item[[7262]&quot;I Love Me\, Vol. I&quot;]);

      log("Going to arrange some photographs in Dr. Awkward's office.");
      visit_url("place.php?whichplace=palindome&action=pal_drlabel");
      visit_url("choice.php?pwd&whichchoice=872&option=1&photo1=2259&photo2=7264&photo3=7263&photo4=7265");

      log("Reading " + wrap($item[[7262]&quot;I Love Me\, Vol. I&quot;]) + ".");
      use(1, $item[&quot;2 Love Me\, Vol. 2&quot;]);
      log("Visiting Mr. Alarm.");
      equip($item[talisman o' namsilat]);
      visit_url("place.php?whichplace=palindome&action=pal_mrlabel");
      return true;
    case 3:
      stunt_nut_stew();
      return true;
    case 4:
      log("Giving the " + wrap($item[wet stunt nut stew]) + " to " + wrap("Mr. Alarm", COLOR_MONSTER) + ".");
      equip($item[talisman o' namsilat]);
      visit_url("place.php?whichplace=palindome&action=pal_mrlabel");
      cli_execute("refresh inv");
      return true;
    case 5:
      log("Off to fight " + wrap($monster[Dr. Awkward]) + ".");
      prep();
      maximize("equip talisman o' namsilat, equip mega gem");
  		set_property("choiceAdventure131", 2);
  		visit_url("place.php?whichplace=palindome&action=pal_droffice");
  		visit_url("choice.php?pwd&whichchoice=131&option=2");
      run_combat('yz_consult');
      return true;

  }
}

void main()
{
  while (L11_SQ_palindome());
}
