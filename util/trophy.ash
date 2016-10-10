import "util/base/print.ash";
import "util/base/util.ash";

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
	if (consumed[$item[black pudding]] == 0)
		return;
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
	if (consumed[$item[warbear gyro]] == 0)
		return;
	if (!(trophies contains 129))
		return;

	int eaten = consumed[$item[warbear gyro]];
	if (eaten < 108)
	{
		trophy_progress(eaten, 108, "Gyro Hero trophy progress");
	} else {
		trophy_progress(eaten, 108, "Gyro Hero trophy should be available");
	}

}


void trophy()
{
	consumed = parse_consumables();
	trophies = parse_trophies();
	black_pudding();

}

void main()
{
	trophy();
}
