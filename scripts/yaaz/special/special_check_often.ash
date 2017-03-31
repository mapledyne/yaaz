import 'special/items/protonic.ash';
import 'special/locations/bookshelf.ash';
import 'special/skills/numberology.ash';


// stuff we want to check on every turn or thereabouts.
void special_check_often()
{
  while(bookshelf())
  {
    // cast a few of these
  }

  // better done in prep() since we want to check more often:
  numberology();
  protonic();

}
