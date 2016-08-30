import "util/inventory.ash";

boolean have_cubeling_items()
{
  if (i_a($item[eleven-foot pole]) == 0)
    return false;
  if (i_a($item[pick-o-matic lockpicks]) == 0)
    return false;
  if (i_a($item[ring of detect boring doors]) == 0)
    return false;

  return true;
}

void equip_familiar(familiar fam)
{
  if (my_familiar() == fam)
  {
    return;
  }

  if (!have_familiar(fam))
  {
    warning("Trying to switch to familiar " + wrap(fam) + " but you don't have this one.");
    warning("I don't know how this happened, so we're aborting.");
    abort();
  }
  log("Switching to familiar " + wrap(fam));
  use_familiar(fam);
}

familiar choose_familiar_from_list(boolean[familiar] fams)
{
  // first look for familiars with drops that haven't happened yet:
  foreach f in fams
  {
    if(have_familiar(f))
    {
      if (f == $familiar[gelatinous cubeling] && !have_cubeling_items())
      {
        return f;
      }
      if (f == $familiar[intergnat] && item_amount($item[BACON]) < 111)
      {
        return f;
      }
      if (f.drop_item != $item[none] && f.drops_limit > f.drops_today)
      {
        return f;
      }
    }
  }

  // failing that, pick a familiar from the list:
  foreach f in fams
  {
    if(have_familiar(f))
    {
      return f;
    }
  }
  return $familiar[none];
}


familiar choose_familiar(string fam)
{
  familiar solo = to_familiar(setting("100familiar"));
  if (solo != $familiar[none])
  {
    equip_familiar(solo);
    return solo;
  }

  familiar newbie = to_familiar(fam);

  if (newbie != $familiar[none])
  {
    equip_familiar(newbie);
    return newbie;
  }

  switch(fam)
  {
    case "meat":
      newbie = choose_familiar_from_list($familiars[adventurous spelunker, angry jung man, grimstone golem, leprechaun, cheshire bat, nervous tick, hobo monkey, he-boulder, coffee pixie]);
      break;
    case "init":
      newbie = choose_familiar_from_list($familiars[Happy Medium, Xiblaxian Holo-Companion, Oily Woim]);
      break;
    case "items":
      newbie = choose_familiar_from_list($familiars[Rockin\' Robin, Adventurous Spelunker, Grimstone Golem, ancient yuletide troll, Intergnat, Angry Jung Man, Bloovian Groose, Slimeling, Baby Gravy Fairy, green pixie, crimbo elf, flaming gravy fairy, dandy lion, coffee pixie, syncopated turtle]);
      break;
    case "attack":
      newbie = choose_familiar_from_list($familiars[angry goat, flaming gravy fairy, mosquito, sabre-toothed lime]);
      break;
    case "combat":
      newbie = choose_familiar_from_list($familiars[jumpsuited hound dog]);
      break;
    default: // everything that doesnt't have a set items. Should usually be stat familiars.
      newbie = choose_familiar_from_list($familiars[rockin\' robin, hovering sombrero, blood-faced volleyball, penguin goodfella, ancient yuletide troll, baby bugged bugbear, smiling rat, happy medium, lil\' barrel mimic, hovering sombrero, llama lama, grinning turtle, artistic goth kid, gelatinous cubeling]);
      break;
  }

  if (newbie == $familiar[none] && fam != "stats")
    newbie = choose_familiar("stats");

  if (newbie == $familiar[none] && fam != "items")
    newbie = choose_familiar("items");

  if (newbie == $familiar[none])
    newbie = choose_familiar("mosquito");

  equip_familiar(newbie);
  return newbie;
}
