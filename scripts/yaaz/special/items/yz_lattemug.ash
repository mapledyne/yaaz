import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";
import "util/base/yz_settings.ash";

/*

ancient
Unlock in The Mouldering Mansion
Spooky Damage: 50

basil
Unlock in The Overgrown Lot
HP Regen Min: 5, HP Regen Max: 5

butternut
Unlock in Madness Bakery
Spell Damage: 10

cajun
Unlock in The Black Forest
Meat Drop: 40

carrot
Unlock in The Dire Warren
Item Drop: 20


chili
Unlock in The Haunted Kitchen
Hot Resistance: 3

cloves
Unlock in The Sleazy Back Alley
Stench Resistance: 3

coal
Unlock in The Haunted Boiler Room
Hot Damage: 25

cocoa
Unlock in The Icy Peak
Cold Resistance: 3

diet
Unlock in Battlefield (No Uniform)
Initiative: 50

dyspepsi
Unlock in TBC
Initiative: 25

filth
Unlock in The Feeding Chamber
Damage Reduction: 20

flour
Unlock in The Road to the White Citadel
Sleaze Resistance: 3

fungus
Unlock in The Fungal Nethers
Maximum MP: 30



hellion
Unlock in The Dark Neck of the Woods
PvP Fights: 6

greek
Unlock in Wartime Frat House (Hippy Disguise)
Sleaze Damage: 25

grobold
Unlock in The Old Rubee Mine
Sleaze Damage: 25

guarna
Unlock in The Bat Hole EntranceA
dventures: 4

gunpowder
Unlock in 1st Floor, Shiawase-Mitsuhama Building
Weapon Damage: 50

hobo
Unlock in Hobopolis Town Square
Damage Absorption: 50

kombucha
Unlock in Wartime Hippy Camp (Frat Disguise)
Stench Damage: 25

lihc
Unlock in The Defiled Niche
Spooky Damage: 25

lizard
Unlock in The Arid, Extra-Dry Desert
MP Regen Min: 5, MP Regen Max: 15

mold
Unlock in The Unquiet Garves
Spooky Damage: 20

msg
Unlock in The Briniest Deepests
Critical Hit Percent: 15


norwhal
Unlock in The Ice Hole
Maximum HP Percent: 200

oil
Unlock in The Old Landfill
Sleaze Damage: 20

rawhide
Unlock in The Spooky Forest
Familiar Weight: 5

rock
Unlock in The Brinier Deepers
Critical Hit Percent: 10

salt
Unlock in The Briny Deeps
Critical Hit Percent: 5


squamous
Unlock in The Caliginous Abyss
Spooky Resistance: 3

teeth
Unlock in The VERY Unquiet Garves
Spooky Damage: 25, Weapon Damage: 25


venom
Unlock in The Middle Chamber
Weapon Damage: 25

vitamins
Unlock in The Dark Elbow of the Woods
Experience (familiar): 3

wing
Unlock in The Dark Heart of the Woods
Combat Rate: 10
*/


