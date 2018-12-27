import 'util/base/yz_settings.ash';

void eldritchhorror_progress()
{
  if (!to_boolean(get_property("_eldritchTentacleFought"))
      && !dangerous($monster[eldritch tentacle]))
  {
    task("Fight an " + wrap($monster[eldritch tentacle]) + ", for science.");
  }

  if (!have_skill($skill[evoke eldritch horror])) return;
  if (to_boolean(get_property("_eldritchHorrorEvoked"))) return;

  if (to_boolean(setting("aggressive_optimize", "false"))) return;

  task("Cast " + wrap($skill[evoke eldritch horror]));


}

void eldritchhorror()
{
  if (!to_boolean(get_property("_eldritchTentacleFought"))
      && !dangerous($monster[eldritch tentacle]))
  {
    log("Off to fight an " + wrap($monster[eldritch tentacle]) + ", for science.");
    wait(10);
  }

  if (!have_skill($skill[evoke eldritch horror])) return;
  if (to_boolean(get_property("_eldritchHorrorEvoked"))) return;

  if (to_boolean(setting("aggressive_optimize", "false"))) return;

  int cost = mp_cost($skill[evoke eldritch horror]);

  if (cost < my_mp() * 1.5)
  {
    maximize();
    use_skill(1, $skill[evoke eldritch horror]);
  }
}

void main()
{
  eldritchhorror();
}
