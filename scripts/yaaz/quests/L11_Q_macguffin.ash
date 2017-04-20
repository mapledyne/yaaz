import "quests/L11_SQ_black_market.ash";
import "quests/L11_SQ_desert.ash";
import "quests/L11_SQ_hidden_city.ash";
import "quests/L11_SQ_palindome.ash";
import "quests/L11_SQ_summoning.ash";
import "quests/L11_SQ_pyramid.ash";

void L11_Q_macguffin_cleanup()
{

}

boolean L11_Q_macguffin()
{

  if (my_level() < 11)
    return false;

  if (quest_status("questL11MacGuffin") == UNSTARTED)
  {
    log("Going to the council to start the MacGuffin quest.");
    council();
  }


  if (L11_SQ_black_market()) return true;
  if (L11_SQ_desert()) return true;
  if (L11_SQ_hidden_city()) return true;
  if (L11_SQ_palindome()) return true;
  if (L11_SQ_summoning()) return true;
  if (L11_SQ_pyramid()) return true;

  if (item_amount($item[[2334]Holy MacGuffin]) > 0)
  {
    log("Returning the " + wrap($item[[2334]Holy MacGuffin]) + " to the council.");
    council();
    return true;
  }

  return false;
}

void main()
{
  while (L11_Q_macguffin());
}
