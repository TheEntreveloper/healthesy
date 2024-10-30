import 'package:flutter/material.dart';

evalChoices(String chtype, choices, sel) {
  var n = choices.length;
  var score = 0, errors = '', maxscore = 0;
  for (var i = 0; i < n; i++) {
    bool found = false;
    if (chtype == 'scq' && choices[i]['selected'] == true) { found = true; }
    if (chtype == 'mcq' && choices[i]['selected'] == true) { found = true; }
    int chscore = int.parse(choices[i]['score']);
    if (found) {
      //score += chscore;for now, evenly score
      if (chscore <= 0) {
      errors += '<li>You chose option ${i+1}, which is incorrect.</li>';
      } else { score +=1; } // for now, evenly score
    } else {
      if (chscore > 0) {
      errors += '<li>You didn\'t choose option ${i+1}, which is correct.</li>';
      } else {
      score +=1; // for now, evenly score
      }
    }
    if (chscore > 0) { maxscore += chscore; }
  }
  if (errors.length > 0) { errors = '. Here is some feedback:<br><ul>' + errors + '</ul>'; }
  //var totalscore = (score/maxscore)*100;
  var totalscore = (score/n)*100;
  if (totalscore < 0) { totalscore = 0; }
  return 'Your score for this quiz is ${totalscore}%' + errors;
}
property(map, key, defaultValue) {
  return map[key] != null ? map[key] : defaultValue;
}
mkRoute(BuildContext context, Widget destination ) {
  return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination,)
  );
}
clip(String str, int lg, [String append = '...']) {
  if (str.length < lg) return str;
  return str.substring(0, lg) + append;
}
