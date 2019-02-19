import "util/base/yz_print.ash";

boolean can_kgb() {
  if (!have($item[Kremlin's Greatest Briefcase])) return false;
  if (!be_good($item[Kremlin's Greatest Briefcase])) return false;
  return true;
}

boolean can_daily_kgb() {
  if (!can_kgb()) return false;

  if (!setting("kgb_complete", "false").to_boolean()) return true;

  return false;
}

void kgb_progress() {
  if (!can_daily_kgb()) return;
}

void kgb_enchant(string enchantments) {
  if (!can_kgb()) return;
  cli_execute("call Briefcase.ash enchantment " + enchantments);
}

void kgb() {
  if (!can_daily_kgb()) return;

  if (!svn_exists("Ezandora-Briefcase-branches-Release")) {
      if (!to_boolean(setting("kgb_svn_warning", "false")))
      {
        save_daily_setting("kgb_svn_warning", "true");
        warning("You have the " + wrap($item[Kremlin's Greatest Briefcase]) + " but I don't know how to automate this.");
        warning("If you install Ezandora's " + wrap("Briefcase", COLOR_ITEM) + " script, I'll call it to automatically do this for you.");
        warning("In the meantime, you'll have to do this yourself, if interested.");
        wait(10);
      }
      return;
  }

  cli_execute("call Briefcase.ash unlock");
  log("Briefcase unlocked.");
  cli_execute("call Briefcase.ash drink");
  log("Briefcase drinks obtained.");
  debug("Pick kgb enchantments more deliberately");
  kgb_enchant("prismatic init -combat");
  save_daily_setting("kgb_complete", "true");
}

void main() {
  kgb();
}
