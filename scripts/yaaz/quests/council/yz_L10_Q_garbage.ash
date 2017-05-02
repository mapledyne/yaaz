import "util/yz_main.ash";

void L10_Q_garbage_progress()
{
  if (quest_status("questL10Garbage") == UNSTARTED) return;

  if (quest_status("questL10Garbage") < 2)
  {
    if (!have($item[enchanted bean]))
      task("Get an " + wrap($item[enchanted bean]));
    else
      task("Grow the beanstalk.");
  }

  if (!have($item[s.o.c.k.]))
  {
    progress(immateria(), 4, "Immateria found");
    progress($location[the penultimate fantasy airship].turns_spent, 20, "minimum turns in the airship to find the " + wrap($item[s.o.c.k.]) + ".");
    if (immateria() == 4)
      task("Find the " + wrap($item[s.o.c.k.]));
  }

  if (quest_status("questL10Garbage") == 7)
    task("Open the " + wrap($location[The Castle in the Clouds in the Sky (Basement)]));

  if (quest_status("questL10Garbage") == 8)
    progress($location[The Castle in the Clouds in the Sky (Ground Floor)].turns_spent, 11, "progress to open the top floor of the castle");

  if (quest_status("questL10Garbage") == 9)
    task("Spin the garbage wheel");

  if (quest_status("questL10Garbage") >= 9
      && !have($item[steam-powered model rocketship]))
  {
    task("Find a " + wrap($item[steam-powered model rocketship]));
  }

}

void L10_Q_garbage_cleanup()
{

  // some things we're likely to run into during this quest:
  sell_all($item[disturbing fanfic], 1);
}

void plant_beanstalk()
{
  if (!have($item[enchanted bean])
      && quest_status("questL10Garbage") < 2)
  {
    yz_adventure($location[the beanbat chamber], "items");
    return;
  }

  if (quest_status("questL10Garbage") < 2)
  {
    log("Planting an " + wrap($item[enchanted bean]) + ".");
    use(1, $item[enchanted bean]);
  }
}

void get_sock()
{
  if (have($item[s.o.c.k.])) return;

  add_attract($monster[quiet healer]);

  string max = "items, -combat";
  if ($location[the penultimate fantasy airship].turns_spent < 5)
  {
    max = "items";
  }

  boolean b = yz_adventure($location[the penultimate fantasy airship], max);

  if (have($item[s.o.c.k.])) remove_attract($monster[quiet healer]);
  return;
}

void open_ground_floor()
{
  if (quest_status("questL10Garbage") != 7) return;

  maximize("", $item[amulet of extreme plot significance]);

  // this could be smarter (travel without the umbrella equipped, then skip out
  // through the mousehole, equip umbrella, and come right back)
  set_property("choiceAdventure669", 1); // either open ground floor (with umbrella) or fitness choice (without)

  if (have_equipped($item[amulet of extreme plot significance]))
    set_property("choiceAdventure670", 4); // open ground floor
  else
    set_property("choiceAdventure670", 1); // massive dumbbell (or skip)

  if (have($item[massive dumbbell]))
    set_property("choiceAdventure671", 1); // open ground floor (with dumbbell)
  else
    set_property("choiceAdventure671", 4); // Fitness choice (670)


  if (have($item[titanium assault umbrella])
      && !have_equipped($item[titanium assault umbrella])
      && my_path() != "Way of the Surprising Fist")
  {
    equip($item[titanium assault umbrella]);
  }

  yz_adventure($location[The Castle in the Clouds in the Sky (Basement)]);
}

void open_top_floor()
{
  if (quest_status("questL10Garbage") != 8)
    return;

  set_property("choiceAdventure672", 3); // skip: "There's No Ability Like Possibility"

  // note: leaving this at 1 after getting book doesn't take an adventure:
  set_property("choiceAdventure673", 1); // Library book in "Putting Off Is Off-Putting"

  set_property("choiceAdventure674", 3); // skip: "Huzzah!"

  location ground = $location[The Castle in the Clouds in the Sky (Ground Floor)];
  if (ground.turns_spent > 11)
  {
    error("We've spent enough turns in the Castle's ground floor, but the top floor isn't open.");
    abort("Open the top floor manually and then try this script again.");
  }

  if (ground.turns_spent < 6
      && to_location(get_property("lastAdventure")) == ground
      && have($item[turkey blaster]))
  {
    log("Chewing a " + wrap($item[turkey blaster]) + " to speed up the ground floor.");
    try_chew($item[turkey blaster]);
  }

  if (!have($item[electric boning knife]))
  {
    set_property("choiceAdventure1026", 2); // get the boning knife
  } else {
    set_property("choiceAdventure1026", 3); // skip
  }

  yz_adventure(ground, "items");

}

