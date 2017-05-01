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
  }
}

skill next_libram()
{
  skill libram = $skill[none];

  skill [int] books;
  int counter = 0;
  foreach sk in $skills[summon candy heart, summon love song, summon party favor, summon dice]
  {
    books[counter] = sk;
    counter += 1;
  }

  sort books by libram_count(value);
  foreach x, sk in books
  {
    if (have_skill(sk))
      return sk;
  }
  return $skill[none];
}

void bookshelf()
{
  skill book = next_libram();
  if (book == $skill[none]) return;

  int cost = mp_cost(book);

  while (cost < my_mp() * 0.3)
  {
    log("Casting " + wrap(book) + " since we have enough spare MP. Cost should be " + cost + " MP.");
    use_skill(1, book);
    cost = mp_cost(book);
    book = next_libram();
  }
}

void main()
{
  bookshelf();
}
