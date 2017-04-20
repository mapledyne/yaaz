import "quests/M_misc.ash";
import "quests/M_dailydungeon.ash";
import "quests/M_guild.ash";
import "quests/M_hidden_temple.ash";
import "quests/M_8bit.ash";
import "quests/M_desert_beach.ash";
import "quests/M_pirates.ash";
import "quests/M_spookyraven.ash";
import "quests/M_untinker.ash";
import "quests/M06_pandemonium.ash";
import "quests/M09_leaflet.ash";
import "quests/M10_star_key.ash";
import "quests/M20_necklace.ash";

import "quests/L02_Q_larva.ash";
import "quests/L03_Q_rats.ash";
import "quests/L04_Q_bats.ash";
import "quests/L05_Q_goblin.ash";
import "quests/L06_Q_friar.ash";
import "quests/L07_Q_cyrpt.ash";
import "quests/L08_Q_trapper.ash";
import "quests/L09_Q_topping.ash";
import "quests/L10_Q_Garbage.ash";
import "quests/L11_Q_macguffin.ash";
import "quests/L12_Q_war.ash";
import "quests/L13_Q_sorceress.ash";

import "quests/M_level_up.ash";


// Important: The ordering of the quests in this lists is the order that the
// loop will try the quests. If you want to order quests differently, change it here.
// Note that some quests will skip themselves and let a later quest do work if it's
// waiting on something (arena quests waiting for flyers, for instance).
boolean[string] QUEST_LIST = $strings[M_misc,
                                      M_guild,
                                      M_untinker,
                                      M_desert_beach,
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
