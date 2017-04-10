void prep_sealclubber(location loc)
{
  if (my_class() != $class[seal clubber]) return;

}

void prep_sealclubber()
{
  prep_sealclubber($location[none]);
}

void main()
{
  prep_sealclubber();
}