void spin_garbage_wheel()
{

  if (quest_status("questL10Garbage") != 9
      && have($item[steam-powered model rocketship])) return;


  maximize("",$item[mohawk wig]);

  // steampunk choice
  if (!have($item[steam-powered model rocketship]))
    set_property("choiceAdventure677", 2); // model rocketship
  else if (have($item[model airship]))
    set_property("choiceAdventure677", 1); // complete quest
  else if (have($item[drum 'n' bass 'n' drum 'n' bass record]))
    set_property("choiceAdventure677", 4); // goth choice
  else
    set_property("choiceAdventure677", 1); // pick a fight

  // goth choice
  if (have($item[drum 'n' bass 'n' drum 'n' bass record]))
    set_property("choiceAdventure675", 2); // complete quest
  else
    set_property("choiceAdventure675", 4); // steampunk choice

  // punk choice
  if (have_equipped($item[mohawk wig]))
    set_property("choiceAdventure678", 1); // complete quest
  else
    set_property("choiceAdventure678", 4); // raver choice

  // raver choice
  if (!have($item[drum 'n' bass 'n' drum 'n' bass record]))
    set_property("choiceAdventure676", 3); // get record
  else if (have_equipped($item[mohawk wig]))
    set_property("choiceAdventure676", 4); // punk choice
  else
    set_property("choiceAdventure676", 1); // pick a fight

  set_property("choiceAdventure679", 1); // complete quest

  yz_adventure($location[The Castle in the Clouds in the Sky (Top Floor)]);
}

boolean garbage_loop()
{
  switch(quest_status("questL10Garbage"))
  {
    default:
      warning("I don't know this quest status for the Garbage quest: '" + get_property("questL10Garbage") + "'.");
      return false;
    case UNSTARTED:
      log("Going to the council to get the Garbage quest.");
      council();
      return true;
    case STARTED:
      plant_beanstalk();
      return true;
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
      log("Off to get a " + wrap($item[s.o.c.k.]) + ".");
      get_sock();
      return true;
    case 7:
      if (dangerous($location[The Castle in the Clouds in the Sky (Basement)]))
      {
        info("Skipping " + wrap($location[The Castle in the Clouds in the Sky (Basement)]) + " until it's less dangerous.");
        return false;
      }
      open_ground_floor();
      if (quest_status("questL10Garbage") != 7)
        log("Ground floor of the Castle has been opened.");
      return true;
    case 8:
      if (dangerous($location[The Castle in the Clouds in the Sky (Ground Floor)]))
      {
        info("Skipping " + wrap($location[The Castle in the Clouds in the Sky (Ground Floor)]) + " until it's less dangerous.");
        return false;
      }
      open_top_floor();
      if (quest_status("questL10Garbage") != 8)
        log("Top floor of the Castle has been opened.");
      return true;
    case 9:
      if (dangerous($location[The Castle in the Clouds in the Sky (Top Floor)]))
      {
        info("Skipping " + wrap($location[The Castle in the Clouds in the Sky (Top Floor)]) + " until it's less dangerous.");
        return false;
      }
      spin_garbage_wheel();
      if (quest_status("questL10Garbage") != 9)
        log("Garbage wheel has been spun.");
      return true;
    case 10:
      log("Turning in the Garbage quest to the council.");
      council();
      return true;
    case FINISHED:
      if (!have($item[steam-powered model rocketship]))
      {
        spin_garbage_wheel();
        return true;
      }
      return false;
  }
}

boolean L10_Q_garbage()
{
  if (my_level() < 10)
    return false;
  if (quest_status("questL10Garbage") == FINISHED
      && have($item[steam-powered model rocketship]))
    return false;

  return garbage_loop();
}

void main()
{
  while (L10_Q_garbage());
}
