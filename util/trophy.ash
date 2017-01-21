import "util/base/print.ash";
import "util/base/util.ash";
import "util/base/settings.ash";
import "util/base/consume.ash";

boolean DEBUG_TROPHY = false;

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


void basic_consumption_trophy(item it, int qty, int trophy, string parens)
{
	if (!(trophies contains trophy) && !DEBUG_TROPHY) return;

	int eaten = consumed[it];
	if (eaten == 0) return;

	string name = all_trophies[trophy].name;

	if (length(parens) > 0) parens = " (" + parens + ")";

	if (eaten < qty)
	{
		trophy_progress(eaten, qty, name + " progress" + parens);
		int price = historical_price(it);
		if (price > 0)
		{
			int total = (qty - eaten) * price;
			log("Price of one " + wrap(it) + ": " + comma_format(price) + ". Total est. cost remaining: " + comma_format(total) + ".");
		}
	} else {
		trophy_progress(eaten, qty, name + " trophy should be available" + parens);
	}
}

void basic_consumption_trophy(item it, int qty, int trophy)
{
	basic_consumption_trophy(it, qty, trophy, "");
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
		trophy_progress(drank, 66, "Siphoned Spirits progress");
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
		log("Price of one " + wrap($item[cuppa royal tea]) + ": " + comma_format(price) + ". Total est. cost remaining: " + comma_format(total) + ".");

	}
}

int familiar_weight_total()
{
	int total = 0;
	foreach f in $familiars[]
	{
		if (have_familiar(f))
		{
			total += familiar_weight(f);
		}
	}
	return total;
}


void basic_trophy(int have, int needed, int trophy)
{
	if (!(trophies contains trophy) && !DEBUG_TROPHY) return;

	string msg = all_trophies[trophy].name;

	if (have < needed)
	{
		msg += " progress";
	} else {
		msg += " should be available";
	}

	trophy_progress(have, needed, msg);

}

int nom_sorter(item it)
{
	int price = historical_price(it);

	if (price == 0) price = 2147483647; // MAXINT
	if (can_consume(it)) price = price / 100;

	return price;
}

void nom_something()
{
	item[int] nomlist;

	int nom_count = 0;
	foreach nom in $items[]
	{
		if ((nom.fullness > 0
		    || nom.inebriety > 0)
				&& !(consumed contains nom))
		{
			if (nom == $item[ice stein]) continue; // not tracked by consumption history
			nomlist[nom_count] = nom;
			nom_count++;
		}
	}

	sort nomlist by nom_sorter(value);

	string nom_msg = "";
	int count = 0;
	foreach n in nomlist
	{
		item nom = nomlist[n];
		if (count > 2) break;
		if (length(nom_msg) > 0) nom_msg += ", ";

		nom_msg += wrap(nom);
		int cost = historical_price(nom);
		if (cost > 0) nom_msg += " (" + cost + " meat)";
		count++;
	}
	if (length(nom_msg) > 0)
		log("Interested in consuming something you haven't yet? Try one of: " + nom_msg);
}

void trophy()
{
	consumed = parse_consumables();
	trophies = parse_trophies();
	basic_consumption_trophy($item[white canadian], 30, 3);
	basic_trophy(familiar_weight_total(), 100, 4);
	basic_trophy(familiar_weight_total(), 300, 5);
	basic_consumption_trophy($item[spaghetti with Skullheads], 5, 9);
	basic_consumption_trophy($item[tomato daiquiri], 5, 10);
	basic_consumption_trophy($item[ghuol guolash], 11, 11);
	basic_consumption_trophy($item[herb brownies], 420, 14);
	basic_consumption_trophy($item[white chocolate and tomato pizza], 5, 15);
	basic_trophy(familiar_weight_total(), 500, 16);
	basic_consumption_trophy($item[lucky surprise egg], 50, 17);
	basic_trophy(to_int(get_property("sexChanges")), 30, 33);
	if (in_hardcore()) basic_trophy(my_meat(), 1000000, 34);
	if (my_class() == $class[seal clubber]) basic_trophy(my_level(), 30, 40);
	if (my_class() == $class[turtle tamer]) basic_trophy(my_level(), 30, 41);
	if (my_class() == $class[pastamancer]) basic_trophy(my_level(), 30, 42);
	if (my_class() == $class[sauceror]) basic_trophy(my_level(), 30, 43);
	if (my_class() == $class[disco bandit]) basic_trophy(my_level(), 30, 44);
	if (my_class() == $class[accordion thief]) basic_trophy(my_level(), 30, 44);
	basic_consumption_trophy($item[black pudding], 446, 60, "very approx");
	basic_consumption_trophy($item[around the world], 80, 61);
	basic_trophy(to_int(get_property("camerasUsed")), 40, 90);
	if (my_path() == "Way of the Surprising Fist") basic_trophy(to_int(get_property("totalCharitableDonations")), 1000000, 100);
	if (my_path() == "Avatar of Boris") basic_trophy(my_level(), 30, 104);
	spirits(); // 105
	if (my_path() == "Avatar of Jarlsberg") basic_trophy(my_level(), 30, 113);
	basic_consumption_trophy($item[bottle of bloodweiser], 50, 117, "need Blood Porder effect, also");
	basic_consumption_trophy($item[electric Kool-Aid], 50, 118, "need Electric, Kool effect, also");
	basic_trophy(to_int(get_property("boneAbacusVictories")), 1000, 124);
	basic_consumption_trophy($item[warbear gyro], 108, 129);
	if (my_path() == "Avatar of Sneaky Pete") basic_trophy(my_level(), 30, 136);
	basic_consumption_trophy($item[mini-martini], 7, 139);

	int spel = 0;
	for x from 0 to length(get_property("spelunkyUpgrades")) - 1
	{
		if (char_at(get_property("spelunkyUpgrades"), x) == 'Y') spel++;
	}
	basic_trophy(spel, 9, 140);

	basic_consumption_trophy($item[gallon of milk], 7, 147);
	royalty(); // not a trophy, but seems to fit here in the spirit of things.

	nom_something();
}

void main()
{
	trophy();
}
