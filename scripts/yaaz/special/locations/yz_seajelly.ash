import "util/base/yz_util.ash";
import "util/base/yz_locations.ash";

void seajelly_progress()
{

}

void seajelly()
{
  if (my_level() < 11) return;
  if (!can_access_sea()) return;
  if (prop_bool("_seaJellyHarvested")) return;
  if (!have_familiar($familiar[Space Jellyfish])) return;
  if (!be_good($familiar[Space Jellyfish])) return;

  if (quest_status("questS01OldGuy") == UNSTARTED) return;

  use_familiar($familiar[space jellyfish]);
  log("Going to get some " + wrap($item[sea jelly]));
  visit_url("place.php?whichplace=thesea&action=thesea_left2");
  visit_url("choice.php?whichchoice=1219&option=1");
}

void main()
{
  seajelly();
}
