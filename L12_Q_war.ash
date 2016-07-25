import "util/main.ash";

string default_side = "fratboy";

int defeated(string side);
int defeated();
int sidequests(string side);
int sidequests();
boolean sidequest(string quest, string side);
boolean sidequest(string quest);
void do_war(string side);
void do_war();


int defeated(string side)
{
  string prop = "hippiesDefeated";
  if (side == "hippy")
    prop = "fratboysDefeated";
  return (get_property(prop).to_int());
}
int defeated()
{
  return defeated(default_side);
}

int sidequests(string side)
{
  int count = 0;

  if (sidequest("Arena"))
    count += 1;
  if (sidequest("Farm"))
    count += 1;
  if (sidequest("Junkyard"))
    count += 1;
  if (sidequest("Lighthouse"))
    count += 1;
  if (sidequest("Nuns"))
    count += 1;
  if (sidequest("Orchard"))
    count += 1;

  return count;
}

int sidequests()
{
  return sidequests(default_side);
}

boolean sidequest(string quest, string side)
{
  string prop = "sidequest" + quest + "Completed";

  if (get_property(prop) == side)
    return true;
  return false;
}
boolean sidequest(string quest)
{
    return sidequest(quest, default_side);
}

void do_war(string side)
{
  if (quest_status("questL12War") < 1)
  {
    warning("This script can't (yet) start the war. Go do that.");
    abort();
  }
  if (quest_status("questL12War") > 10)
  {
    warning("War already ended. Good job!");
  }

  if (sidequests() < 5)
  {
    warning("This script doesn't handle the sidequests yet. You should do those before running this.");
    abort();
  }

  location battle = $location[The Battlefield (Frat Uniform)];
  string outfit = "Frat Warrior Fatigues";

  if (side == "hippy")
  {
    battle = $location[The Battlefield (Hippy Uniform)];
    outfit = "War Hippy Fatigues";
  }
  while(defeated() < 1000)
  {
    maximize("", outfit);
    dg_adventure(battle);
  }

  // turn in any last items...
  prep($location[none]);
}

void do_war()
{
  do_war(default_side);
}

void main()
{
  do_war();
}
