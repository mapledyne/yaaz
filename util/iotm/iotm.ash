
import "util/iotm/snojo.ash";
import "util/iotm/witchess.ash";
import "util/iotm/terminal.ash";
import "util/iotm/chateau.ash";
import "util/iotm/deck.ash";
import "util/iotm/floundry.ash";
import "util/iotm/bookshelf.ash";
import "util/iotm/precinct.ash";
import "util/iotm/ltt.ash";
import "util/iotm/timespinner.ash";
import "util/iotm/numberology.ash";
import "util/iotm/teatree.ash";
import "util/iotm/island_glaciest.ash";
import "util/iotm/thanksgarden.ash";

void iotm()
{

  // yeah, not an IotM. Unsure a better place to put it for now.
  numberology();
  teatree();

  island_glaciest();

  thanksgarden();

  terminal();

  deck();

  floundry();

  while(libram())
  {
    // cast a few of these
  }

  precinct();

  ltt();

  //protonic(); // better handled in the main (yaaz.ash) loop

  timespinner();

  chateau();

  snojo();

  witchess();
}

void main()
{
  iotm();
}
