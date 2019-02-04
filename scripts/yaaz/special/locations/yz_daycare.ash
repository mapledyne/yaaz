import "util/base/yz_util.ash";
import "util/base/yz_settings.ash";

void daycare_progress()
{

}

void maybe_recruit()
{
  int max_recruits = to_int(setting("daycare_recruits", 1));
  int current_recruits = prop_int("_daycareRecruits");
  if (current_recruits >= max_recruits) return;

  int max_cost = 10;
  int current_cost = 10;
  for x from 1 to max_recruits
  {
    max_cost = max_cost * 10;
  }
  for x from 0 to current_recruits
  {
    current_cost = current_cost * 10;
  }

  if (my_meat() > current_cost * 10)
  {
    log("Going to recruit at the Daycare. Current cost: " + current_cost);
    visit_url('place.php?whichplace=town_wrong&action=townwrong_boxingdaycare');
    run_choice(3);
    run_choice(1);
  }

}

void daycare()
{
  if (get_property("daycareOpen") != "true") return;

  maybe_recruit();
//  maybe_instruct();
}

void main()
{
  daycare();
}
