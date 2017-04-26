import 'special/items/yz_protonic.ash';
import 'special/locations/yz_bookshelf.ash';
import 'special/skills/yz_numberology.ash';


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
