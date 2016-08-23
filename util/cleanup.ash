import "util/prep.ash";
import "util/requirements.ash";

void cleanup()
{
  log("Doing basic cleanup.");
  prep();
  log("Checking for any future quest requirements.");
  build_requirements();
  log("Cleanup complete.");
}

void main()
{
  cleanup();
}
