import "util/base/print.ash";
import "util/base/util.ash";
import "util/base/settings.ash";

string COLOR_TROPHY = "blue";

void trophy_progress(int cur, int max, string msg)
{
	progress(cur, max, msg, COLOR_TROPHY);
}

record trophyentry
{
	string image;
	string name;
	string tip;
};

trophyentry [int] all_trophies;
file_to_map(DATA_DIR + "trophies.txt", all_trophies);

trophyentry [int] trophies;
int [item] consumed;

trophyentry [int] parse_trophies()
{

	string page = visit_url("trophies.php");

	foreach x in all_trophies
	{
 		if (!contains_text(page, all_trophies[x].name))
		{
			trophies[x] = all_trophies[x];

		}
	}

	return trophies;
}

int [item] parse_consumables()
{
	int [item] consumed;

	string page = visit_url("showconsumption.php");
	page = replace_string(page, "<i>", "");
	page = replace_string(page, "</i>", "");

	matcher entry_matcher = create_matcher( "You have consumed the following food items:</b><p><table cellpadding=3><tr><td><table cellpadding=3>(.*)You have consumed the following booze items:</b><p><table><tr><td><table cellpadding=3>(.*)", page );

	if (entry_matcher.find())
	{

		string foodCons = entry_matcher.group(1);
		string boozeCons = entry_matcher.group(2);

    matcher foodMatcher = create_matcher("<a [^>]*>([^<]*)</a>&nbsp;&nbsp;&nbsp;</td><td>(\\d+)</td>", foodCons);

		while(foodMatcher.find())
		{
//			string f = foodMatcher.group(1) + " - " + foodMatcher.group(2);
      consumed[to_item(foodMatcher.group(1))] = to_int(foodMatcher.group(2));
		}

		matcher boozeMatcher = create_matcher("<a [^>]*>([^<]*)</a>&nbsp;&nbsp;&nbsp;</td><td>(\\d+)</td>", boozeCons);
		while(boozeMatcher.find())
		{
//			string b = boozeMatcher.group(1); // fixString(boozeMatcher.group(1));
			consumed[to_item(boozeMatcher.group(1))] = to_int(boozeMatcher.group(2));
		}
	}
	else
	{
		abort("Could not load consumption history");
	}
	return consumed;

}

void black_pudding()
{
	if (!(trophies contains 60))
		return;

	int eaten = consumed[$item[black pudding]];
	eaten = eaten * 0.35;
  if (eaten < 240)
  {
    trophy_progress(eaten, 240, "Awwww, Yeah trophy progress (approx)");
  } else {
		trophy_progress(eaten, 240, "Awwww, Yeah trophy should be available soon");
	}
}

void gyros()
{
	if (!(trophies contains 129))
		return;

	int eaten = consumed[$item[warbear gyro]];
	if (eaten < 108)
	{
		trophy_progress(eaten, 108, "Gyro Hero trophy progress");
		int price = historical_price($item[warbear gyro]);
		int total = (108 - eaten) * price;
		log("Price of a " + wrap($item[warbear gyro]) + ": " + comma_format(price) + ". Total est. cost remaining: " + comma_format(total) + ".");
	} else {
		trophy_progress(eaten, 108, "Gyro Hero trophy should be available");
	}

}

void milk()
{
	if (!(trophies contains 147))
		return;

	int eaten = consumed[$item[gallon of milk]];
	if (eaten < 7)
	{
		trophy_progress(eaten, 7, "Gallon of Milk trophy progress");
		int price = historical_price($item[gallon of milk]);
		int total = (7 - eaten) * price;
		log("Price of a " + wrap($item[gallon of milk]) + ": " + comma_format(price) + ". Total est. cost remaining: " + comma_format(total) + ".");
	} else {
		trophy_progress(eaten, 7, "Gallon of Milk trophy should be available");
	}

}

void bloodweiser()
{
	if (!(trophies contains 117))
		return;

	int eaten = consumed[$item[bottle of bloodweiser]];
	if (eaten < 50)
	{
		trophy_progress(eaten, 50, "Full Heart trophy progress");
	} else {
		trophy_progress(eaten, 50, "Full Heart trophy should be available (have Blood Porter effect)");
	}

}

