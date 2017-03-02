import 'special/locations/lovetunnel.ash';
import 'special/skills/numberology.ash';
import 'special/items/timespinner.ash';
import 'special/items/protonic.ash';
void special()
{
  lovetunnel();

  timespinner();

  // better done in prep() since we want to check more often:
  //numberology();
  //protonic();
}

void main()
{
  special();
}
