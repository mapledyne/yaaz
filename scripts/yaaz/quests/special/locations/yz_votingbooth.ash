import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";

int voting_counter(int turns)
{
  int counter = 12 - turns % 11;

  if (counter > 10) counter = counter - 11;

  return counter;
}

int voting_counter()
{
  return voting_counter(total_turns_played());
}

void votingbooth_cleanup()
{

}

void votingbooth_progress()
{
  if (!prop_bool("voteAlways")) return;

  item voted_sticker = $item[9990]; // "I Voted" sticker
  if (!have(voted_sticker))
  {
    task("Vote!");
    return;
  }
  int free_fights = prop_int("_voteFreeFights");
  int max_free = 3;
  if (free_fights < max_free)
  {
    progress(free_fights, max_free, "free voting fights used");
  }
}

boolean is_positive_initiative(string i)
{
  // This removes the outright bad ones, but doesn't hide any
  // sub-optimal ones. Good enough for now.
  return !contains_text(i, '-');
}

int get_vote_choice(boolean reverse)
{
  int start = 1;
  int end = 4;
  int inc = 1;

  if (reverse)
  {
    start = 4;
    end = 1;
    inc = -1;
  }

  for x from start to end by inc
  {
    string initiative = "_voteLocal" + to_string(x);
    string initiative_contents = get_property(initiative);
    if (is_positive_initiative(initiative_contents)) return x - 1;
  }

  return start - 1;

}

int get_vote_choice()
{
  return get_vote_choice(false);
}

boolean votingbooth()
{
  if (!prop_bool("voteAlways")) return false;

  item voted_sticker = $item[9990]; // "I Voted" sticker
  if (!be_good(voted_sticker)) return false;
 
  if (!have(voted_sticker))
  {
    log('Seeing what the choices are for voting.');
    string choices = visit_url('/place.php?whichplace=town_right&action=townright_vote');

    int candidate = random(2) + 1;

    int local1 = get_vote_choice();
    int local2 = get_vote_choice(true);
    log("Voting for two initiatives: " + wrap(get_property("_voteLocal" + (local1 + 1)), COLOR_MONSTER) + ", " + wrap(get_property("_voteLocal" + (local2 + 1)), COLOR_MONSTER) + ".");
    string url = "choice.php?whichchoice=1331&option=1&g=" + candidate + "&local[]=" + local1 + "&local[]=" + local2 + "&pwd";
    visit_url(url);
    return true;
  }

  if (!have(voted_sticker)) return false;
  if (prop_int("lastVoteMonsterTurn") >= total_turns_played()) return false;

  string votingfights = setting("votingfights", "aftercore");
  if (votingfights == "false") return false;
  if (votingfights == "aftercore")
  {
    if (!in_aftercore() && prop_int("_voteFreeFights") > 2) return false;
  }

  if (total_turns_played() % 11 != 1) return false;

  log("Voting monster is upon us. Let's go fight it.");

  string equip = "";
  if (to_monster(get_property("_voteMonster")) == $monster[terrible mutant])
  {
    if (have($item[mutant legs]) && !have($item[mutant crown]))
    {
      log("Equipping our " + wrap($item[mutant legs]) + " in hopes of a " + wrap($item[mutant crown]));
      equip = "+equip [10008]";
    }
    if (have($item[mutant arm])
        && !have($item[mutant legs])
        && can_equip($item[mutant arm]))
    {
      log("Equipping our " + wrap($item[mutant arm]) + " in hopes of a " + wrap($item[mutant legs]));
      equip = "+equip [10007]";
    }
  }

  maximize(equip, voted_sticker);
  yz_adventure_bypass($location[the haunted pantry]);

  return true;
}

void main()
{
  votingbooth();
}
