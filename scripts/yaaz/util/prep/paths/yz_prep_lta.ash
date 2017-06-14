since r18104;
import "util/base/yz_inventory.ash";
import "util/base/yz_print.ash";

boolean[string] lta_skills_wanted = $strings[
  bondSymbols,
  bondMartiniPlus,
  bondMartiniTurn,
  bondAdv,
  bondDrunk2,
  bondDrunk1,
  bondJetpack,
  bondWar,
  bondDesert,
  bondBridge,
  bondStat2,
  bondStat,
  bondItem3,
  bondMeat,
  bondItem2,
  bondItem1,
  bondSpleen,
  bondHoney,
  bondMPregen,
  bondDR,
  bondInit,
  bondHP,
  bondStealth,
  bondStealth2,
  bondWeapon2,
  bondWpn,
  bondMox1,
  bondMox2,
  bondMus1,
  bondMus2,
  bondMys1,
  bondMys2,
  bondBeat,
  bondBooze,
  bondMartiniDelivery,
  bondBeach,

];

record lta_skill {
  int cost;
  int k;
  string w;
};

lta_skill[string] lta_skills;
lta_skills["bondAdv"].cost = 1;
lta_skills["bondAdv"].k = 1;
lta_skills["bondAdv"].w = "s";
lta_skills["bondBeach"].cost = 1;
lta_skills["bondBeach"].k = 7;
lta_skills["bondBeach"].w = "p";
lta_skills["bondBeat"].cost = 1;
lta_skills["bondBeat"].k = 8;
lta_skills["bondBeat"].w = "p";
lta_skills["bondBooze"].cost = 2;
lta_skills["bondBooze"].k = 8;
lta_skills["bondBooze"].w = "s";
lta_skills["bondBridge"].cost = 3;
lta_skills["bondBridge"].k = 14;
lta_skills["bondBridge"].w = "s";
lta_skills["bondDR"].cost = 1;
lta_skills["bondDR"].k = 4;
lta_skills["bondDR"].w = "s";
lta_skills["bondDesert"].cost = 5;
lta_skills["bondDesert"].k = 18;
lta_skills["bondDesert"].w = "s";
lta_skills["bondDrunk1"].cost = 2;
lta_skills["bondDrunk1"].k = 8;
lta_skills["bondDrunk1"].w = "s";
lta_skills["bondDrunk2"].cost = 3;
lta_skills["bondDrunk2"].k = 11;
lta_skills["bondDrunk2"].w = "s";
lta_skills["bondHP"].cost = 1;
lta_skills["bondHP"].k = 5;
lta_skills["bondHP"].w = "s";
lta_skills["bondHoney"].cost = 5;
lta_skills["bondHoney"].k = 18;
lta_skills["bondHoney"].w = "p";
lta_skills["bondInit"].cost = 1;
lta_skills["bondInit"].k = 3;
lta_skills["bondInit"].w = "s";
lta_skills["bondItem1"].cost = 1;
lta_skills["bondItem1"].k = 3;
lta_skills["bondItem1"].w = "p";
lta_skills["bondItem2"].cost = 2;
lta_skills["bondItem2"].k = 6;
lta_skills["bondItem2"].w = "s";
lta_skills["bondItem3"].cost = 4;
lta_skills["bondItem3"].k = 16;
lta_skills["bondItem3"].w = "s";
lta_skills["bondJetpack"].cost = 3;
lta_skills["bondJetpack"].k = 12;
lta_skills["bondJetpack"].w = "s";
lta_skills["bondMPregen"].cost = 3;
lta_skills["bondMPregen"].k = 15;
lta_skills["bondMPregen"].w = "s";
lta_skills["bondMartiniDelivery"].cost = 1;
lta_skills["bondMartiniDelivery"].k = 9;
lta_skills["bondMartiniDelivery"].w = "p";
lta_skills["bondMartiniPlus"].cost = 3;
lta_skills["bondMartiniPlus"].k = 13;
lta_skills["bondMartiniPlus"].w = "p";
lta_skills["bondMartiniTurn"].cost = 1;
lta_skills["bondMartiniTurn"].k = 1;
lta_skills["bondMartiniTurn"].w = "p";
lta_skills["bondMeat"].cost = 1;
lta_skills["bondMeat"].k = 2;
lta_skills["bondMeat"].w = "p";
lta_skills["bondMox1"].cost = 1;
lta_skills["bondMox1"].k = 6;
lta_skills["bondMox1"].w = "p";
lta_skills["bondMox2"].cost = 3;
lta_skills["bondMox2"].k = 12;
lta_skills["bondMox2"].w = "p";
lta_skills["bondMus1"].cost = 1;
lta_skills["bondMus1"].k = 4;
lta_skills["bondMus1"].w = "p";
lta_skills["bondMus2"].cost = 3;
lta_skills["bondMus2"].k = 10;
lta_skills["bondMus2"].w = "p";
lta_skills["bondMys1"].cost = 1;
lta_skills["bondMys1"].k = 5;
lta_skills["bondMys1"].w = "p";
lta_skills["bondMys2"].cost = 3;
lta_skills["bondMys2"].k = 11;
lta_skills["bondMys2"].w = "p";
lta_skills["bondSpleen"].cost = 4;
lta_skills["bondSpleen"].k = 17;
lta_skills["bondSpleen"].w = "s";
lta_skills["bondStat"].cost = 2;
lta_skills["bondStat"].k = 7;
lta_skills["bondStat"].w = "s";
lta_skills["bondStat2"].cost = 4;
lta_skills["bondStat2"].k = 17;
lta_skills["bondStat2"].w = "p";
lta_skills["bondStealth"].cost = 3;
lta_skills["bondStealth"].k = 13;
lta_skills["bondStealth"].w = "s";
lta_skills["bondStealth2"].cost = 4;
lta_skills["bondStealth2"].k = 16;
lta_skills["bondStealth2"].w = "p";
lta_skills["bondSymbols"].cost = 3;
lta_skills["bondSymbols"].k = 10;
lta_skills["bondSymbols"].w = "s";
lta_skills["bondWar"].cost = 3;
lta_skills["bondWar"].k = 14;
lta_skills["bondWar"].w = "p";
lta_skills["bondWeapon2"].cost = 3;
lta_skills["bondWeapon2"].k = 15;
lta_skills["bondWeapon2"].w = "p";
lta_skills["bondWpn"].cost = 1;
lta_skills["bondWpn"].k = 2;
lta_skills["bondWpn"].w = "s";

