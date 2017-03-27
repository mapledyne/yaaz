import 'special/locations/chateau.ash';
import 'special/locations/floundry.ash';
import 'special/locations/lovetunnel.ash';
import 'special/locations/teatree.ash';
import 'special/locations/terminal.ash';
import 'special/skills/eldritchhorror.ash';
import 'special/skills/numberology.ash';
import 'special/skills/rethinkcandy.ash';
import 'special/items/timespinner.ash';
import 'special/items/protonic.ash';

void special()
{
  teatree();

  floundry();

  lovetunnel();

  timespinner();

  // better done in prep() since we want to check more often:
  //numberology();
  //protonic();

  terminal();

  chateau();

  eldritchhorror();
}

void main()
{
  special();
}
