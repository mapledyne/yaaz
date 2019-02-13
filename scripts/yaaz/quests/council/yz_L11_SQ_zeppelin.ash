import "util/yz_main.ash";

void L11_SQ_zeppelin_cleanup()
{
  if (have($item[lynyrd skin]))
  {
    foreach l in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
    {
      if (!have(l))
      {
        create(1, l);
      }
    }
  }
}

int lynyrd_clothing()
{
  int count = 0;
  foreach l in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
  {
    if (have(l)) count++;
  }
  return count;
}

int protestors()
{
  return prop_int("zeppelinProtestors");
}

void L11_SQ_zeppelin_progress()
{
  if (quest_active("questL11Ron"))
  {
    if (quest_status("questL11Ron") == 1)
    {
      int prot = prop_int("zeppelinProtestors");
      progress(prot, 80, "Protestors defeated from " + wrap($location[A Mob of Zeppelin Protesters]));
    }

  }
}

boolean L11_SQ_zeppelin()
{
  if (!quest_active("questL11Ron")) return false;


  switch (quest_status("questL11Ron"))
  {
    default:
      debug("I don't know about the questL11Ron status of: " + get_property("questL11Ron"));
      return false;
    case STARTED:
      yz_adventure($location[A Mob of Zeppelin Protesters]);
      break;
    case 1:
      set_property("choiceAdventure856", 1);
      set_property("choiceAdventure857", 1);
      if (have($item[Flamin' Whatshisname]))
      {
        set_property("choiceAdventure858", 1);
      } else {
        set_property("choiceAdventure858", 2);
      }

      if (have($item[lynyrd snare])
          && prop_int("_lynyrdSnareUses") < 3
          && lynyrd_clothing() < 3)
      {
        maximize();
        log("Using a " + wrap($item[lynyrd snare]) + " to get a " + wrap($item[lynyrd skin]) + ".");
        use(1, $item[lynyrd snare]);
        run_combat('yz_consult');
        return true;
      }

      // Using lynyrd musk gives you 3 lynyrd.
      // Each piece of lynyrdskin clothing (lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches) gives you 5 lynyrd.
      effect_maintain($effect[musky]);
      string stuff = "";

      foreach l in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
      {
        if (have(l)) stuff += ", +equip [" + to_int(l) + "]";
      }

      yz_adventure($location[A Mob of Zeppelin Protesters], "-combat, sleaze damage" + stuff);
      break;
    case 2:
      yz_adventure($location[the red zeppelin]);
      break;
    case 3:
      monster_attract = $monsters[red skeleton, man with the red buttons, red butler];
      monster_banish = $monsters[red herring, red snapper];
    case 4:
      yz_adventure($location[the red zeppelin], "");
      break;
  }
  return true;
}

void main()
{
  while (L11_SQ_zeppelin());
}
