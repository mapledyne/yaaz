import "util/main.ash";
import "quests/M_pirates.ash";
import "util/adventure.ash";


boolean L11_Q_palindome()
{
  if (get_talisman())
    return true;

  return false;
}

void main()
{
  L11_Q_palindome();
}
