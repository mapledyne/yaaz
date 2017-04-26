import "base/yz_settings.ash";

record player {
  string name;
  int id;
};

player[int] players;

player update_player(string name)
{
  player them;

  string p_id = get_player_id(name);
  if (p_id == name)
  {
    // empty. Bad player name?
    return them;
  }
  them.name = name;
  them.id = to_int(get_player_id(p_id));


   string playerName;

   // use visit_url() to store the player profile's HTML in a string
   string playerProfile = visit_url("showplayer.php?who=" + them.id);
   if ( contains_text(playerProfile, "<td>Sorry, this player could not be found.</td>") ) {
      print("Player " + playerID + "does not exist.","red");
      return them;
   }
   // find player name in the string returned by visit_url()
   matcher match_name = create_matcher("<b>([^<]+)</b> \\(#" + playerID + "\\)<br>", playerProfile);
   if ( match_name.find() ) {
      playerName = match_name.group(1);
   }
   else {
      print("Problem occurred while parsing for player name","red");
      return "";
   }

     return playerName;
  }

  return them;
}
