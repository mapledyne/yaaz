boolean can_make_wine_bomb()
{
  if (my_path() == "Way of the Surprising Fist"
      || my_path() == "Nuclear Autumn")
    return false;
  return true;
}
