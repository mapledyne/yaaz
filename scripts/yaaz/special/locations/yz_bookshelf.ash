import "util/base/yz_util.ash";

void bookshelf_progress()
{

}

boolean have_love_song()
{
  foreach ef in $effects[broken heart,
                         fiery heart,
                         cold hearted,
                         sweet heart,
                         withered heart,
                         lustful heart]
  {
    if (have_effect(ef) > 0)
      return true;
  }
  return false;
}

boolean have_colored_tongue()
{
  foreach ef in $effects[orange tongue,
                         blue tongue,
                         purple tongue,
                         green tongue,
                         red tongue,
                         black tongue]
  {
    if (have_effect(ef) > 0)
      return true;
  }
  return false;
}

int total_dice()
{
  return count_set($items[d4, d6, d8, d10, d12, d20]);
}

int total_candy_hearts()
{
  return count_set($items[white candy heart,
                          pink candy heart,
                          orange candy heart,
                          lavender candy heart,
                          yellow candy heart,
                          green candy heart]);
}

int total_party_favors()
{
  return count_set($items[divine blowout,
                          divine can of silly string,
                          divine champagne flute,
                          divine champagne popper,
                          divine cracker,
                          divine noisemaker]);
}

int total_love_songs()
{
  return count_set($items[love song of vague ambiguity,
                          love song of smoldering passion,
                          love song of icy revenge,
                          love song of sugary cuteness,
                          love song of disturbing obsession,
                          love song of naughty innuendo]);
}

int total_brickos()
{
    return count_set($items[BRICKO brick, BRICKO eye brick]);
}

int total_resolutions()
{
  return count_set($items[resolution: be wealthier,
                          resolution: be happier,
                          resolution: be feistier,
                          resolution: be stronger,
                          resolution: be smarter,
                          resolution: be sexier,
                          resolution: be kinder,
                          resolution: be luckier,
                          resolution: be more adventurous]);
}

int total_taffy()
{
  return count_set($items[pulled red taffy,
                          pulled orange taffy,
                          pulled yellow taffy,
                          pulled green taffy,
                          pulled blue taffy,
                          pulled indigo taffy,
                          pulled violet taffy]);
}

int libram_count(skill sk)
{
  switch(sk)
  {
    default:
      warning("I don't know how deal with this skill as a libram: " + wrap(sk) + ".");
      return 0;
    case $skill[summon candy heart]:
      return total_candy_hearts();
    case $skill[summon party favor]:
      return total_party_favors();
    case $skill[summon love song]:
      return total_love_songs();
    case $skill[summon dice]:
      return total_dice();
    case $skill[summon brickos]:
      return total_brickos();
    case $skill[summon resolutions]:
      return total_resolutions();
    case $skill[summon taffy]:
      return total_taffy();
  }
}

skill next_libram()
{
  skill libram = $skill[none];

  skill [int] books;
  int counter = 0;
  foreach sk in $skills[summon candy heart,
                        summon love song,
                        summon party favor,
                        summon dice,
                        summon BRICKOs,
                        summon resolutions,
                        summon taffy]
  {
    books[counter] = sk;
    counter += 1;
  }

  sort books by libram_count(value);
  foreach x, sk in books
  {
    if (have_skill(sk) && be_good(sk))
      return sk;
  }
  return $skill[none];
}


void clip_art()
{
  if (!have_skill($skill[summon clip art])) return;
  if (!be_good($skill[summon clip art])) return;
  int summons = prop_int("_clipartSummons");

  while (summons < 3 && my_mp() > 10)
  {
    item toy = $item[none];
    int qty = 1000000;

    for clip from 5224 to 5283
    {
      item art = to_item(clip);
      int current = item_amount(art) + closet_amount(art);

      // give preference to consumables once we have the equipment
      if (can_equip(art))
      {
        current = current * 1000;
      } else {
        current += 1;
      }

      if (current < qty)
      {
        toy = art;
        qty = current;
      }
    }
    create(1, toy);

    summons = prop_int("_clipartSummons");
  }
}

void bookshelf()
{

  // tomes - can summon each one three times:
  cast_if($skill[summon snowcones], prop_int("_snowconeSummons") < 3);
  cast_if($skill[summon stickers], prop_int("_stickerSummons") < 3);
  cast_if($skill[summon sugar sheets], prop_int("_sugarSummons") < 3);
  cast_if($skill[summon rad libs], prop_int("_radlibSummons") < 3);
  cast_if($skill[summon Smithsness], prop_int("_smithsnessSummons") < 3);

  clip_art();
  // Librams - these get more expensive each cast:
  skill book = next_libram();
  if (book != $skill[none])
  {
    int cost = mp_cost(book);

    while (cost < my_mp() * 0.3)
    {
      log("Casting " + wrap(book) + " since we have enough spare MP. Cost should be " + cost + " MP.");
      use_skill(1, book);
      cost = mp_cost(book);
      book = next_libram();
    }
  }


}

void main()
{
  bookshelf();
}
