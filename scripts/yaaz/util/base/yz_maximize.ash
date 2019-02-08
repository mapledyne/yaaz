import "util/base/yz_print.ash";
import "util/base/yz_inventory.ash";
import "util/base/yz_effects.ash";
import "util/base/yz_familiars.ash";
import "util/base/yz_monsters.ash";
import "special/items/yz_january_garbage.ash";
import "special/locations/yz_terminal.ash";
import "special/locations/yz_bookshelf.ash";

void do_maximize(string target, string outfit, item it);
void maximize(string target, string outfit, item it, familiar fam);
void maximize(string target, item it);
void maximize(string target, string outfit, familiar fam);
void maximize(string target, string outfit);
void maximize(string target);
void maximize();
void max_effects(string target);
void max_effects(string target, boolean aggressive);

// protonic accelerator stuff:
void cross_streams(string player);
void cross_streams();

boolean is_spacegate_vaccine(effect vaccine)
{
  return $effects[rainbow vaccine, Broad-Spectrum Vaccine, Emotional Vaccine] contains vaccine;
}

boolean spacegate_vaccine(effect vaccine)
{
  if (get_property("spacegateAlways") != "true") return false;

  int[effect] vaccines;

  vaccines[$effect[rainbow vaccine]] = 1;
  vaccines[$effect[Broad-Spectrum Vaccine]] = 2;
  vaccines[$effect[Emotional Vaccine]] = 3;

  if (!is_spacegate_vaccine(vaccine))
  {
    warning("Trying to use the " + wrap("Spacegate Facility", COLOR_LOCATION) + " to vaccinate for " + wrap(vaccine) + ", but that's not a vaccine.");
    return false;
  }

  if (prop_bool("_spacegateVaccine")) return false;

  return cli_execute('spacegate vaccine ' + vaccines[vaccine]);
}


void cross_streams(string player)
{
  if (!have($item[protonic accelerator pack])) return;
  if (!be_good($item[protonic accelerator pack])) return;
  if (prop_bool("_streamsCrossed")) return;

  if (player == 'ProtonicBot')
  {
    warning("Sure, we can cross streams with " + wrap(player, COLOR_MONSTER) + ", but you could");
    warning("use someone more interesting as well. Find a friend with a " + wrap($item[protonic accelerator pack]));
    warning("(or use " + wrap("Degrassi", COLOR_MONSTER) + "), she's friendly :)");
    warning("To change your default stream crossing buddy:");
    print("set streamCrossDefaultTarget=someone");
    wait(5);
  }

  log("Crossing streams with " + wrap(player, COLOR_MONSTER) + ".");
  cli_execute("crossstreams " + player);
}

void cross_streams()
{
  string p = get_property("streamCrossDefaultTarget");

  cross_streams(p);
}


void do_maximize(string target, string outfit, item it)
{
  string max = target;

  if (outfit != "")
  {
    if (max != "")
    {
      max = max + ", ";
    }
    max = max + "outfit " + outfit;
  }

  if (it != $item[none])
  {
    if (max != "")
    {
      max = max + ", ";
    }
    // converting to their item number here dodges some parsing problems, like
    // items with numbers in their name ('kol con 13 snowglobe', etc).
    max = max + "+equip [" + to_int(it) + "]";
  }

  foreach nope in $items[hilarious comedy prop,
                         training legwarmers,
                         actual reality goggles,
                         red shirt,
                         dorky glasses,
                         ponytail clip]
  {
    if (have(nope))
    {
      if (max != "") max += ", ";
      max += "-equip [" + to_int(nope) + "]";
    }
  }

  info("Maximizing equipment based on: " + max);
  maximize(max, false);
}

string default_maximize_string()
{
  string def = "mainstat, mp regen";

  if (my_primestat() != $stat[mysticality]) def += ", 0.5 hp";
  return def;
}

