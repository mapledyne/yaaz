import "util/main.ash";



int get_cleanliness(location l)
{
  switch(l)
  {
    case $location[your bung chakra]:
      return to_int(get_property("crimbo16BungChakraCleanliness"));
    case $location[your guts chakra]:
      return to_int(get_property("crimbo16GutsChakraCleanliness"));
    case $location[your hat chakra]:
      return to_int(get_property("crimbo16HatChakraCleanliness"));
    case $location[your liver chakra]:
      return to_int(get_property("crimbo16LiverChakraCleanliness"));
    case $location[your nipple chakra]:
      return to_int(get_property("crimbo16NippleChakraCleanliness"));
    case $location[your nose chakra]:
      return to_int(get_property("crimbo16NoseChakraCleanliness"));
    case $location[crimbo's sack]:
      return to_int(get_property("crimbo16SackChakraCleanliness"));
    case $location[crimbo's boots]:
      return to_int(get_property("crimbo16BootsChakraCleanliness"));
    case $location[crimbo's jelly]:
      return to_int(get_property("crimbo16JellyChakraCleanliness"));
    case $location[crimbo's reindeer]:
      return to_int(get_property("crimbo16ReindeerChakraCleanliness"));
    case $location[crimbo's beard]:
      return to_int(get_property("crimbo16BeardChakraCleanliness"));
    case $location[crimbo's hat]:
      return to_int(get_property("crimbo16CrimboHatChakraCleanliness"));
    default:
      return 0;
  }
}

void clean_one()
{
  int top = 1000000;
  location target = $location[none];
  foreach chak in $locations[your bung chakra,
                             your guts chakra,
                             your hat chakra,
                             your liver chakra,
                             your nipple chakra,
                             your nose chakra,
                             crimbo's sack,
                             crimbo's boots,
                             crimbo's jelly,
                             crimbo's reindeer,
                             crimbo's beard,
                             crimbo's hat]
  {
    int clean = get_cleanliness(chak);
    if (clean < top)
    {
      top = clean;
      target = chak;
    }
  }

  effect power = $effect[the power of positive thinking];

  if (have_effect(power) == 0)
  {
    use(1, $item[chakra malt]);
  }

  string max = default_maximize_string();
  max += ", +equip bad vibroknife";
  max += ", +equip crystal belt buckle";
  max += ", +equip saffron antaravasaka";
  max += ", +equip saffron uttarasanga";
  max += ", +equip krampus horn";

  dg_adventure(target, max);

}

void main()
{
  int trips = to_int(setting("cleaning_trips", 10));

  for x from 1 to trips
  {
    progress(x, trips, "cleaning trips");
    clean_one();
  }
  log("Cleaning complete.");
}
