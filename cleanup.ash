import "util/main.ash";

void cleanup()
{
  log("Doing basic cleanup.");
  prep($location[none]);
  log("Checking for any future quest requirements.");
  build_requirements();
  log("Cleanup complete.");
}

void main()
{
  cleanup();
}
