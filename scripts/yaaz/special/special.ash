import 'special/items/deck.ash';
import 'special/items/protonic.ash';
import 'special/items/timespinner.ash';
import 'special/locations/bookshelf.ash';
import 'special/locations/chateau.ash';
import 'special/locations/clanvip.ash';
import 'special/locations/island_glaciest.ash';
import 'special/locations/lovetunnel.ash';
import 'special/locations/ltt.ash';
import 'special/locations/precinct.ash';
import 'special/locations/snojo.ash';
import 'special/locations/teatree.ash';
import 'special/locations/terminal.ash';
import 'special/locations/thanksgarden.ash';
import 'special/locations/witchess.ash';
import 'special/locations/vip_floundry.ash';
import 'special/skills/eldritchhorror.ash';
import 'special/skills/numberology.ash';
import 'special/skills/rethinkcandy.ash';


void special()
{
  teatree();
  vip_floundry();
  ltt();
  timespinner();
  island_glaciest();
  thanksgarden();
  terminal();
  deck();
  precinct();

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
