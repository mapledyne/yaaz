boolean can_make_wine_bomb()
{
  if (my_path() == "Way of the Surprising Fist"
      || my_path() == "Nuclear Autumn")
    return false;
  return true;
}

int max_drink_size()
{
  switch (my_path())
  {
    case "Nuclear Autumn":
      return 1;
    case "Gelatinous Noob":
      return 0;
  }
  return 100;
}