void lattemug_progress()
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;
  int refills = prop_int("_latteRefillsUsed");

  string drink = UNCHECKED;
  string copy = UNCHECKED;
  string banish = UNCHECKED;

  if (to_boolean(get_property("_latteCopyUsed"))) copy = CHECKED;
  if (to_boolean(get_property("_latteDrinkUsed"))) drink = CHECKED;
  if (to_boolean(get_property("_latteBanishUsed"))) banish = CHECKED;

  progress(refills, 3, "Refills on your " + wrap($item[latte lovers member's mug]) + " (" + banish + " banish, " + copy + " copy, " + drink + " drink)", "blue");

}

boolean[string] latte_unlocked()
{
  boolean[string] ingreds;

  string[int] things = split_string(get_property("latteUnlocks"), ",");
  foreach one in things
  {
    ingreds[things[one]] = true;
  }
  return ingreds;
}

boolean have_ingred(string ing)
{
  boolean[string] unlocked = latte_unlocked();
  return (unlocked contains ing);
}

boolean is_latte_location(location here)
{

  switch(here)
  {
    case $location[whitey's grove]:
      return !have_ingred('belgium');
    case $location[the bugbear pen]:
      return !have_ingred('bug-thistle');
    case $location[Cobb's Knob Barracks]:
      return !have_ingred('greasy');
    case $location[Cobb's Knob Laboratory]:
      return !have_ingred('mega');
    case $location[The Stately Pleasure Dome]:
      return !have_ingred('paradise');
    case $location[Noob Cave]:
      return !have_ingred('sandalwood');
    case $location[Cobb's Knob Kitchens]:
      return !have_ingred('sausage');
    case $location[The Hole in the Sky]:
      return !have_ingred('space');

  }
  return false;
}


string latte_ingredients(boolean[string] yum)
{
  int[string] choices;

  boolean[string] unlocked = latte_unlocked();

  int[3] scores;
  string[3] flavors;

  scores[0] = 10;
  scores[1] = 10;
  scores[2] = 10;
  flavors[0] = 'vanilla'; // Experience (Muscle): 1, Muscle Percent: 5, Weapon Damage: 5
  flavors[1] = 'pumpkin'; // Experience (Mysticality): 1, Mysticality Percent: 5, Spell Damage: 5
  flavors[2] = 'cinnamon'; // Experience (Moxie): 1, Moxie Percent: 5, Pickpocket Chance: 5

  choices['belgian'] = 50;     // Muscle Percent: 20, Mysticality Percent: 20, Moxie Percent: 20
  choices['bug-thistle'] = 20; // Mysticality: 20
  choices['dwarf'] = 30;       // Muscle: 30
  choices['greasy'] = 40;      // Muscle Percent: 50
  choices['mega'] = 40;        // Moxie Percent: 50
  choices['paradise'] = 30;    // Muscle: 20, Mysticality: 20, Moxie: 20
  choices['sandalwood'] = 12;  // Muscle: 5, Mysticality: 5, Moxie: 5
  choices['sausage'] = 40;     // Mysticality Percent: 50
  choices['space'] = 20;       // Muscle: 10, Mysticality: 10, Moxie: 10

  choices['squash'] = 30;      // Spell Damage: 20
  choices['paint'] = 70;       // Cold Damage: 5, Hot Damage: 5, Sleaze Damage: 5, Spooky Damage: 5, Stench Damage: 5
  choices['chalk'] = 60;       // Cold Damage: 25

  choices['noodles'] = 11;     // Maximum HP: 20
  choices['healing'] = 30;     // HP Regen Min: 10, HP Regen Max: 20
  choices['grass'] = 11;       // Experience: 3
  choices['carrrdamom'] = 40;  // MP Regen Min: 4, MP Regen Max: 6

  // Should find a way to better calculate this in...
  choices['ink'] = 11;         //  Combat Rate: -10

  switch(my_primestat())
  {
    case $stat[muscle]:
      scores[0] = scores[0]* 1.1;
      choices['dwarf'] = choices['dwarf'] * 1.1;
      break;
  }

  // this will put the default 'start' choice of our main stat at the
  // bottom of the replacement list:
  sort flavors by scores[index];
  sort scores by value;

  foreach c in choices
  {
    if (!(unlocked contains c)) continue;
    if (yum contains c) choices[c] = choices[c] * 10;
    
    string ing = c;
    int ing_score = choices[c];
    if (ing_score > scores[0])
    {
      string tmps = flavors[0];
      int tmpi = scores[0];

      scores[0] = ing_score;
      flavors[0] = ing;
      ing = tmps;
      ing_score = tmpi;
    }

    if (ing_score > scores[1])
    {
      string tmps = flavors[1];
      int tmpi = scores[1];

      scores[1] = ing_score;
      flavors[1] = ing;
      ing = tmps;
      ing_score = tmpi;
    }

    if (ing_score > scores[2])
    {
      scores[2] = ing_score;
      flavors[2] = ing;
    }
  }

  return flavors[0] + " " + flavors[1] + " " + flavors[2];

}

void latte_refill(boolean[string] yum)
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;
  int refills = prop_int("_latteRefillsUsed");
  if (refills >= 3) return;

  string ingred = latte_ingredients(yum);
  log("About to refill our " + wrap($item[latte lovers member's mug]) + " with: " + wrap(ingred, COLOR_ITEM));
  cli_execute("latte refill " + ingred);

}

void latte_refill()
{
  latte_refill($strings[none]);
}

void latte_refill(string s)
{
  boolean[string] yum;
  yum[s] = true;
  latte_refill(yum);
}

void lattemug()
{
  if (!have($item[latte lovers member's mug])) return;
  if (!be_good($item[latte lovers member's mug])) return;

  if (!to_boolean(get_property("_latteCopyUsed"))) return;
  if (!to_boolean(get_property("_latteDrinkUsed"))) return;
  if (!to_boolean(get_property("_latteBanishUsed"))) return;

  latte_refill();
}

void main()
{
  lattemug();
}
