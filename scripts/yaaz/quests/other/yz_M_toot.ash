
void M_toot_progress()
{

}

void M_toot_cleanup()
{

}

boolean M_toot()
{
  // is there a better way to determine if we should visit here?
  if (quest_status("questL02Larva") == UNSTARTED && my_level() > 1)
  {
    log("Visiting " + wrap("The Toot Oriole", COLOR_LOCATION) + " to kick things off.");
    visit_url("tutorial.php?action=toot");
    council();
  }
  return false;
}

void main()
{
  while(M_toot());
}
