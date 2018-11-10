// Only wait if we're not speedy

void speedy_wait(int seconds) {
  if (!setting("no_wait", "false").to_boolean()) {
    wait(seconds);
  }
}
