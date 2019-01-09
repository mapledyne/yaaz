import "util/yz_main.ash";


int ltt_stage()
{
  return quest_status("questLTTQuestByWire");
}

void ltt_progress()
{
  if (get_property("telegraphOfficeAvailable") != "true") return;

  if (quest_status("questLTTQuestByWire") == UNSTARTED) return;

  string msg = wrap("LT&T Telegram", COLOR_LOCATION) + " quest (" + wrap(get_property("lttQuestName"), COLOR_LOCATION) + "), stage " + wrap(ltt_stage(), COLOR_LOCATION);

  progress(to_int(get_property("lttQuestStageCount")), 9, msg);

}

int ltt_option_from_item(item target)
{
  switch(target)
  {
    default: return 0;
    case $item[Fancy Jeff's fancy pocket square]:
    case $item[Pecos Dave's sixgun]:
    case $item[Daisy's unclean bloomers]:
      return 1;
    case $item[Glenn's golden dice]:
    case $item[Amoon-Ra Cowtep's nemes]:
    case $item[Former Sheriff Dan's tin star]:
      return 2;
    case $item[El Vibrato restraints]:
    case $item[Clara's bell]:
    case $item[Granny Hackleton's Gatling gun]:
      return 3;
  }
  return 0;
}

int ltt_cost()
{
  buffer ltt_matcher = visit_url("place.php?whichplace=town_right&action=townright_ltt");
  matcher overtime = create_matcher("Pay overtime \\(([0-9,]+) Meat\\)", ltt_matcher);
  int price = 0;
  while (overtime.find()) {
    price = overtime.group(1).to_int();
  }
  return price;
}

item ltt_choice()
{
  string choices = visit_url('place.php?whichplace=town_right&action=townright_ltt');

  if (contains_text(choices, 'Pay overtime'))
  {
    save_daily_setting("done_ltt", "true");
    return $item[none];
  }

  boolean[item] choice_list;
  if (contains_text(choices, 'Missing: Fancy Man')) choice_list[$item[Fancy Jeff's fancy pocket square]] = true;
  if (contains_text(choices, 'Help! Desperados!')) choice_list[$item[Pecos Dave's sixgun]] = true;
  if (contains_text(choices, 'Missing: Pioneer Daughter')) choice_list[$item[Daisy's unclean bloomers]] = true;
  if (contains_text(choices, 'Big Gambling Tournament Announced')) choice_list[$item[Glenn's golden dice]] = true;
  if (contains_text(choices, 'Haunted Boneyard')) choice_list[$item[Amoon-Ra Cowtep's nemes]] = true;
  if (contains_text(choices, 'Sheriff Wanted')) choice_list[$item[Former Sheriff Dan's tin star]] = true;
  if (contains_text(choices, 'Madness at the Mine')) choice_list[$item[El Vibrato restraints]] = true;
  if (contains_text(choices, 'Missing: Many Children')) choice_list[$item[Clara's bell]] = true;
  if (contains_text(choices, 'Wagon Train Escort Wanted')) choice_list[$item[Granny Hackleton's Gatling gun]] = true;

  print(choice_list);
  item toy = $item[none];
  int qty = 1000000;

  foreach x in choice_list
  {
    int own = item_amount(x) + closet_amount(x) + equipped_amount(x);
    if (own < qty)
    {
      qty = own;
      toy = x;
    }
  }

  return toy;
}


void ltt_cleanup()
{

}

string ltt_maximizer()
{
  if (quest_status("questLTTQuestByWire") != 3 || to_int(get_property("lttQuestStageCount")) != 9)
    return "";

  // only maximize differently for the last boss

  switch (get_property("lttQuestName"))
  {
    default:
      return "";
    case 'Missing: Pioneer Daughter':
      return "";
    case 'Missing: Fancy Man':
      return "muscle, club";
    case 'Help!  Desperados!':
      return "effective, -hp";
    case 'Big Gambling Tournament Announced':
      max_effects("hot damage");
      max_effects("stench damage");
      max_effects("spooky damage");
      max_effects("sleaze damage");
      max_effects("cold damage");
      return "elemental damage";
    case 'Haunted Boneyard':
      return "spooky res, mainstat";
    case 'Madness at the Mine':
    case 'Sheriff Wanted':
    case 'Wagon Train Escort Wanted':
      if (have_outfit("smooch")) return "mainstat, outfit smooch";
      return "mainstat";
    case 'Missing: Many Children':
      return "all res, spell damage";
  }
}

boolean start_ltt_quest()
{
  item target = ltt_choice();
  if (target == $item[none]) return false;
  int option = ltt_option_from_item(target);
  if (option == 0)
  {
    error("Something happened with the LTT script and I don't know what I want to do here. :(");
    wait(10);
  }
  string choices = visit_url('place.php?whichplace=town_right&action=townright_ltt');
  run_choice(option);
  return true;
}

boolean attempt_ltt()
{
  if (setting("ltt_done") == "true") return false;

  if (quest_status("questLTTQuestByWire") == UNSTARTED)
  {
    start_ltt_quest();
    return true;
  }
  maximize(ltt_maximizer());

  if (quest_status("questLTTQuestByWire") == 3
      && to_int(get_property("lttQuestStageCount")) == 9)
  {
    log("The LT&T bosses are complicated enough, I don't know how to defeat them.");
    log("Exiting so you can handle them manually before continuing.");
    abort();
  }

  yz_adventure($location[Investigating a Plaintive Telegram]);
  return true;
}

boolean ltt()
{
  if (get_property("telegraphOfficeAvailable") != "true") return false;

  if (!be_good($item[your cowboy boots])) return false;

  if (!have($item[your cowboy boots]))
  {
    log("Getting " + wrap($item[your cowboy boots]) + ".");
    visit_url("place.php?whichplace=town_right&action=townright_ltt");
    return true;
  }

  if (setting("done_ltt") == "true")
  {
    int cost = to_int(setting("ltt_cost", "0"));
    if (cost == 0)
    {
      cost = ltt_cost();
      save_daily_setting("ltt_cost", cost);
    }
    int spend = to_int(setting("ltt_spend", "0"));
    if (cost <= spend)
    {
      save_daily_setting("done_ltt", "");
      string choices = visit_url('place.php?whichplace=town_right&action=townright_ltt');
      run_choice(4);
      return true;
    }

    return false;
  }

  string ltt_setting = setting("do_ltt", "unk");
  switch(ltt_setting)
  {
    default:
      warning("I don't know what this 'yz_do_ltt' setting is: " + ltt_setting);
      warning("Skipping. Valid values are: 'true', 'false', 'aftercore'");
      return false;
    case "unk":
      if (setting("ltt_warn") != "true")
      {
        log("You have an LT&T office. I can automate these quests if you");
        log("set yz_do_ltt to one of: 'true', 'false', or 'aftercore'");
        wait(5);
        save_daily_setting("ltt_warn", "true");
      }
    case "aftercore":
      if (!in_aftercore()) return false;
      return attempt_ltt();
    case "true":
      return attempt_ltt();
    case "false":
      return false;
  }

  return false;
}

void main()
{
  ltt();
}
