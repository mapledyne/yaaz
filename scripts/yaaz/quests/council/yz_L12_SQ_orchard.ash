import "util/yz_main.ash";
import "util/base/yz_war_support.ash";

boolean one_orchard_effect(effect ef, item it)
{
  if (have_effect(ef) == 0 && have(it))
  {
    use(1, it);
  }
  if (have_effect(ef) > 0)
    return true;
  else
    return false;
}

void check_orchard_effects()
{
  if (one_orchard_effect($effect[filthworm guard stench], $item[filthworm royal guard scent gland]))
    return;
  if (one_orchard_effect($effect[filthworm drone stench], $item[filthworm drone scent gland]))
    return;
  if (one_orchard_effect($effect[filthworm larva stench], $item[filthworm hatchling scent gland]))
    return;
}

location pick_orchard_location()
{

  if (have_effect($effect[filthworm guard stench]) > 0)
    return $location[The Filthworm Queen's Chamber];
  if (have_effect($effect[filthworm drone stench]) > 0)
    return $location[The royal guard Chamber];
  if (have_effect($effect[filthworm larva stench]) > 0)
    return $location[The feeding Chamber];

  return $location[the hatching chamber];
}

boolean L12_SQ_orchard()
{
  string side = war_side();

  if (!war_orchard()) return false;

  if (get_property("sidequestOrchardCompleted") != "none")
    return false;
  if (prop_int("hippiesDefeated") < 64 && side == "fratboy")
    return false;

  outfit(war_outfit());

  if (pick_orchard_location() == $location[the hatching chamber])
  {
    info("Visiting the grocer to start the quest.");
    debug("Todo: store that we've already started this a better way.");
    visit_url("bigisland.php?place=orchard&action=stand&pwd=");
  }

  log("Completing the orchard quest.");
  if (!have($item[heart of the filthworm queen]))
  {
    check_orchard_effects();

    monster_grab = $monsters[filthworm drone, larval filthworm,filthworm royal guard];
    yz_adventure(pick_orchard_location(), "items");
    return true;
  }

  outfit(war_outfit());
  log("Visiting the grocer to complete the quest.");
  visit_url("bigisland.php?place=orchard&action=stand&pwd=");

  log("Visiting the grocer once more to collect our reward.");
  visit_url("bigisland.php?place=orchard&action=stand&pwd=");
  log("Orchard complete.");
  return true;
}

void main()
{
  while (L12_SQ_orchard());
}
