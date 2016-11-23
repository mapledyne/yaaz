import "util/base/print.ash";
import "util/base/inventory.ash";
import "util/base/effects.ash";
import "util/base/familiars.ash";
import "util/iotm/terminal.ash";
import "util/iotm/bookshelf.ash";
import "util/iotm/protonic.ash";

void do_maximize(string target, string outfit, item it);
void maximize(string target, string outfit, item it, familiar fam);
void maximize(string target, item it);
void maximize(string target, string outfit, familiar fam);
void maximize(string target, string outfit);
void maximize(string target);
void maximize();
void max_effects(string target);

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
    max = max + "+equip " + it;
  }

  if (max != "")
  {
    max = max + ", ";
  }
  max += "-equip hilarious comedy prop, -equip training legwarmers";

  maximize(max, false);
}

string default_maximize_string()
{
  string def = "mainstat, 0.4 hp  +effective, mp regen";
  if (my_buffedstat($stat[muscle]) > my_buffedstat($stat[moxie]))
  {
    def += ", +shield";
  }
  return def;
}

void maximize(string target, string outfit, item it, familiar fam)
{
  string[int] split_map;
  split_map = split_string(target, ", ");

  if (fam != $familiar[none])
    choose_familiar(fam);
  else
    choose_familiar(split_map[0]);

  if (target == 'rollover')
    target = 'adv, pvp fights';

  if (target == 'noncombat')
    target = '-combat';

  if (target == '')
    target = default_maximize_string();

  do_maximize(target, outfit, it);

  foreach t in split_map
  {
    max_effects(split_map[t]);
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

void max_effects(string target)
{
  switch(target)
  {
    case "stats":
      effect_maintain($effect[mutated]);
      effect_maintain($effect[sealed brain]);
      effect_maintain($effect[slightly larger than usual]);
      effect_maintain($effect[tomato power]);

      if (!to_boolean(get_property("concertVisited"))
          && get_property("sidequestArenaCompleted") == "fratboy")
      {
        cli_execute("concert elvish");
      }
      cross_streams();
      break;
    case "muscle":
      effect_maintain($effect[Extreme Muscle Relaxation]);
      effect_maintain($effect[Football Eyes]);
      effect_maintain($effect[feroci tea]);
//      effect_maintain($effect[Go Get 'Em\, Tiger!]);
      effect_maintain($effect[spiky hair]);
      effect_maintain($effect[Steroid Boost]);
      effect_maintain($effect[superheroic]);
      effect_maintain($effect[Truly Gritty]);
      effect_maintain($effect[Woad Warrior]);
      break;
    case "moxie":
      effect_maintain($effect[Newt Gets In Your Eyes]);
      effect_maintain($effect[butt-rock hair]);
      effect_maintain($effect[dexteri tea]);
      effect_maintain($effect[lycanthropy\, eh?]);
      effect_maintain($effect[The Moxious Madrigal]);
      effect_maintain($effect[spiky hair]);
      effect_maintain($effect[Knob Goblin Lust Frenzy]);
      effect_maintain($effect[sugar rush]);
      break;
    case "mysticality":
      max_effects("stats");
      effect_maintain($effect[baconstoned]);
      effect_maintain($effect[dweeby]);
      effect_maintain($effect[moose wisdom]);
      effect_maintain($effect[rainy soul miasma]);
      effect_maintain($effect[seeing colors]);
      effect_maintain($effect[carrrsmic]);
      effect_maintain($effect[wit tea]);

      uneffect($effect[sugar rush]);

      break;
    case "meat":
      effect_maintain($effect[chari tea]);
      effect_maintain($effect[polka of plenty]);
      terminal_enhance($effect[meat.enh]);
      if (!have_colored_tongue())
        effect_maintain($effect[red tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      break;
    case "items":
      effect_maintain($effect[eye of the seal]);
      effect_maintain($effect[ermine eyes]);
      effect_maintain($effect[Fat Leon's Phat Loot Lyric]);
      effect_maintain($effect[ocelot eyes]);
      effect_maintain($effect[peeled eyeballs]);
      effect_maintain($effect[serendipi tea]);
      effect_maintain($effect[singer's faithful ocelot]);
      effect_maintain($effect[withered heart]);
      terminal_enhance($effect[items.enh]);
      if (!have_colored_tongue())
        effect_maintain($effect[blue tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      break;
    case "init":
      effect_maintain($effect[alacri tea]);
      effect_maintain($effect[all fired up]);
      effect_maintain($effect[adorable lookout]);
      effect_maintain($effect[Hiding in Plain Sight]);
      effect_maintain($effect[lustful heart]);
      effect_maintain($effect[Sepia Tan]);
      effect_maintain($effect[Song of Slowness]);
      effect_maintain($effect[Springy Fusilli]);
      effect_maintain($effect[sugar rush]);
      effect_maintain($effect[Ticking Clock]);
      effect_maintain($effect[the glistening]);
      effect_maintain($effect[Walberg\'s Dim Bulb]);
      effect_maintain($effect[well-swabbed ear]);
      terminal_enhance($effect[init.enh]);
      if (!to_boolean(get_property("concertVisited"))
          && get_property("sidequestArenaCompleted") == "fratboy")
      {
        cli_execute("concert white-boy angst");
      }
      break;
    case "-combat":
    case "noncombat":
      effect_maintain($effect[Fresh Scent]);
      effect_maintain($effect[Smooth Movements]);
      effect_maintain($effect[The Sonata of Sneakiness]);
      effect_maintain($effect[Shelter of Shed]);
      effect_maintain($effect[obscuri tea]);
      uneffect($effect[Carlweather's Cantata of Confrontation]);
      break;
    case "combat":
      effect_maintain($effect[musk of the moose]);
      effect_maintain($effect[Carlweather's Cantata of Confrontation]);
      effect_maintain($effect[hippy stench]);
      effect_maintain($effect[irritabili tea]);
      effect_maintain($effect[High Colognic]);
      uneffect($effect[The Sonata of Sneakiness]);
      break;
    case "ml":
      effect_maintain($effect[Drescher's Annoying Noise]);
      effect_maintain($effect[pride of the puffin]);
      effect_maintain($effect[tortious]);
      effect_maintain($effect[eau d'enmity]);
      effect_maintain($effect[high colognic]);
      effect_maintain($effect[mediocri tea]);
      change_mcd(10);
      break;
    case "familiar exp":
      effect_maintain($effect[Blue Swayed]);
      effect_maintain($effect[Curiosity of Br'er Tarrypin]);
      effect_maintain($effect[heart of white]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
      {
        cli_execute("friars familiar");
      }
      break;
    case "familiar weight":
      // consider this, but it's also -10% all stats...
      // effect_maintain($effect[heavy petting]);
      effect_maintain($effect[empathy]);
      effect_maintain($effect[loyal tea]);
      effect_maintain($effect[heart of green]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[black tongue]);
      break;
    case "resistance base":
      effect_maintain($effect[elemental saucesphere]);
      effect_maintain($effect[astral shell]);
      effect_maintain($effect[oiled-up]);
      effect_maintain($effect[well-oiled]);
      effect_maintain($effect[spiro gyro]);
      effect_maintain($effect[red door syndrome]);
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
      max_effects("elemental damage");
      break;
    case "cold spell damage":
      effect_maintain($effect[cold hands]);
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

    default:
      if (!have_colored_tongue())
        effect_maintain($effect[orange tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[purple tongue]);
      if (!have_colored_tongue())
        effect_maintain($effect[green tongue]);
      break;
  }

}
