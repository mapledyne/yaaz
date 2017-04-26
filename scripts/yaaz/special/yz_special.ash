import 'special/items/yz_batfellow_comic.ash';
import 'special/items/yz_deck.ash';
import 'special/items/yz_protonic.ash';
import 'special/items/yz_timespinner.ash';
import 'special/locations/yz_bookshelf.ash';
import 'special/locations/yz_chateau.ash';
import 'special/locations/yz_clanvip.ash';
import 'special/locations/yz_lovetunnel.ash';
import 'special/locations/yz_ltt.ash';
import 'special/locations/yz_precinct.ash';
import 'special/locations/yz_snojo.ash';
import 'special/locations/yz_teatree.ash';
import 'special/locations/yz_terminal.ash';
import 'special/locations/yz_thanksgarden.ash';
import 'special/locations/yz_witchess.ash';
import 'special/locations/yz_vip_floundry.ash';
import 'special/skills/yz_communism.ash';
import 'special/skills/yz_eldritchhorror.ash';
import 'special/skills/yz_numberology.ash';
import 'special/skills/yz_perfect_freeze.ash';
import 'special/skills/yz_rethinkcandy.ash';
import 'special/skills/yz_summon_annoyance.ash';

void special()
{
  communism();
  teatree();
  vip_floundry();
  ltt();
  timespinner();
  perfect_freeze();
  thanksgarden();
  terminal();
  deck();
  precinct();
  summon_annoyance();
  batfellow_comic();

  // These may actually get us in a fight, so do them after the ones above:

  lovetunnel();
  chateau();
  witchess();
  snojo();
  eldritchhorror();
}

void main()
{
  special();
}
