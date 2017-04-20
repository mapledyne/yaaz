import "util/main.ash";

void M09_leaflet_cleanup()
{

}

boolean M09_leaflet()
{
	if (my_level() < 9
	    || have($item[Giant Pinky Ring]))
		return false;

	if (my_class() == $class[Ed]) return false;

	if (get_campground() contains $item[Frobozz Real-Estate Company Instant House (TM)])
		return false;

  if (!have($item[strange leaflet]))
  {
    log("Going to pick up a " + wrap($item[strange leaflet]) + ".");
    council();
  }

  log("Heading off to do the " + wrap($item[strange leaflet]) + " quest.");
	cli_execute("leaflet");
	return true;
}

void main()
{
  while(M09_leaflet());
}
