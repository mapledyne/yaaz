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

void votingbooth_progress()
{
  if (!to_boolean(get_property("voteAlways"))) return;

  item voted_sticker = $item[9990]; // "I Voted" sticker
  if (!have(voted_sticker))
  {
    task("Vote!");
    return;
  }
  int free_fights = to_int(get_property("_voteFreeFights"));
  int max_free = 3;
  if (free_fights < max_free)
  {
    progress(max_free - free_fights, max_free, "free voting fights remaining");
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
    if (is_positive_initiative(initiative_contents)) return x;
  }
  return 1;

}

int get_vote_choice()
{
  return get_vote_choice(false);
}

void votingbooth()
{
  if (!to_boolean(get_property("voteAlways"))) return;
  item voted_sticker = $item[9990]; // "I Voted" sticker
  if (have(voted_sticker)) return;

  log('Seeing what the choices are for voting.');
  string choices = visit_url('/place.php?whichplace=town_right&action=townright_vote');
  visit_url("choice.php?whichchoice=582&option=2&pwd");

  int candidate = random(2) + 1;

  int local1 = get_vote_choice();
  int local2 = get_vote_choice(true);
  string url = "choice.php?whichchoice=1331&option=1&g=" + candidate + "&local[]=" + local1 + "&local[]=" + local2 + "&pwd";
  print(visit_url(url));

}

void main()
{
  votingbooth();
}
