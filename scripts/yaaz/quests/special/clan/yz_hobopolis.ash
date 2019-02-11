import "util/yz_main.ash";

void hobopolis_progress()
{

}

void hobopolis_cleanup()
{
  if (!prop_bool("_bagOfCandyUsed") && have($item[chester's bag of candy]))
  {
    log("Using " + wrap($item[chester's bag of candy]));
    use(1, $item[chester's bag of candy]);
  }
}

boolean hobopolis()
{
  return false;
}