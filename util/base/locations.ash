import "util/base/util.ash";

boolean location_open(location l)
{
  switch (l)
  {
    case $location[the old landfill]:
      return (quest_status("questM19Hippy") != UNSTARTED);
    case $location[madness bakery]:
      return (quest_status("questM25Armory") != UNSTARTED);
    case $location[the overgrown lot]:
      return (quest_status("questM24Doc") != UNSTARTED);
    default:
      return true;
  }
}
