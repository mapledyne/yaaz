import "quests/L11_SQ_black_market.ash";
import "quests/L11_SQ_desert.ash";
import "quests/L11_SQ_hidden_city.ash";
import "quests/L11_SQ_palindome.ash";
import "quests/L11_SQ_summoning.ash";
import "quests/L11_SQ_pyramid.ash";

boolean L11_Q_macguffin()
{
  if (L11_SQ_black_market()) return true;
  if (L11_SQ_desert()) return true;
  if (L11_SQ_hidden_city()) return true;
  if (L11_SQ_palindome()) return true;
  if (L11_SQ_summoning()) return true;
  if (L11_SQ_pyramid()) return true;

  return false;
}

void main()
{
  L11_Q_macguffin();
}
