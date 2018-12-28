import "util/yz_main.ash";

void M_invisiblestring_cleanup()
{

}

void M_invisiblestring_progress()
{
  if (have($item[invisible string]))
  {
    task("You have an " + wrap($item[invisible string]) + ".");
  }
  if (have($item[invisible seam ripper]))
  {
    task("You have an " + wrap($item[invisible seam ripper]) + ".");
  }


  int ef = have_effect($effect[invisibly ripped]);
  if (ef > 0)
  {
    progress(ef, 5, "Turns left to get the " + wrap($item[li'l ghost costume]));
  }

  if (ef == 0)
  {
    ef = have_effect($effect[invisible ties]);
    if (ef > 0)
    {
      progress(ef, 5, "Turns left to get the " + wrap($item[invisible seam ripper]));
    }
  }


}

boolean M_invisiblestring()
{
  // if we can't use the tot (we're doing a tour guide with something else)
  // then never attempt the string path.

  if (to_familiar(setting("100familar")) != $familiar[trick-or-treating tot]
      && to_familiar(setting("100familar")) != $familiar[none]) return false;

  if (have($item[li'l ghost costume])) return false;

  // skip if we can't adventure here yet:
  if (!location_open($location[the haunted storage room])) return false;
  if (!location_open($location[lair of the ninja snowmen])) return false;

  if (have_effect($effect[invisibly ripped]) > 0)
  {
    yz_adventure($location[the haunted storage room]);
    cli_execute("refresh inv");
    return true;
  }

  if (have_effect($effect[invisible ties]) > 0)
  {
    yz_adventure($location[Lair of the Ninja Snowmen]);
    cli_execute("refresh inv");
    return true;
  }

  if (have($item[invisible seam ripper]))
  {
    log("We have an " + wrap($item[invisible seam ripper]) + " and may be able to get the " + wrap($item[li'l ghost costume]) + ".");
    use(1, $item[invisible seam ripper]);
    return true;
  }

  if (have($item[invisible string]))
  {
    log("We have an " + wrap($item[invisible string]) + " and may be able to get the " + wrap($item[li'l ghost costume]) + ".");
    use(1, $item[invisible string]);
    return true;
  }

  debug("I might want to do something with the " + wrap($item[invisible string]) + " ...");
  return false;
}

void main()
{
  while(M_invisiblestring());
}
