import "quests/other/yz_M_bounty.ash";
import "quests/other/yz_M_dailydungeon.ash";
import "quests/other/yz_M_guild.ash";
import "quests/other/yz_M_hidden_temple.ash";
import "quests/other/yz_M_8bit.ash";
import "quests/other/yz_M_desert_beach.ash";
import "quests/other/yz_M_island.ash";
import "quests/other/yz_M_lights_out.ash";
import "quests/other/yz_M_pirates.ash";
import "quests/other/yz_M_spookyraven.ash";
import "quests/other/yz_M_super_villain_lair.ash";
import "quests/other/yz_M_toot.ash";
import "quests/other/yz_M_untinker.ash";
import "quests/other/yz_M06_pandemonium.ash";
import "quests/other/yz_M09_leaflet.ash";
import "quests/other/yz_M10_star_key.ash";
import "quests/other/yz_M20_necklace.ash";

import "quests/council/yz_L02_Q_larva.ash";
import "quests/council/yz_L03_Q_rats.ash";
import "quests/council/yz_L04_Q_bats.ash";
import "quests/council/yz_L05_Q_goblin.ash";
import "quests/council/yz_L06_Q_friar.ash";
import "quests/council/yz_L07_Q_cyrpt.ash";
import "quests/council/yz_L08_Q_trapper.ash";
import "quests/council/yz_L09_Q_topping.ash";
import "quests/council/yz_L10_Q_garbage.ash";
import "quests/council/yz_L11_Q_macguffin.ash";
import "quests/council/yz_L12_Q_war.ash";
import "quests/council/yz_L13_Q_sorceress.ash";

import "quests/other/yz_M_level_up.ash";

import 'quests/special/items/yz_protonic.ash';
import 'quests/special/items/yz_tuxedo_shirt.ash';
import 'quests/special/locations/yz_chateau.ash';
import 'quests/special/locations/yz_deep_machine_tunnels.ash';
import 'quests/special/locations/yz_lovetunnel.ash';
import 'quests/special/locations/yz_snojo.ash';
import 'quests/special/locations/yz_witchess.ash';
import 'quests/special/skills/yz_numberology.ash';

// Important: The ordering of the quests in this lists is the order that the
// loop will try the quests. If you want to order quests differently, change it here.
// Note that some quests will skip themselves and let a later quest do work if it's
// waiting on something (arena quests waiting for flyers, for instance).
boolean[string] QUEST_LIST = $strings[tuxedo_shirt,
                                      numberology,
                                      snojo,
                                      dmt,
                                      protonic,
                                      lovetunnel,
                                      witchess,
                                      chateau,
                                      M_lights_out,
                                      M_toot,
                                      M_super_villain_lair,
                                      M_bounty,
                                      M_guild,
                                      M_untinker,
                                      M_desert_beach,
                                      M_island,
                                      M06_pandemonium,
                                      M09_leaflet,
                                      M_dailydungeon,
                                      M20_necklace,
                                      L05_Q_goblin,
                                      L06_Q_friar,
                                      L12_Q_war,
                                      L08_Q_trapper,
                                      M_hidden_temple,
                                      M_spookyraven,
                                      M_pirates,
                                      L02_Q_larva,
                                      L03_Q_rats,
                                      L04_Q_bats,
                                      L07_Q_cyrpt,
                                      L09_Q_topping,
                                      L10_Q_garbage,
                                      L11_Q_macguffin,
                                      M_8bit,
                                      M10_star_key,
                                      L13_Q_sorceress,
                                      M_level_up];