void maximize(string target, string outfit, item it, familiar fam)
{
//  item default_offhand = $item[9133]; // kol con 13 snowglobe

  item default_offhand = $item[latte lovers member's mug];

  // if we're going with all-defaults, favor the default_offhand as an item
  // it won't ever get picked by the maximizer, but it nice to use sometimes
  // Change: was snowglobe, now latte mug.

  if (target == ""
      && it == $item[none]
      && outfit == ""
      && fam == $familiar[none]
      && have(default_offhand))
  {
    it = default_offhand;
  }


  if (target == '')
    target = default_maximize_string();

// check slot on item since 'effective' can sometimes override explicit "equip" demands of the maximizer.
  if (my_primestat() != $stat[mysticality]
      && to_slot(it) != $slot[weapon])
  {
    if (target != "") target = target + ", ";
    target += "effective";
  }

  // force a weapon in our hands. This compensates for some of the unarmed skills (Master of Surprising Fist)
  // which we should possibly evaluate, but for now just use an actual weapon.
  if (my_path() != "Way of the Surprising Fist"
      && have_skill($skill[Master of the Surprising Fist]))
  {
    if (target != "") target = target + ", ";
    target += "-unarmed";
  }

/*  if (my_primestat() == $stat[muscle]
      && to_slot(it) != $slot[off-hand]
      && outfit == "")
  {
    if (target != "") target = target + ", ";
    target += "+shield";
  }
*/

  // if we're doing the flyers, let's boost ML as we go.
  if (have_flyers() && get_property("sidequestArenaCompleted") == "none")
  {
    if (target != "") target = target + ", ";
    target += "ml";
  }

  string[int] split_map;
  split_map = split_string(target, ", ");

  if (fam != $familiar[none])
    choose_familiar(fam);
  else
    choose_familiar(split_map[0]);

  if (contains_text(target, 'rollover'))
  {
    target = 'adv, pvp fights, -tie';
    familiar pet = to_familiar(setting("100familiar"));
    if (pet != $familiar[none]
        && pet != $familiar[Trick-or-Treating Tot]
        && have_familiar($familiar[Trick-or-Treating Tot]))
    {
      warning("You're trying to do a 100% familiar run (" + wrap(pet) + ").");
      warning("But if you switch to a " + wrap($familiar[Trick-or-Treating Tot]) + " for rollover, you'll get some extra adventures (equip the " + wrap($item[li'l unicorn costume]) + ").");
      warning("Yaaz will automatically switch back before adventuring if you use the script, but you'll want to be careful not to manually adventure. You'll have to make this familiar change manually, but there's little downside if you're careful not to adventure afterwards.");
      wait(3);
    }
  }

  if (add_familiar_weight) max_effects("familiar weight", false);

  do_maximize(target, outfit, it);

  foreach t in split_map
  {
    max_effects(split_map[t]);
  }

  if (familiar_weight(my_familiar()) < 20)
  {
    max_effects("familiar experience", false);
  }
}

void maximize(string target, item it)
{
  maximize(target, "", it, $familiar[none]);
}

void maximize(string target, string outfit, familiar fam)
{
  maximize(target, outfit, $item[none], fam);
}

void maximize(string target, familiar fam)
{
  maximize(target, "", fam);
}

void maximize(string target, item it, familiar fam)
{
  maximize(target, "", it, fam);
}

void maximize(string target, string outfit)
{
  maximize(target, outfit, $familiar[none]);
}

void maximize(string target)
{
  maximize(target, "");
}

void maximize()
{
  maximize("");
}

void max_effects(string target, boolean aggressive)
{
  if (target == "effective") return;
  debug("Maximizing effects based on: " + wrap(target, COLOR_ITEM));
  switch(target)
  {
    case "booze":
      if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
      {
        cli_execute("friars booze");
      }
      break;
    case "exp":
      effect_maintain($effect[proficient pressure]);
      if (!have_colored_tongue())
        effect_maintain($effect[orange tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      switch(my_primestat())
      {
        case $stat[muscle]:
          effect_maintain($effect[browbeaten]);
          effect_maintain($effect[strong resolve]);
          effect_maintain($effect[gummi-grin]);
          break;
        case $stat[moxie]:
          effect_maintain($effect[sepia tan]);
          effect_maintain($effect[flexibili Tea]);
          break;
        case $stat[mysticality]:
          effect_maintain($effect[ready to snap]);
          effect_maintain($effect[innately wise]);
          effect_maintain($effect[Neuroplastici Tea]);
          break;
      }
      break;
    case "stats":
      effect_maintain($effect[mutated]);
      effect_maintain($effect[sealed brain]);
      effect_maintain($effect[slightly larger than usual]);
      effect_maintain($effect[tomato power]);

      if (!prop_bool("concertVisited")
          && get_property("sidequestArenaCompleted") == "fratboy")
      {
        cli_execute("concert elvish");
      }
      cross_streams();
      if (!prop_bool("telescopeLookedHigh")
          && get_campground() contains $item[Discount Telescope Warehouse gift certificate])
      {
        log("Looking in the telescope to get " + wrap($effect[starry-eyed]));
        cli_execute("telescope look high");
      }
      break;
    case "mainstat":
      if (!aggressive) break;
      switch(my_primestat())
      {
        case $stat[muscle]:
          max_effects("muscle");
          break;
        case $stat[moxie]:
          max_effects("moxie");
          break;
        case $stat[mysticality]:
          max_effects("mysticality");
          break;
      }
      if (get_property("_lyleFavored") == "false")
      {
        log("Off to visit Lyle at the monorail.");
        visit_url("place.php?whichplace=monorail&action=monorail_lyle");
      }

      break;
    case "muscle":
      max_effects("stats");
      effect_maintain($effect[Extreme Muscle Relaxation]);
      effect_maintain($effect[Football Eyes]);
      effect_maintain($effect[feroci tea]);
//      effect_maintain($effect[Go Get 'Em\, Tiger!]);
      effect_maintain($effect[spiky hair]);
      effect_maintain($effect[Steroid Boost]);
      effect_maintain($effect[superheroic]);
      effect_maintain($effect[Truly Gritty]);
      effect_maintain($effect[twen tea]);
      effect_maintain($effect[Woad Warrior]);
      if (!have_love_song())
        effect_maintain($effect[broken heart]);
      if (!have_love_song())
        effect_maintain($effect[sweet heart]);

      if (get_property("_daycareSpa") != "true"
          && get_property("daycareOpen") == "true")
      {
        log("Going to the spa for a treatment.");
        cli_execute("daycare muscle");
      }

      break;

    case "moxie":
      max_effects("stats");
      effect_maintain($effect[Newt Gets In Your Eyes]);
      effect_maintain($effect[butt-rock hair]);
      effect_maintain($effect[dexteri tea]);
      effect_maintain($effect[lycanthropy\, eh?]);
      effect_maintain($effect[locks like the raven]);
      effect_maintain($effect[Mysteriously Handsome]);
      effect_maintain($effect[notably lovely]);
      effect_maintain($effect[The Moxious Madrigal]);
      effect_maintain($effect[spiky hair]);
      effect_maintain($effect[Knob Goblin Lust Frenzy]);
      effect_maintain($effect[sugar rush]);
      effect_maintain($effect[twen tea]);
      if (!have_love_song())
        effect_maintain($effect[cold hearted]);
      if (!have_love_song())
        effect_maintain($effect[lustful heart]);
      if (get_property("_daycareSpa") != "true"
          && get_property("daycareOpen") == "true")
      {
        log("Going to the spa for a treatment.");
        cli_execute("daycare moxie");
      }
      use_all($item[rhinestone]);
      break;
    case "mysticality":
      max_effects("stats");
      effect_maintain($effect[baconstoned]);
      effect_maintain($effect[dweeby]);
      effect_maintain($effect[OMG WTF]);
      effect_maintain($effect[moose wisdom]);
      effect_maintain($effect[rainy soul miasma]);
      effect_maintain($effect[ready to snap]);
      effect_maintain($effect[seeing colors]);
      effect_maintain($effect[carrrsmic]);
      effect_maintain($effect[twen tea]);
      effect_maintain($effect[wit tea]);
      effect_maintain($effect[well owl be!]);
      if (!have_love_song())
        effect_maintain($effect[withered heart]);
      if (!have_love_song())
        effect_maintain($effect[fiery heart]);

      uneffect($effect[sugar rush]);

      if (get_property("_daycareSpa") != "true"
          && get_property("daycareOpen") == "true")
      {
        log("Going to the spa for a treatment.");
        cli_execute("daycare mysticality");
      }


      break;
    case "meat":
      effect_maintain($effect[blackberry politeness]);
      effect_maintain($effect[chari tea]);
      effect_maintain($effect[Cranberry Cordiality]);
      effect_maintain($effect[disco leer]);
      effect_maintain($effect[eyes wide propped]);
      effect_maintain($effect[sticky fingers]);
      effect_maintain($effect[polka of plenty]);
      effect_maintain($effect[preternatural greed]);
      effect_maintain($effect[so you can work more...]);
      // Not really ascension relevant:
//      effect_maintain($effect[The Ballad of Richie Thingfinder]);
      effect_maintain($effect[thanksgetting]);
      terminal_enhance($effect[meat.enh]);
      if (!have_colored_tongue())
        effect_maintain($effect[red tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      if (!have_love_song())
        effect_maintain($effect[sweet heart]);
      if (!prop_bool("concertVisited")
          && get_property("sidequestArenaCompleted") == "fratboy")
      {
        cli_execute("checkpoint");
        cli_execute("outfit frat warrior fatigues");
        cli_execute("concert winklered");
        cli_execute("outfit checkpoint");
      }
      effect_maintain($effect[Always be Collecting]);

      if (aggressive)
      {
        effect_maintain($effect[The Inquisitor's Unknown Effect]);
        effect_maintain($effect[wasabi sinuses]);
      }

      if (have($item[SongBoom&trade; BoomBox]))
      {
        int booms = prop_int("_boomBoxSongsLeft");
        if (booms > 0 && get_property("boomBoxSong") != "Total Eclipse of Your Meat")
        {
          cli_execute("boombox meat");
        }
      }
      break;
    case "items":
      effect_maintain($effect[ermine eyes]);
      effect_maintain($effect[eagle eyes]);
      effect_maintain($effect[eye of the seal]);
      effect_maintain($effect[eyes wide propped]);
      effect_maintain($effect[Fat Leon's Phat Loot Lyric]);
//      effect_maintain($effect[hip to the jive]);
      effect_maintain($effect[ocelot eyes]);
      effect_maintain($effect[2091]); // [Sacré Mental]
      effect_maintain($effect[serendipi tea]);
      effect_maintain($effect[singer's faithful ocelot]);
      effect_maintain($effect[The Inquisitor's Unknown Effect]);

      if (aggressive)
      {
        effect_maintain($effect[peeled eyeballs]);
      }


      // Not really ascension relevant:
//      effect_maintain($effect[The Ballad of Richie Thingfinder]);
      effect_maintain($effect[thanksgetting]);
      terminal_enhance($effect[items.enh]);
      if (!have_love_song())
        effect_maintain($effect[withered heart]);
      if (!have_colored_tongue())
        effect_maintain($effect[blue tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      if (!prop_bool("concertVisited")
          && get_property("sidequestArenaCompleted") == "hippy")
      {
        cli_execute("concert dilated pupils");
      }

      break;
    case "init":
      effect_maintain($effect[alacri tea]);
      effect_maintain($effect[all fired up]);
      effect_maintain($effect[adorable lookout]);
      effect_maintain($effect[Hiding in Plain Sight]);
      effect_maintain($effect[Jacked In]);
      effect_maintain($effect[lustful heart]);
      effect_maintain($effect[Sepia Tan]);
      effect_maintain($effect[Song of Slowness]);
      effect_maintain($effect[Springy Fusilli]);
      effect_maintain($effect[sugar rush]);
      effect_maintain($effect[suspicious gaze]);
      effect_maintain($effect[Ticking Clock]);
      effect_maintain($effect[twen tea]);
      effect_maintain($effect[the glistening]);
      effect_maintain($effect[Walberg\'s Dim Bulb]);
      effect_maintain($effect[well-swabbed ear]);
      effect_maintain($effect[The Inquisitor's Unknown Effect]);

      terminal_enhance($effect[init.enh]);
      if (!prop_bool("concertVisited")
          && get_property("sidequestArenaCompleted") == "fratboy")
      {
        cli_execute("concert white-boy angst");
      }
      if (!have_love_song())
        effect_maintain($effect[lustful heart]);
      if (get_property("_daycareSpa") != "true"
          && get_property("daycareOpen") == "true")
      {
        log("Going to the spa for a treatment.");
        cli_execute("daycare moxie");
      }


      break;
    case "-combat":
      effect_maintain($effect[gummed shoes]);
      effect_maintain($effect[Fresh Scent]);
      effect_maintain($effect[Smooth Movements]);
      effect_maintain($effect[The Sonata of Sneakiness]);
      effect_maintain($effect[Shelter of Shed]);
      effect_maintain($effect[obscuri tea]);
      uneffect($effect[Carlweather's Cantata of Confrontation]);

      effect_maintain($effect[Become Superficially interested]);
      break;
    case "combat":
      effect_maintain($effect[musk of the moose]);
      effect_maintain($effect[Carlweather's Cantata of Confrontation]);
      effect_maintain($effect[hippy stench]);
      effect_maintain($effect[irritabili tea]);
      effect_maintain($effect[High Colognic]);
      effect_maintain($effect[lion in ambush]);
      uneffect($effect[The Sonata of Sneakiness]);
      effect_maintain($effect[Become Intensely interested]);
      break;
    case "ml":
      // MCD handled by prep()
      effect_maintain($effect[ashen burps]);
      effect_maintain($effect[Drescher's Annoying Noise]);
      effect_maintain($effect[tortious]);
      effect_maintain($effect[eau d'enmity]);
      effect_maintain($effect[high colognic]);
      effect_maintain($effect[mediocri tea]);
      effect_maintain($effect[Mysteriously Handsome]);
      effect_maintain($effect[pride of the puffin]);
      effect_maintain($effect[red lettered]);
      effect_maintain($effect[2092]); //[Sweetbreads Flambé]
      effect_maintain($effect[Ur-Kel's Aria of Annoyance]);
      if (aggressive)
      {
        effect_maintain($effect[Too Noir For Snoir]);
      }
      break;
    case "familiar exp":
      effect_maintain($effect[Blue Swayed]);
      effect_maintain($effect[Curiosity of Br'er Tarrypin]);
      effect_maintain($effect[heart of white]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      if (aggressive)
      {
        if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
        {
          cli_execute("friars familiar");
        }

      }
      break;
    case "familiar weight":
      // consider this, but it's also -10% all stats...
      effect_maintain($effect[empathy]);
      effect_maintain($effect[leash of linguini]);
      effect_maintain($effect[loyal tea]);
      effect_maintain($effect[heart of green]);
      effect_maintain($effect[Over-Familiar With Dactyls]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      if (!have_love_song())
        effect_maintain($effect[cold hearted]);

      if (aggressive)
      {
        effect_maintain($effect[heavy petting]);
        effect_maintain($effect[thanksgetting]);
        effect_maintain($effect[The Inquisitor's Unknown Effect]);
      }

      break;
    case "resistance base":
      effect_maintain($effect[elemental saucesphere]);
      effect_maintain($effect[astral shell]);
      effect_maintain($effect[egged on]);
      effect_maintain($effect[oiled-up]);
      effect_maintain($effect[well-oiled]);
      effect_maintain($effect[spiro gyro]);
      effect_maintain($effect[red door syndrome]);
      effect_maintain($effect[thanksgetting]);
      if (my_familiar() == $familiar[exotic parrot])
      {
        max_effects("familiar weight");
      }
      break;
    case "all res":
      max_effects("cold res");
      max_effects("spooky res");
      max_effects("sleaze res");
      max_effects("stench res");
      max_effects("hot res");
      break;
    case "cold res":
      max_effects("resistance base");
      effect_maintain($effect[insulated trousers]);
      effect_maintain($effect[scarysauce]);
      effect_maintain($effect[toast tea]);
      break;
    case "spooky res":
      max_effects("resistance base");
      effect_maintain($effect[spookypants]);
      effect_maintain($effect[morbidi tea]);
      break;
    case "sleaze res":
      max_effects("resistance base");
      effect_maintain($effect[scarysauce]);
      effect_maintain($effect[proprie tea]);
      break;
    case "stench res":
      max_effects("resistance base");
      effect_maintain($effect[net tea]);
      break;
    case "hot res":
      max_effects("resistance base");
      effect_maintain($effect[frost tea]);
      break;
    case "elemental damage":
      effect_maintain($effect[all glory to the toad]);
      terminal_enhance($effect[damage.enh]);
      break;
    case "hot damage":
      max_effects("elemental damage");
      effect_maintain($effect[heart of orange]);
      effect_maintain($effect[flaming weapon]);
      effect_maintain($effect[flamibili tea]);
      break;
    case "hot spell damage":
      effect_maintain($effect[heart of orange]);
      break;
    case "cold damage":
      effect_maintain($effect[cold hands]);
      effect_maintain($effect[yet tea]);
      effect_maintain($effect[icy glare]);
      max_effects("elemental damage");
      break;
    case "cold spell damage":
      effect_maintain($effect[cold hands]);
      effect_maintain($effect[icy glare]);
      break;
    case "sleaze damage":
      effect_maintain($effect[Amorous]);
      effect_maintain($effect[improprie tea]);
      effect_maintain($effect[sleazy weapon]);
      max_effects("elemental damage");
      break;
    case "sleaze spell damage":
      break;
    case "spooky damage":
      effect_maintain($effect[boo tea]);
      effect_maintain($effect[snarl of the timberwolf]);
      max_effects("elemental damage");
      break;
    case "spooky spell damage":
      break;
    case "stench damage":
      effect_maintain($effect[nas tea]);
      max_effects("elemental damage");
      break;
    case "stench spell damage":
      break;
    case "spell damage":
      effect_maintain($effect[arched eyebrow of the archmage]);
      effect_maintain($effect[OMG WTF]);
      effect_maintain($effect[Puzzle Fury]);
      effect_maintain($effect[twen tea]);
      effect_maintain($effect[well owl be!]);
      break;
    case "critical":
      effect_maintain($effect[notably lovely]);
      break;
    case "damage":
      effect_maintain($effect[aspect of the twinklefairy]);
      effect_maintain($effect[chalky hand]);
      effect_maintain($effect[deadly flashing blade]);
      effect_maintain($effect[engorged weapon]);
      effect_maintain($effect[jackasses' symphony of destruction]);
      effect_maintain($effect[football eyes]);
      effect_maintain($effect[rage of the reindeer]);
      effect_maintain($effect[scowl of the auk]);
      effect_maintain($effect[superheroic]);
      effect_maintain($effect[tenacity of the snapper]);
      effect_maintain($effect[truly gritty]);
      effect_maintain($effect[twen tea]);
      effect_maintain($effect[twinkly weapon]);
//      effect_maintain($effect[ponderous potency]);
      break;
    case "ranged damage":
      effect_maintain($effect[notably lovely]);
      effect_maintain($effect[twen tea]);
      break;
    case "pool skill":
      effect_maintain($effect[chalky hand]);
      effect_maintain($effect[chalked weapon]);
      break;
    default:
      if (!have_colored_tongue())
        effect_maintain($effect[orange tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[purple tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      if (!have_love_song())
        effect_maintain($effect[fiery heart]);
      if (!have_love_song())
        effect_maintain($effect[broken heart]);
      break;
  }

}

void max_effects(string target)
{
  max_effects(target, false);
}
