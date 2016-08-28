import "util/main.ash";

item jim()
{
  if (item_amount($item[Comfy Pillow]) > 0)
    return $item[Comfy Pillow];
  if (item_amount($item[Sponge Cake]) > 0)
    return $item[Sponge Cake];
  return $item[none];
}

item flargwurm()
{
  if (item_amount($item[Booze-Soaked Cherry]) > 0)
    return $item[Booze-Soaked Cherry];
  if (jim() != $item[sponge cake] && item_amount($item[sponge cake]) == 1)
    return $item[sponge cake];
  if (item_amount($item[sponge cake]) > 1)
    return $item[sponge cake];
  return $item[none];
}

item bognort()
{
  if (item_amount($item[Giant Marshmallow]) > 0)
    return $item[Giant Marshmallow];
  if (item_amount($item[Gin-Soaked Blotter Paper]) > 0)
    return $item[Gin-Soaked Blotter Paper];
  return $item[none];
}

item stinkface()
{
  if (item_amount($item[Beer-Scented Teddy Bear]) > 0)
    return $item[Beer-Scented Teddy Bear];
  if (bognort() != $item[Gin-Soaked Blotter Paper] && item_amount($item[Gin-Soaked Blotter Paper]) == 1)
    return $item[Gin-Soaked Blotter Paper];
  if (item_amount($item[Gin-Soaked Blotter Paper]) > 1)
    return $item[Gin-Soaked Blotter Paper];
  return $item[none];
}

int backstage_items()
{
  int count = 0;
  if (jim() != $item[none])
    count += 1;
  if (flargwurm() != $item[none])
    count += 1;
  if (bognort() != $item[none])
    count += 1;
  if (stinkface() != $item[none])
    count += 1;

  return count;
}

boolean laugh_loop()
{
  if (item_amount($item[Azazel\'s lollipop]) > 0 || i_a($item[observational glasses]) > 0)
    if (item_amount($item[Azazel\'s Tutu]) > 0 || item_amount($item[Imp Air]) >= 5)
      return false;

  string max = "items, combat";

  // functionally this will just change our familiar to the Hound Dog if we have
  // it, but there's a chance it'll do other things in the future:
  if (item_amount($item[imp air]) >= 5)
    max = "combat, items";

  dg_adventure($location[the laugh floor], max);
  progress(item_amount($item[imp air]), 5, "imp airs");
  if (i_a($item[observational glasses]) == 0)
  {
    log("Still looking for the " + wrap($item[observational glasses]) + " also.");
  } else {
    log("We've found the " + wrap($item[observational glasses]) + ".");
  }
  return true;
}

boolean backstage_loop()
{
  if (item_amount($item[Azazel\'s Unicorn]) > 0 || backstage_items() == 4)
    if (item_amount($item[Azazel\'s Tutu]) > 0 || item_amount($item[Bus Pass]) >= 5)
      return false;

  string max = "-combat, items";
  if (backstage_items() == 4)
    max = "items, combat";

  dg_adventure($location[infernal rackets backstage], max);
  progress(item_amount($item[bus pass]), 5, "bus passes");
  string band = "";
  if (jim() != $item[none])
  {
    band += "Jim";
  }
  if (flargwurm() != $item[none])
  {
    if (band != "")
      band += ", ";
    band += "Flargwurm";
  }
  if (bognort() != $item[none])
  {
    if (band != "")
      band += ", ";
    band += "Bognort";
  }
  if (stinkface() != $item[none])
  {
    if (band != "")
      band += ", ";
    band += "Stinkface";
  }

  progress(backstage_items(), 4, "backstage items (" + band + ")");
  return true;
}

boolean M06_pandemonium()
{

  if (have_skill($skill[liver of steel]))
    return false;
  if (have_skill($skill[stomach of steel]))
    return false;
  if (have_skill($skill[spleen of steel]))
    return false;
  if (quest_status("questL06Friar") != FINISHED)
    return false;
  if (my_path() == "Nuclear Autumn")
    return false;
  if (my_class() == $class[Ed])
    return false;


  int turns = my_adventures();

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


  int counter = 0;

  while (laugh_loop())
  {

  }

  while (backstage_loop())
  {

  }

  if((backstage_items() == 4) && (item_amount($item[Azazel\'s Unicorn]) == 0))
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
    if (i_a(it) == 0)
      continue;
    if (!have_equipped(it))
    {
      log("Equipping the " + wrap(it) + " because it's funny.");
      equip(it);
    }
    log("Heading to " + wrap("Mourn's", COLOR_LOCATION) + " to show him our " + wrap(it) + ".");
    wait(3);
    string temp = visit_url("pandamonium.php?action=mourn&whichitem=" + to_int(it) + "&pwd=");
  }

  if((item_amount($item[Azazel\'s Tutu]) == 0) && (item_amount($item[Bus Pass]) >= 5) && (item_amount($item[Imp Air]) >= 5))
  {
    log("Heading to " + wrap("Moaning...", COLOR_LOCATION) + " to get " + wrap($item[Azazel\'s Tutu]) + ".");
    wait(3);
    string temp = visit_url("pandamonium.php?action=moan");
  }

  if((item_amount($item[Azazel\'s Tutu]) > 0) && (item_amount($item[Azazel\'s Lollipop]) > 0) && (item_amount($item[Azazel\'s Unicorn]) > 0))
  {
    log("Off to " + wrap("Azazel's", COLOR_LOCATION) + " to turn in all of his stuff.");
    wait(3);
    string temp = visit_url("pandamonium.php?action=temp");
  }

  return true;
}

void main()
{
  M06_pandemonium();
}
