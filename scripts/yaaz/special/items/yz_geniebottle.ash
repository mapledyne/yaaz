import "util/base/yz_print.ash";
import "util/base/yz_util.ash";
import "util/base/yz_maximize.ash";
import "util/base/yz_monsters.ash";
import "util/base/yz_settings.ash";
import "util/base/yz_inventory.ash";

void geniebottle_progress()
{
  if (!have($item[genie bottle])) return;
  if (!be_good($item[genie bottle])) return;

  // _genieFightsUsed=0
  // _genieWishesUsed=0

  int wishes = to_int(get_property("_genieWishesUsed"));
  if (wishes >= 3) return;

  progress(wishes, 3, wrap($item[genie bottle]) + " wishes used", "blue");

}

void bottle_wish(string wishingfor)
{
  print("Using the " + wrap($item[genie bottle]) + " to " + wrap(wishingfor, COLOR_ITEM));
  cli_execute("genie " + wishingfor);
}

void bottle_wish(monster mon)
{
  print("Using the " + wrap($item[genie bottle]) + " to fight a " + wrap(mon));
  maximize();
  cli_execute("genie monster " + mon);
  run_combat();
}

boolean can_wish()
{
  if (!have($item[genie bottle])) return false;
  if (!be_good($item[genie bottle])) return false;
  int wishes = to_int(get_property("_genieWishesUsed"));

  if (wishes >= 3) return false;

  return true;
}

void geniebottle()
{
  if (!can_wish()) return;

  if (!have($item[blessed rustproof +2 gray dragon scale mail])
      && have_skill($skill[Torso Awaregness]))
  {
    bottle_wish("wish for a blessed rustproof +2 gray dragon scale mail");
    return;
  }

  // other monsters to consider/add: lobsterfrogman, ninja snowman assassin, dirty theiving brigand?

  if (to_int(get_property("writingDesksDefeated")) < 5
      && !dangerous($monster[writing desk])
      && to_monster(get_property("_sourceTerminalDigitizeMonster")) != $monster[Writing Desk]
      && !have($item[ghost of a necklace]))
  {
    bottle_wish($monster[writing desk]);
    return;
  }

}

void main()
{
  geniebottle();
}
