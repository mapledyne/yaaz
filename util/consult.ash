import "util/monsters.ash";

void main(int round, monster foe, string page)
{
  if (ghosts contains foe && have_equipped($item[protonic accelerator pack]))
  {
    use_skill(1, $skill[shoot ghost]);
    use_skill(1, $skill[shoot ghost]);
    use_skill(1, $skill[shoot ghost]);
    use_skill(1, $skill[trap ghost]);
  }
}
