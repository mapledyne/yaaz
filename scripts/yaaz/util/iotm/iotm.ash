
import "util/iotm/snojo.ash";
import "util/iotm/witchess.ash";
import "util/iotm/deck.ash";
import "util/iotm/bookshelf.ash";
import "util/iotm/precinct.ash";
import "util/iotm/ltt.ash";
import "util/iotm/island_glaciest.ash";
import "util/iotm/thanksgarden.ash";

void iotm()
{
  island_glaciest();

  thanksgarden();

  deck();

  while(libram())
  {
    // cast a few of these
  }

  precinct();

  ltt();

  timespinner();

  snojo();

  witchess();
}

void main()
{
  iotm();
}
