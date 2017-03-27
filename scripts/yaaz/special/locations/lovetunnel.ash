import 'util/base/print.ash';
import 'util/base/settings.ash';
import 'util/prep/prep.ash';
import 'util/base/maximize.ash';

int tunnel_giftitem();
int tunnel_giftitem(item it);

int tunnel_effect();
int tunnel_effect(effect ef);

int tunnel_statitem();
int tunnel_statitem(stat st);

void lovetunnel();


int tunnel_effect(effect ef)
{
/* Choices:
  1:	Lovebotamy				     	+10 stats per fight
  2:	Open Heart Surgery			+10 familiar weight
  3:	Wandering Eye Surgery		+50% item drops
  4:	Nothing
*/
  switch(ef)
  {
    case $effect[Lovebotamy]:
      return 1;
    case $effect[Open Heart Surgery]:
      return 2;
    case $effect[Wandering Eye Surgery]:
      return 3;
    case $effect[none]:
      return 4;
    default:
      error("Effect " + wrap(ef) + " doesn't exist in the " + wrap("LOVE Tunnel", COLOR_LOCATION) + ".");
      return 4;
  }
}

int tunnel_effect()
{
  return tunnel_effect($effect[lovebotamy]);
}

int tunnel_statitem(stat st)
{
/* Choices:
  1:		Cardigan,			LOV Eardigan	Shirt - 25% Muscle Stats, 8-12HP Regen, +25ML
  2:		Epaulettes,			LOV Epaulettes	Back  - 25% Myst Stats, 4-6MP Regen, -3MPCombatSkills
  3:		Earrings			LOV Earrings	Acc   - 25% Moxie Stats, +3 PrismRes, +50% Meat
  4:		Nothing
*/
  switch(st)
  {
    case $stat[muscle]:
      return 1;
    case $stat[mysticality]:
      return 2;
    case $stat[moxie]:
      return 3;
    case $stat[none]:
      return 4;
    default:
      error("Stat " + wrap(st) + " doesn't exist in the " + wrap("LOVE Tunnel", COLOR_LOCATION) + ".");
      return 4;
  }
}

int tunnel_statitem()
{
  return tunnel_statitem(my_primestat());
}

int tunnel_giftitem(item it)
{
/* Choices:
  1:		Boomerang			    LOV Enamorang (combat item) stagger, consumed (15 turn later copy?)
  2:		Toy Dart Gun		  LOV Emotionizer (usable self/others)
  3:		Chocolate			    LOV Extraterrestrial Chocolate (+3/2/1 advs, independent chocolate?)
  4:		Flowers			      LOV Echinacea Bouquet (Spleen). (stats + small hp/mp, 1 toxicity)
  5:		Plush Elephant		LOV Elephant (Shield, DR+10)
  6:		Toast. Only with Space Jellyfish?
  7:		Nothing
*/
  switch(it)
  {
    case $item[LOV Enamorang]:
      return 1;
    case $item[lov emotionizer]:
      return 2;
    case $item[LOV Extraterrestrial Chocolate]:
      return 3;
    case $item[LOV Echinacea Bouquet]:
      return 4;
    case $item[LOV Elephant]:
      return 5;
    case $item[toast]:
      if (have_familiar($familiar[space jellyfish]))
        return 6;
      warning("Trying to get " + wrap(it) + " from the " + wrap("LOVE Tunnel", COLOR_LOCATION) + " but you don't have a " + wrap($familiar[space jellyfish]) + ".");
      return tunnel_giftitem();
    case $item[none]:
      return 7;
    default:
      error("Item " + wrap(it) + " doesn't exist in the " + wrap("LOVE Tunnel", COLOR_LOCATION) + ".");
      return 4;
  }
}

int tunnel_giftitem()
{
//  Do we want to consider toast if we have the jellyfish?
//  if (have_familiar($familiar[space jellyfish]))
//    return tunnel_giftitem($item[toast]);

  return tunnel_giftitem($item[lov enamorang]);
}

void lovetunnel()
{
  if (!to_boolean(get_property("loveTunnelAvailable")))
    return;
  if (to_boolean(get_property("_loveTunnelUsed")))
    return;

  // should add some nuance to this...
  boolean fight_fight_fight = my_level() > 4;

  if (fight_fight_fight)
  {
    prep();
    maximize();
  }

  string tun = visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel");
	if (contains_text(tun, "Come back tomorrow!"))
	{
		warning("Already visited L.O.V.E. Tunnel, but I just tried to again.");
		tun = visit_url("choice.php?pwd=&whichchoice=1222&option=2");
    set_property("_loveTunnelUsed", "true");
		return;
	}

  tun = visit_url("choice.php?pwd=&whichchoice=1222&option=1");


  if(fight_fight_fight)
  {
    tun = visit_url("choice.php?pwd=&whichchoice=1223&option=1");
    run_combat('yz_consult');
  }
  else
  {
    tun = visit_url("choice.php?pwd=&whichchoice=1223&option=2");
  }

  tun = visit_url("choice.php?pwd=&whichchoice=1224&option=" + tunnel_statitem());

  if(fight_fight_fight)
	{
		tun = visit_url("choice.php?pwd=&whichchoice=1225&option=1");
    run_combat('yz_consult');
	}
	else
	{
		tun = visit_url("choice.php?pwd=&whichchoice=1225&option=2");
	}

  tun = visit_url("choice.php?pwd=&whichchoice=1226&option=" + tunnel_effect());

  if(fight_fight_fight)
	{
		tun = visit_url("choice.php?pwd=&whichchoice=1227&option=1");
    run_combat('yz_consult');
	}
	else
	{
		tun = visit_url("choice.php?pwd=&whichchoice=1227&option=2");
	}

	tun = visit_url("choice.php?pwd=&whichchoice=1228&option=" + tunnel_giftitem());


}

void main()
{
  lovetunnel();
}
