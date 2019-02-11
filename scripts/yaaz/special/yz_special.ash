import 'special/items/yz_batfellow_comic.ash';
import 'special/items/yz_deck.ash';
import 'special/items/yz_geniebottle.ash';
import 'special/items/yz_january_garbage.ash';
import 'special/items/yz_lattemug.ash';
import 'special/items/yz_manuel.ash';
import 'special/items/yz_kgb.ash';
import 'special/items/yz_pantogram.ash';
import 'special/items/yz_protonic.ash';
import 'special/items/yz_sausage.ash';
import 'special/items/yz_sealfigurines.ash';
import 'special/items/yz_timespinner.ash';
import 'special/locations/yz_bookshelf.ash';
import 'special/locations/yz_barrelgod.ash';
import 'special/locations/yz_chateau.ash';
import 'special/locations/yz_clanvip.ash';
import 'special/locations/yz_daycare.ash';
import 'special/locations/yz_precinct.ash';
import 'special/locations/yz_teatree.ash';
import 'special/locations/yz_terminal.ash';
import 'special/locations/yz_thanksgarden.ash';
import 'special/locations/yz_vip_floundry.ash';
import 'special/locations/yz_vip_fortune.ash';
import 'special/skills/yz_communism.ash';
import 'special/skills/yz_numberology.ash';
import 'special/skills/yz_perfect_freeze.ash';
import 'special/skills/yz_rethinkcandy.ash';
import 'special/skills/yz_summon_annoyance.ash';

boolean[string] SPECIAL_LIST = $strings[january_garbage,
                                        pantogram,
                                        bookshelf,
                                        sausage,
                                        barrelgod,
                                        communism,
                                        teatree,
                                        clanvip,
                                        vip_floundry,
                                        vip_fortune,
                                        summon_annoyance,
                                        perfect_freeze,
                                        numberology,
                                        thanksgarden,
                                        terminal,
                                        sealfigurines,
                                        deck,
                                        lattemug,
                                        precinct,
                                        timespinner,
                                        kgb,
                                        geniebottle,
                                        daycare,
                                        batfellow_comic,
                                        manuel];


void special()
{

  foreach special_thing in SPECIAL_LIST
  {
    current_quest = special_thing;
    call special_thing();
  }
  current_quest = "";

}

void main()
{
  special();
}
