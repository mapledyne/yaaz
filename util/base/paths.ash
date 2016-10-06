boolean can_make_wine_bomb()
{
  if (my_path() == "Way of the Suprising Fist"
      || my_path() == "Nuclear Autumn")
    return false;
  return true;
}
