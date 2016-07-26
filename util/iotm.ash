
import "util/iotm/snojo.ash";
import "util/iotm/witchess.ash";
import "util/iotm/terminal.ash";
import "util/iotm/chateau.ash";

void iotm()
{
  log("Doing default actions with various IotM things, if you have them.");
  snojo();

  witchess();

  chateau();

  terminal();

  deck();
}

void main()
{
  iotm();
}