void koolaid()
{
	if (!(trophies contains 118))
		return;

	int eaten = consumed[$item[electric Kool-Aid]];
	if (eaten < 50)
	{
		trophy_progress(eaten, 50, "Extended Capacity trophy progress");
	} else {
		trophy_progress(eaten, 50, "Extended Capacity trophy should be available (have Electrtic, Kool effect)");
	}

}


boolean[item] spirits_missing()
{
	boolean[item] the_list;

	foreach yum in $items[Zoodriver,
												Grasshopper,
												Dark & Starry,
												Cement Mixer,
												Lollipop Drop,
												Suffering Sinner,
												Humanitini,
												Firewater,
												Caipiranha,
												Buttery Knob,
												Fauna Libre,
												Mohobo,
												Great old fashioned,
												Red Dwarf,
												Punchplanter,
												sazerorc,
												herring daiquiri,
												aye aye,
												green velvet,
												slimosa,
												drac & tan,
												drunken philosopher,
												sloe comfortable zoo,
												sloe comfortable zoo on fire,
												locust,
												plague of locusts,
												black hole,
												event horizon,
												jackhammer,
												dump truck,
												candy alexander,
												candicaine,
												suppurating sinner,
												sizzling sinner,
												more humanitini than humanitini,
												oh\, the humanitini,
												earth and firewater,
												earth\, wind and firewater,
												flying caipiranha,
												flaming caipiranha,
												slippery knob,
												flaming knob,
												chakra libre,
												aura libre,
												moonshine mohobo,
												flaming mohobo,
												fuzzy tentacle,
												crazymaker,
												golden mean,
												green giant,
												doublepunchplanter,
												haymaker,
												sazuruk-hai,
												flaming sazerorc,
												herring wallbanger,
												herringtini,
												aye aye\, captain,
												aye aye\, tooth tooth,
												green muslin,
												green burlap,
												extra-slimy slimosa,
												slimebite,
												transylvania sling,
												shot of the living dead,
												drunken neurologist,
												drunken astrophysicist
												]
	{
		if (consumed[yum] == 0)
		{
			the_list[yum] = true;
		}
	}
	return the_list;
}


void spirits()
{
	if (!(trophies contains 105))
		return;
	boolean[item] missing_list = spirits_missing();

	int drank = 66 - count(missing_list);

	if (drank < 66)
	{
		trophy_progress(drank, 66, "Siphoned Spirits trophy progress");
		string suggest;
		int count = 0;
		foreach it in missing_list
		{
			if (length(suggest) > 0)
			{
				suggest += ", ";
			}
			suggest += wrap(it) + " (" + comma_format(historical_price(it)) + " meat)";
			count += 1;
			if (count > 2) break;
		}
		if (length(suggest) > 0)
		{
			log("Consider drinking one of: " + suggest);
		}
	} else {
		trophy_progress(drank, 66, "Siphoned Spirits trophy should be available");
	}
}


void royalty()
{

	if (to_int(get_property("royalty")) > 0)
	{

		int max = to_int(setting("royalty_max", "0"));
		if (max == 0)
		{
			string roy = visit_url("museum.php?floor=4&place=royalboards");


			int index = index_of( roy , "showplayer" );
			int start = index_of( roy , "<b>" , index ) + 3;
			int end   = index_of( roy , "</b>" , start );
			string player = substring( roy , start , end );

			start = index_of( roy , "<td>" , end ) + 4;
			end   = index_of( roy , "</td>" , start );

			max = to_int(substring( roy , start , end ));
			save_daily_setting("royalty_max", max);

		}
		progress(to_int(get_property("royalty")), max, "royalty", "blue");
		int price = historical_price($item[cuppa royal tea]);
		int total = (max - to_int(get_property("royalty"))) * price;
		log("Price of a " + wrap($item[cuppa royal tea]) + ": " + comma_format(price) + ". Total est. cost remaining: " + comma_format(total) + ".");

	}
}

void trophy()
{
	consumed = parse_consumables();
	trophies = parse_trophies();
	black_pudding();
	gyros();
	spirits();
	bloodweiser();
	koolaid();
	milk();
	royalty();
}

void main()
{
	trophy();
}
