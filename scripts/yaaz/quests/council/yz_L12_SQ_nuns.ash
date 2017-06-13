import "util/yz_main.ash";
import "util/base/yz_war_support.ash";
import "special/locations/yz_terminal.ash";

int max_expected_nuns_meat()
{
  int max_expected_meat = $monster[dirty thieving brigand].max_meat;
  max_expected_meat = max_expected_meat * (1 + (numeric_modifier("meat drop") / 100));
  return max_expected_meat;
}

boolean do_nuns_quest(string side)
{
  boolean doing_trick = false;

  if (side == "hippy" && war_side() == "fratboy") doing_trick = true;
  int meat_recovered = to_int(get_property("currentNunneryMeat"));

  if (doing_trick
      && (
        to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand]
        || to_monster(get_property("enamorangMonster")) == $monster[dirty thieving brigand]
      )
      && meat_recovered + (max_expected_nuns_meat() * 2) > 100000)
  {
    log("We've digitized/enamoranged a " + wrap($monster[dirty thieving brigand]) + ", so will wait on the nuns quest until we've gotten the rest of the meat through that copy.");
    return false;
  }

  maximize("meat", war_outfit(side));
  effect_maintain($effect[Sinuses For Miles]);

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
