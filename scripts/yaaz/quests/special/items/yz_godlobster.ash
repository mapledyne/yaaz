import "util/yz_main.ash";

void godlobster_cleanup()
{

}

void godlobster_progress()
{
  if (!have_familiar($familiar[god lobster])) return;
  if (!be_good($familiar[god lobster])) return;
  if (to_familiar(setting("100_familiar")) != $familiar[none]) return;
  int fights = prop_int("_godLobsterFights");
  if (fights >= 3) return;

  progress(fights, 3, "Free fights with the " + wrap($familiar[god lobster]));
}

item pick_lobster_item()
{
  if (!have($item[god lobster's scepter])) return $item[none];
  if (!have($item[god lobster's ring])) return $item[god lobster's scepter];
  if (!have($item[god lobster's rod])) return $item[god lobster's ring];
  if (!have($item[god lobster's robe])) return $item[god lobster's rod];
  if (!have($item[god lobster's crown])) return $item[god lobster's robe];

  return $item[god lobster's crown];
}

boolean godlobster()
{
  if (!have_familiar($familiar[god lobster])) return false;
  if (prop_int("_godLobsterFights") >= 3) return false;
  if (to_familiar(setting("100_familiar")) != $familiar[none]) return false;
  if (dangerous($monster[god lobster])) return false;

  use_familiar($familiar[god lobster]);
  item toy = pick_lobster_item();
  maximize("", "", toy, $familiar[god lobster]);
  log("Off to fight a " + wrap($monster[god lobster]));
  visit_url("main.php?fightgodlobster=1");
  run_combat();

  visit_url('choice.php');
  int choice = 2;
  if (equipped_amount($item[god lobster's crown]) == 0) choice = 1;
  run_choice(choice);

  return true;
}

void main()
{
  while(godlobster());
}
