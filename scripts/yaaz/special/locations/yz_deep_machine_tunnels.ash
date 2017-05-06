import "util/base/yz_print.ash";
import "util/base/yz_maximize.ash";
import "util/adventure/yz_adventure.ash";

location deep_machine_tunnels = $location[The Deep Machine Tunnels];

int dmt_fights_remaining()
{
  return 5 - get_property("_machineTunnelsAdv").to_int();
}

void dmt_progress()
{

  if (have_familiar($familiar[machine elf])
      && dmt_fights_remaining() > 0)
  {
    int fights = get_property("_machineTunnelsAdv").to_int();
    progress(fights, 5, "free " + wrap(deep_machine_tunnels) + " fights", "blue");
  }

}

boolean can_dmt()
{
  if (!can_adventure())
    return false;

  if (dangerous(deep_machine_tunnels))
    return false;

  if (have_familiar($familiar[Machine Elf]) && dmt_fights_remaining() > 0)
    return true;

  return false;
}

void dmt()
{
  while(can_dmt())
  {
    log("Off to fight in the " + wrap(deep_machine_tunnels) + ".");
    maximize("", $familiar[machine elf]);
    yz_adventure(deep_machine_tunnels);
  }
}

void main()
{
  log("Doing default actions with the " + wrap(deep_machine_tunnels) + ".");
  dmt();
}
