import "util/yz_main.ash";

void L11_SQ_zeppelin_cleanup()
{

}

int protestors()
{
  return to_int(get_property("zeppelinProtestors"));
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

      // Using lynyrd musk gives you 3 lynyrd.
      // Each piece of lynyrdskin clothing (lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches) gives you 5 lynyrd.
      effect_maintain($effect[musky]);
      string stuff = "";

      foreach l in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
      {
        if(have(l)) stuff += ", +equip [" + to_int(l) + "]";
      }

      yz_adventure($location[A Mob of Zeppelin Protesters], "-combat, sleaze damage" + stuff);
      break;
    case 2:
      yz_adventure($location[the red zeppelin]);
      break;
    case 3:
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
