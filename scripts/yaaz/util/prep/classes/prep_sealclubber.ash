void prep_sealclubber(location loc)
{
  if (my_class() != $class[seal clubber]) return;

}

void prep_sealclubber()
{
  prep_sealclubber($location[none]);

  // ... class specific stuff ...

}

void main()
{
  prep_sealclubber();
}
