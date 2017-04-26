import "util/base/yz_inventory.ash";
import "util/base/yz_settings.ash";
import <zlib.ash>

boolean add_familiar_weight = false;

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
    if (!be_good(f))
      continue;

    // be_good() seems hit-or-miss with familiars...
    if (my_path() == "Bees Hate You"
        && contains_text(to_lower_case(f), "b"))
      continue;

    if(have_familiar(f))
    {
      if (f == $familiar[gelatinous cubeling]
          && !have_cubeling_items())
      {
        return f;
      }
      if (f == $familiar[intergnat] && item_amount($item[BACON]) < 20)
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
    if (!be_good(f))
      continue;

    // be_good() seems hit-or-miss with familiars...
    if (my_path() == "Bees Hate You"
        && contains_text(to_lower_case(f), "b"))
      continue;

    if (f == $familiar[gelatinous cubeling]
        && have_cubeling_items())
      continue;

    if(have_familiar(f))
    {
      return f;
    }
  }
  return $familiar[none];
}


familiar choose_familiar(string fam)
{
  if (my_path() == "Actually Ed the Undying") return $familiar[none];

  if (!have_familiar($familiar[mosquito]))
  {
    warning("You don't have much in the way of familiars yet. Go get a couple and this script can start using them.");
    return $familiar[none];
  }

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

  add_familiar_weight = true;

  switch(fam)
  {
    case "rollover":
      newbie = choose_familiar_from_list($familiars[trick-or-treating tot]);
      add_familiar_weight = false;
      break;
    case "all res":
    case "cold res":
    case "hot res":
    case "stench res":
    case "sleaze res":
    case "spooky res":
      if (have_familiar($familiar[trick-or-treating tot]) && i_a($item[li'l candy corn costume]) > 0)
      {
        newbie = $familiar[trick-or-treating tot];
        break;
      }
      newbie = choose_familiar_from_list($familiars[exotic parrot]);
      break;
    case "meat":
      if (have_familiar($familiar[robortender]) && hippy_stone_broken())
      {
        newbie = $familiar[robortender];
        break;
      }
      if (have_familiar($familiar[trick-or-treating tot]) && have($item[li'l pirate costume]))
      {
        newbie = $familiar[trick-or-treating tot];
        break;
      }
      newbie = choose_familiar_from_list($familiars[robortender, adventurous spelunker, angry jung man, grimstone golem, leprechaun, cheshire bat, nervous tick, hobo monkey, he-boulder, coffee pixie]);
      break;
    case "init":
      newbie = choose_familiar_from_list($familiars[Happy Medium, Xiblaxian Holo-Companion, Oily Woim]);
      break;
    case "items":
      if (have_familiar($familiar[trick-or-treating tot]) && have($item[li'l ninja costume]))
      {
        newbie = $familiar[trick-or-treating tot];
        break;
      }
      newbie = choose_familiar_from_list($familiars[Rockin\' Robin, Adventurous Spelunker, Grimstone Golem, ancient yuletide troll, Intergnat, Angry Jung Man, Bloovian Groose, Slimeling, Baby Gravy Fairy, green pixie, crimbo elf, flaming gravy fairy, dandy lion, coffee pixie, syncopated turtle]);
      break;
    case "attack":
      newbie = choose_familiar_from_list($familiars[angry goat, flaming gravy fairy, mosquito, sabre-toothed lime]);
      break;
    case "combat":
      newbie = choose_familiar_from_list($familiars[jumpsuited hound dog]);
      break;
    case "sprinkles":
      newbie = choose_familiar_from_list($familiars[chocolate lab]);
      break;
    default: // everything that doesn't have a set items. Should usually be stat familiars but the exceptions to that seem to be piling up.
      newbie = choose_familiar_from_list($familiars[gelatinous cubeling, robortender, space jellyfish, intergnat, rockin\' robin, hovering sombrero, blood-faced volleyball, penguin goodfella, ancient yuletide troll, baby bugged bugbear, lil\' barrel mimic, smiling rat, happy medium, hovering sombrero, llama lama, grinning turtle, artistic goth kid]);
      add_familiar_weight = false;
      break;
  }


  if (newbie == $familiar[none] && fam != "stats")
  {
    newbie = choose_familiar("stats");
    add_familiar_weight = false;
  }

  if (newbie == $familiar[none] && fam != "items" && fam != "stats")
  {
    newbie = choose_familiar("items");
    add_familiar_weight = false;
  }

  if (newbie == $familiar[none])
  {
    foreach f in $familiars[]
    {
      if (have_familiar(f))
      {
        newbie = choose_familiar(f);
        add_familiar_weight = false;
      }
    }
  }

  if (newbie == $familiar[none])
  {
    error("You don't seem to have any familiars.");
    error("This script can't handle that situation. Go get at least one yourself.");
    abort();
  }
  equip_familiar(newbie);
  return newbie;
}
