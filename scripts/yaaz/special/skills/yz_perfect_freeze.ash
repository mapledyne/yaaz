
void perfect_freeze_progress()
{

}

void perfect_freeze()
{
  if (have_skill($skill[perfect freeze])
      && !to_boolean(get_property("_perfectFreezeUsed"))
      && my_mp() > 20)
  {
    use_skill(1, $skill[perfect freeze]);
  }
}

void main()
{
  perfect_freeze();
}
