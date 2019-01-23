import "util/yz_main.ash";
import "util/base/yz_war_support.ash";
import "special/locations/yz_terminal.ash";

boolean do_nuns_quest(string side)
{
  boolean doing_trick = false;

  if (side == "hippy" && war_side() == "fratboy") doing_trick = true;
  int meat_recovered = prop_int("currentNunneryMeat");

  boolean about_to_finish = (meat_recovered + max_expected_nuns_meat() > 100000);

  if (doing_trick
      && (
        to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand]
        || to_monster(get_property("enamorangMonster")) == $monster[dirty thieving brigand]
      )
      && about_to_finish)
  {
    log("We've digitized/enamoranged a " + wrap($monster[dirty thieving brigand]) + ", so will wait on the nuns quest until we've gotten the rest of the meat through that copy.");
    return false;
  }

  if (
    !get_property("_mayoDeviceRented").to_boolean() &&
    !get_property("mayoWhipRented").to_boolean() &&
    my_meat() > 30000
  ) {
    // If we have plenty of meat, get a miracle whip
    buy(1, $item[miracle whip]);
  }
  maximize("meat", war_outfit(side));
  effect_maintain($effect[Sinuses For Miles]);

  if (doing_trick && about_to_finish) {
    abort("We were trying to do the Nun's trick, but now we're about to adventure for the last time and we didn't make a copy");
  }

  yz_adventure($location[the themthar hills]);
  return true;
}

boolean L12_SQ_nuns(string side)
{
  if (get_property("sidequestNunsCompleted") != "none") return false;

  if (quest_status("questL12War") != 1) return false;

  if (war_nuns_accessible()) return do_nuns_quest(side);

  if (war_nuns_trick()) return do_nuns_quest("hippy");

  return false;
}

boolean L12_SQ_nuns()
{
  return L12_SQ_nuns(war_side());
}

void main()
{
  while (L12_SQ_nuns());
}
