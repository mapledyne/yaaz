import "util/adventure/yz_adventure.ash";
import "util/base/yz_print.ash";

void tuxedo_shirt_progress()
{
  if (my_path() != "License to Adventure") {
    return;
  }
  if (have($item[tuxedo shirt])) {
    return;
  }

  task("obtain (" + wrap($item[tuxedo shirt])+ ")");
}

void tuxedo_shirt_cleanup()
{

}

boolean tuxedo_shirt()
{
  // Get a Tuxedo Shirt for martini drinking

  if (my_path() != "License to Adventure") {
    return false;
  }

  if (!have_skill($skill[torso awaregness])) {
    return false;
  }

  maybe_pull($item[tuxedo shirt]);

  if (have($item[tuxedo shirt])) {
    return false;
  }
  if (quest_status("questL08Trapper") < 4) {
    return false;
  }

  use_all($item[frozen mob penguin]);

  if (!have($item[penguin skin])) {
    if (have($item[disassembled clover])) {
      maximize("cold res, 5 min, 5 max");
      return yz_clover($location[the icy peak]);
    } else {
      return false;
    }
  }
  create(1, $item[tuxedo shirt]);
  return true;
}

void main()
{
  while(tuxedo_shirt());
}
