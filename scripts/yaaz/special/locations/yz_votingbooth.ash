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

void votingbooth()
{

}

void main()
{
  votingbooth();
}
