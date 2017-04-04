
boolean have_flavour_of_magic()
{
  foreach ef in $effects[spirit of cayenne,
                     spirit of garlic,
                     spirit of peppermint,
                     spirit of wormwood,
                     spirit of bacon grease]
   {
      if (have_effect(ef) > 0)
        return true;
   }
   return false;
}


boolean flavour_of_magic(location loc)
{
  if (!have_skill($skill[spirit of garlic])) return false;

  element el = $element[none];
  foreach key, mon in get_monsters(loc)
  {
    if (mon.defense_element != $element[none])
      el = mon.defense_element;
  }

  // a few exceptions:
  switch(loc)
  {
    case $location[The Ancient Hobo Burial Ground]:
      el = $element[none];
      break;
    case $location[The Ice Hotel]:
      if(get_property("walfordBucketItem") == "rain" && have_equipped($item[Walford's bucket]))
        el = $element[spooky]; // Doing 100 hot damage in a fight will fill the bucket faster
      // Lack of break is intentional
    case $location[VYKEA]:
      if(get_property("walfordBucketItem") == "ice" && have_equipped($item[Walford's bucket]))
        el = $element[sleaze]; // It will do 1 damage unless you change their element somehow, but doing 10 cold damage speeds filling the bucket
      break;
  }
  skill target = $skill[none];

  switch (el)
  {
    case $element[none]:
      if (!have_flavour_of_magic() && loc != $location[The Ancient Hobo Burial Ground])
      {
        log("You have " + wrap("Flavour of Magic", COLOR_SKILL) + ". Firing up some taste!");
        use_skill(1, $skill[spirit of garlic]);
        return true;
      }
      if (loc == $location[The Ancient Hobo Burial Ground] && have_flavour_of_magic())
      {
        log("Everything in " + wrap($location[The Ancient Hobo Burial Ground]) + " is immune to elemental damage, so turning " + wrap($skill[flavour of magic]) + " off.");
        use_skill(1, $skill[spirit of nothing]);
        return true;
      }
      break;
    case $element[hot]:
      target = $skill[spirit of garlic];
      break;
    case $element[cold]:
      target = $skill[spirit of wormwood];
      break;
    case $element[sleaze]:
      target = $skill[spirit of peppermint];
      break;
    case $element[spooky]:
      target = $skill[spirit of cayenne];
      break;
    case $element[stench]:
      target = $skill[spirit of bacon grease];
      break;
  }
  if (target != $skill[none] && have_effect(to_effect(target)) == 0)
  {
    log("Changing up your " + wrap("Flavour of Magic", COLOR_SKILL) + " to better suit where you're heading. Casting " + wrap(target) + ".");
    use_skill(1, target);
    return true;
  }
  return false;
}

boolean flavour_of_magic()
{
  return flavour_of_magic($location[none]);
}

void main()
{
  flavour_of_magic();
}
