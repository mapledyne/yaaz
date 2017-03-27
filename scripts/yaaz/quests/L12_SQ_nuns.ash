import "util/main.ash";
import "util/base/war_support.ash";
import "special/locations/terminal.ash";

boolean do_nuns_quest(string side)
{
  boolean doing_trick = false;

  if (side == "hippy" && war_side() == "fratboy") doing_trick = true;
  int meat_recovered = to_int(get_property("currentNunneryMeat"));

  if (doing_trick
      && to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand])
  {
    log("We've digitized a " + wrap($monster[dirty thieving brigand]) + ", so will wait on the nuns quest until we've gotten the rest of the meat through that copy.");
    return false;
  }

  while (meat_recovered < 100000)
  {
    maximize("meat", war_outfit(side));
    effect_maintain($effect[Sinuses For Miles]);
    int max_expected_meat = $monster[dirty thieving brigand].max_meat;
    max_expected_meat = max_expected_meat * (1 + (numeric_modifier("meat drop") / 100));

    if (doing_trick
        && meat_recovered + (max_expected_meat * 2) >= 100000)
    {
      if (to_monster(get_property("_sourceTerminalDigitizeMonster")) == $monster[dirty thieving brigand])
      {
        log("Skipping out on the rest of the nuns sidequest since we're doing the 'trick'.");
        break;
      }
    }

    boolean b = yz_adventure($location[the themthar hills]);
    if (!b) return true;
    meat_recovered = to_int(get_property("currentNunneryMeat"));
  }
  return true;
}

boolean L12_SQ_nuns(string side)
{
  if (get_property("sidequestNunsCompleted") != "none")
    return false;

  if (quest_status("questL12War") < 1)
    return false;

  if (quest_status("questL12War") > 1)
    return false;

  if (war_nuns_accessible())
  {
    return do_nuns_quest(side);
  }
  if (war_nuns_trick())
  {
    return do_nuns_quest("hippy");
  }
  return false;
}

boolean L12_SQ_nuns()
{
  return L12_SQ_nuns(war_side());
}

void main()
{
  L12_SQ_nuns();
}
