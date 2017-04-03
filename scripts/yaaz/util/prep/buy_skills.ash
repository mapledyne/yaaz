import "util/base/print.ash";

boolean [skill] skills_wanted = $skills[Fortitude of the Muskox,
                                        Audacity of the Otter,
                                        cold shoulder,
                                        Wrath of the Wolverine,
                                        Super-Advanced Meatsmithing,
                                        Thrust-Smack,
                                        Tongue of the Walrus,
                                        Lunging Thrust-Smack,
                                        Pulverize,
                                        Blessing of the War Snapper,
                                        Amphibian Sympathy,
                                        Armorcraftiness,
                                        Spirit Snap,
                                        Kneebutt,
                                        Butts of Steel,
                                        Headbutt,
                                        Shieldbutt,
                                        Entangling Noodles,
                                        Lasagna Bandages,
                                        Bind Vampieroghi,
                                        Cannelloni Cannon,
                                        Pastamastery,
                                        Bind Vermincelli,
                                        Weapon of the Pastalord];

int trainer_skillid(skill sk)
{
  int id = to_int(sk);

  while (id > 1000) id = id - 1000;
  return id;
}

boolean check_buy_skill(skill sk)
{
  if (have_skill(sk)) return false;

  if (!guild_store_available()) return false;

  if (sk.class != my_class()) return false;
  if (sk.level > my_level()) return false;
  if (sk.traincost * 2 > my_meat()) return false;

  int skillid = trainer_skillid(sk);
  if (skillid < 1) return false;

  log("Training up on " + wrap(sk) + ".");
  visit_url("guild.php?action=buyskill&skillid=" + skillid);
  wait(5);
  return true;
}

void buy_skills()
{
  foreach s in skills_wanted
  {
    check_buy_skill(s);
  }
}

void main()
{
  buy_skills();

  foreach s in skills_wanted
  {
    if (skills_wanted[s] == -1)
    {
      print(s + ": " + to_int(s));
    }
  }
}
