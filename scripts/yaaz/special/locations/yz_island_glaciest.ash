
// should this be in the skill area, even though it relates to the island?

void island_glaciest()
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
  island_glaciest();
}
