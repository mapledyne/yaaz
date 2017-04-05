import "util/base/print.ash";

log("Below are some known issues and work planned for the " + wrap("yaaz", COLOR_ITEM) + " script.");
log("");

log("Known issues:");
task("[war] No current support for " + wrap($location[McMillicancuddy's Farm]) + ".");
task("[war] Nun support presumes you're fighting as a fratboy.");
task("[war] War support generally assumes you're a fratboy and makes some poor assumptions when not.");
task("Low skill, low level can be hard on the script (< level 5).");
task("The Hedge Maze generally assumes you can take the faster path. If you can't, it may hurt.");
log("");

log("Planned features:");
task("Progress sheet should highlight the active bar so it's easier to catch as it scrolls by.");
task("Autodetect PvP season changes and alter accordingly instead of a manual recode each season.");
task("More aggressively sell combat items and consumables that likely aren't going to be used.");
task("Better coordination of " + wrap($monster[Writing desk]) + " and " + wrap($monster[snowman assassin]) + " digitizations.");
task("When likely to not need another digitization, digitize something otherwise helpful.");
