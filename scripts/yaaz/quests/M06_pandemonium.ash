import "util/main.ash";

void M06_pandemonium_progress()
{

}


void M06_pandemonium_cleanup()
{
  foreach steel in $items[steel margarita,
                        steel lasagna,
                        steel-scented air freshener]
  {
    if (have(steel)) try_consume(steel);
  }
}

boolean laugh_loop()
{
  if (have($item[Azazel\'s lollipop]) || have($item[observational glasses]))
    if (have($item[Azazel\'s Tutu]) || item_amount($item[Imp Air]) >= 5)
      return false;

  string max = "items, combat";

  // functionally this will just change our familiar to the Hound Dog if we have
  // it, but there's a chance it'll do other things in the future:
  if (item_amount($item[imp air]) >= 5)
    max = "combat, items";

  yz_adventure($location[the laugh floor], max);
  return true;
}

boolean backstage_loop()
{
  if (have($item[Azazel\'s Unicorn]) || backstage_items() == 4)
    if (have($item[Azazel\'s Tutu]) || item_amount($item[Bus Pass]) >= 5)
      return false;

  string max = "-combat, items";
  if (backstage_items() == 4)
    max = "items, combat";

  yz_adventure($location[infernal rackets backstage], max);
  return true;
}

boolean M06_pandemonium()
{
  M06_pandemonium_cleanup();

  if (have_skill($skill[liver of steel])) return false;
  if (have_skill($skill[stomach of steel])) return false;
  if (have_skill($skill[spleen of steel])) return false;

  if (quest_status("questL06Friar") != FINISHED) return false;
  if (my_path() == "Nuclear Autumn") return false;
  if (my_class() == $class[Ed]) return false;

  if (dangerous($location[the laugh floor])) return false;
  if (dangerous($location[infernal rackets backstage])) return false;

  if(quest_status("questM10Azazel") == UNSTARTED)
	{
		string temp = visit_url("pandamonium.php");
		temp = visit_url("pandamonium.php?action=moan");
		temp = visit_url("pandamonium.php?action=infe");
		temp = visit_url("pandamonium.php?action=sven");
		temp = visit_url("pandamonium.php?action=sven");
		temp = visit_url("pandamonium.php?action=beli");
		temp = visit_url("pandamonium.php?action=mourn");
	}

  if (laugh_loop()) return true;

  if (backstage_loop()) return true;

  if((backstage_items() == 4) && (!have($item[Azazel\'s Unicorn])))
  {
    log("Talking to " + wrap("Sven", COLOR_LOCATION) + " and attempting to get " + wrap($item[Azazel\'s Unicorn]) + ".");
    string temp = visit_url("pandamonium.php?action=sven");
    log("Giving " + wrap(jim()) + " to Jim.");
    visit_url("pandamonium.php?action=sven&bandmember=Jim&togive=" + to_int(jim()) + "&preaction=try");
    temp = visit_url("pandamonium.php?action=sven");
    log("Giving " + wrap(flargwurm()) + " to Flargwurm.");
    visit_url("pandamonium.php?action=sven&bandmember=Flargwurm&togive=" + to_int(flargwurm()) + "&preaction=try");
    temp = visit_url("pandamonium.php?action=sven");
    log("Giving " + wrap(bognort()) + " to Bognort.");
    visit_url("pandamonium.php?action=sven&bandmember=Bognort&togive=" + to_int(bognort()) + "&preaction=try");
    temp = visit_url("pandamonium.php?action=sven");
    log("Giving " + wrap(stinkface()) + " to Stinkface.");
    visit_url("pandamonium.php?action=sven&bandmember=Stinkface&togive=" + to_int(stinkface()) + "&preaction=try");
  }

  foreach it in $items[Hilarious Comedy Prop, Victor\, the Insult Comic Hellhound Puppet, Observational Glasses]
  {
    if (!have(it)) continue;

    if (!have_equipped(it))
    {
      log("Equipping the " + wrap(it) + " because it's funny.");
      equip(it);
    }

    log("Heading to " + wrap("Mourn's", COLOR_LOCATION) + " to show him our " + wrap(it) + ".");
    wait(3);
    string temp = visit_url("pandamonium.php?action=mourn&whichitem=" + to_int(it) + "&pwd=");
  }

  if (!have($item[Azazel\'s Tutu])
     && item_amount($item[Bus Pass]) >= 5
     && item_amount($item[Imp Air]) >= 5)
  {
    log("Heading to " + wrap("Moaning Panda Square", COLOR_LOCATION) + " to get " + wrap($item[Azazel\'s Tutu]) + ".");
    wait(3);
    string temp = visit_url("pandamonium.php?action=moan");
  }

  if (have($item[Azazel\'s Tutu])
      && have($item[Azazel\'s Lollipop])
      && have($item[Azazel\'s Unicorn]))
  {
    log("Off to " + wrap("Azazel's", COLOR_LOCATION) + " to turn in all of his stuff.");
    wait(3);
    string temp = visit_url("pandamonium.php?action=temp");
  }

  return true;
}

void main()
{
  while(M06_pandemonium());
}