int total_social_capital_obtained() {
  return (
    my_level() / 3 +
    get_property("bondPoints").to_int() +
    get_property("bondVillainsDefeated").to_int() * 2
    );
}

int available_social_capital() {
  int available_capital = total_social_capital_obtained();

  foreach sk in lta_skills_wanted
  {
    if (get_property(sk).to_boolean()) {
      available_capital -= lta_skills[sk].cost;
    }
  }

  return available_capital;
}

boolean buy_lta_skill(string sk)
{
  log("Training up on " + sk + ".");
  wait(5);
  visit_url("choice.php?whichchoice=1259&option=1&k=" + lta_skills[sk].k + "&w=" + lta_skills[sk].w + "&pwd=" + my_hash());
  return true;
}

void prep_lta()
{
  if (my_path() != "License to Adventure") {
    return;
  }

  // Use victor's spoils
  use_all($item[victor's spoils]);

  if (available_social_capital() == 0) {
    return;
  }

  foreach sk in lta_skills_wanted
  {
    if (get_property(sk).to_boolean()) continue;

    if (lta_skills[sk].cost > available_social_capital()) {
      // Stop when we hit something too expensive, and save it. Don't spend on 1's all the time etc.
      break;
    }

    buy_lta_skill(sk);
  }
}

void main()
{
  prep_lta();
}
