void prep_discobandit(location loc)
{
  if (my_class() != $class[disco bandit]) return;

}

void prep_discobandit()
{
  prep_discobandit($location[none]);
}

void main()
{
  prep_discobandit();
}
