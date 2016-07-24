import "util/main.ash";

log("Doing basic cleanup.");
prep($location[none]);
log("Checking for any future quest requirements.");
build_requirements();
log("Cleanup complete.");
