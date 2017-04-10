void prep_sauceror(location loc)
{
  if (my_class() != $class[sauceror]) return;

}

void prep_sauceror()
{
  prep_sauceror($location[none]);
}

void main()
{
  prep_sauceror();
}
