int i_a(string name) {
	item i = to_item(name);
	int a = item_amount(i) + closet_amount(i) + equipped_amount(i);

	//Make a check for familiar equipment NOT equipped on the current familiar.
	foreach fam in $familiars[] {
		if (have_familiar(fam) && fam != my_familiar()) {
			if (name == to_string(familiar_equipped_equipment(fam)) && name != "none") {
				a = a + 1;
			}
		}
	}

	//print("Checking for item "+name+", which it turns out I have "+a+" of.", "fuchsia");
	return a;
}

string COLOR_ITEM = "green";
string COLOR_LOCATION = "blue";

string wrap(string i, string color)
{
	return ("<font color='" + color + "'>" + i + "</font>");
}

string wrap(item i)
{
	return wrap(i, COLOR_ITEM);
}

string wrap(location l)
{
	return wrap(l, COLOR_LOCATION);
}

string BULLET = "*";
string NBSP = "&nbsp;";
string TAB = NBSP+NBSP+NBSP+NBSP;
string SUBBULLET = "*";

string COMPLETE = "X";

void complete(string msg)
{
	print(COMPLETE + NBSP + "<strikethrough>" + msg + "</STRIKETHROUGH>");
}

void task(string msg)
{
	print(BULLET + NBSP + msg);
}
void subtask(string msg)
{
	print(TAB + SUBBULLET + NBSP + msg);
}
void hint(string msg)
{
	print(TAB + SUBBULLET + NBSP + msg);
}
