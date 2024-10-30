import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'base_note.dart';
import 'health_action.dart';
import 'health_info.dart';
import 'message_type.dart';
import 'messages.dart';

class Hanlz extends ChangeNotifier {

  chkHInfo(HealthInfo healthInfo, BuildContext context) async {
    List<Map<String, dynamic>> result = healthInfo.result;
    if (result.isEmpty) {
      return;
    }
    String recAction = 'THIS REPORT DOES NOT CONSTITUTE MEDICAL ADVICE.<br> '
        'YOU MUST ALWAYS CONSULT WITH A MEDICAL PRACTITIONER.<br>ANY RECOMMENDATION HERE, '
        'IS PURELY TO CREATE AWARENESS, YOU MUST CONFIRM WITH YOUR DOCTOR IF IT '
        'IS APPROPRIATE FOR YOU TO FOLLOW IT.<br>';
    String? gd = healthInfo.result[0]['gender'];
    int ag = int.parse(healthInfo.result[0]['ager']);
    int? ht = healthInfo.result[0]['ht'];
    int? wt = healthInfo.result[0]['wt'];
    String? rfs = healthInfo.rf1;
    List<HealthAction> healthActions = [];
    healthActions.add(HealthAction(recAction, ''));
    double bmiScore = 0.0, ageScore = 0.0, rfScore = 0.0;
    List<HealthAction> tmpBMIActions = [];
    if (ht != null && wt != null) {
      double htm = ht / 100.0;
      double bmi = _calcBMI(htm, wt);
      bmiScore = _scoreBMI(bmi);
      tmpBMIActions = _evalBMI(bmi, ag);
    }
 ageScore = _scoreAgeRange(ag);     List<HealthAction> tmpRFSActions = [];
    if (rfs != null && rfs.isNotEmpty) {
      rfScore = _scoreRFS(rfs);
      tmpRFSActions = _evalRfs(rfs);
    }
    double totalScore = (bmiScore + ageScore + rfScore)/3;
    healthActions.add(HealthAction('Your Total Health Score is ${totalScore.toStringAsFixed(2)}%<br>', ''));
    healthActions.add(HealthAction('That score was calculated based on: a BMI '
        'Score of ${bmiScore.toStringAsFixed(2)}%, an Age score '
        'of ${ageScore.toStringAsFixed(2)}%, and a Risk Factors score of ${rfScore.toStringAsFixed(2)}%<br>', ''));
    if (tmpBMIActions.isNotEmpty) {
      healthActions.addAll(tmpBMIActions);
    }
    if (tmpRFSActions.isNotEmpty) {
      healthActions.addAll(tmpRFSActions);
    }
    if (healthActions.isNotEmpty) {
      final messages = Provider.of<Messages>(context, listen: false);
        StringBuffer body = StringBuffer();
        healthActions.forEach((element) {
          body.writeln('<p>');
          body.writeln('${element.action} ${element.rationale}');
          body.writeln('</p>');
        });
        messages.save(MessageType.report.index, -101, 'Health Info Report - HS ${totalScore.toStringAsFixed(2)}%', body.toString());
        return const Text('');
    }
  }

  chkNote(BaseNote note) {
    //note.
  }

  double _calcBMI(double htm, int wt) {
    return wt/ (htm*htm);
  }

  double _scoreBMI(double bmi) {
    int bs = 0;
    if (bmi < 18.5 ) {
      bs = 1;
    } else if (bmi < 24.9) {
      bs = 3;
    } else if (bmi < 29.9) {
      bs = 2;
    } else {
      bs = 0;
    }
    return (bs/3)*100;
  }

  double _scoreAgeRange(int age) {
    int ageScore = 0;
    if (age < 5) { ageScore = 3; }
    if (age == 5) { ageScore = 1; }
    if (age > 5) { ageScore = 0; }
    return (ageScore/3)*100;
  }

  double _scoreRFS(String rfs) {
    Map<String, int> rf = {
      'Alcohol regularly': -1,
      'Balanced diet': 1,
      'Diabetes': -1,
      'Exercise regularly': 1,
      'High blood pressure': -1,
      'Smoking': -1,
      'Stressful job or life': -1
    };
    int rfsScore = 0, maxScore = rf.length;
    rf.forEach((key, value) {
      if (rfs.contains(key)) {
        rfsScore += value;
      } else {
        rfsScore += value*-1;
      }
    });
    return (rfsScore/maxScore)*100;
  }

  List<HealthAction> _evalBMI(double bmi, int age) {
    List<HealthAction> healthActions = [];

    if (bmi > 18.5 && bmi < 24.9) {
      String action = "Try to maintain your current weight, as it seems appropriate.<br>";
      String rationale = "Your body mass index (BMI) is ${bmi.toStringAsFixed(2)}, and suggests that your weight is appropriate for your height.<br>";
      if (age == -1) {
        rationale += "Please specify your age range for additional analysis<br>";
      } else
      if (age < 6) {
        rationale += "You are not overweight or obese, which is a risk for certain diseases.<br>"+
            "However, this interpretation might not be accurate if you are not a "
                "muscular person at all, in which case lower weight might not reflect appropriate levels of body fat.<br>";
      } else {
        rationale += "You are not overweight or obese, which is a risk for certain diseases.<br>"+
            "However, this interpretation might not be accurate if you have lost some of your muscular mass, "
                "as slowly happens to us all as we age. In that case, lower weight might not reflect appropriate levels of body fat.<br>";
      }
      HealthAction healthAction = HealthAction(action, rationale);
      healthActions.add(healthAction);
    } else if (bmi < 18.5) {
      String action = "Based on the data available, you perhaps should try to increase your weight a bit more.<br>";
      String rationale = "Your body mass index (BMI) is ${bmi.toStringAsFixed(2)}, which is low. "
          "We recommend you try to increase your weight a bit more, to avoid certain conditions (such as renal ptosis) associated with being underweight<br>";
      HealthAction healthAction = HealthAction(action, rationale);
      healthActions.add(healthAction);
    } else if (bmi > 24.9 && bmi < 29.9) {
      String action = "Try to adjust your lifestyle, if possible, to avoid any further increase of your weight.<br>";
      String rationale = "Your body mass index (BMI) is ${bmi.toStringAsFixed(2)}, which is slightly high.<br>"
          "You should adjust your lifestyle, if possible, to guarantee weight control, and avoid you reaching "
          "a weight level that would contribute risks to your health.<br>";
      if (age == -1) {
        rationale += "Please specify your age range for additional analysis<br>";
      } else
      if (age > 5) {
        rationale += "A healthy life style contributes to reduce health risks, which are higher as we age.<br>"
            "If you do not have a medical condition that prevents you from exercising,"+
            "you must consider doing mild exercise on a regular basis.<br> "
                "A diet low in Carbohydrates (Sugars) should also help, unless there is a medical reason not to lower sugar intake.<br>";
      } else {
        rationale += "It is important that you combine (at least mild) exercises with healthy eating.<br>";
      }
      HealthAction healthAction = HealthAction(action, rationale);
      healthActions.add(healthAction);
    } else if (bmi >= 30) {
      String action = "If possible, try to make adjustments in your lifestyle with the aim of reducing your weight.<br>";
      String rationale = "Your body mass index (BMI) is ${bmi.toStringAsFixed(2)}, which is high. <br>Please consider, "
          "for health reasons, adjusting your lifestyle, if possible, to include more exercises "
          "(unless a given health condition prevents you from exercising),"+
          "and a diet orientated to reducing your weight.<br>"
              "Please try reducing your intake of Carbohydrates (Sugars), unless you have received medical advice not to.<br>";
      HealthAction healthAction = HealthAction(action, rationale);
      healthActions.add(healthAction);
    }
    return healthActions;
  }

  List<HealthAction> _evalRfs(String rfs) {
    //var rfList = rfs.split(',');
    List<HealthAction> healthActions = [];
    if (rfs.isNotEmpty) {
      String action = '';
      // diet
      if (rfs.contains('Balanced diet')) {
        action =
        'Continue eating a balanced diet. When eating red meats, do so preferably together with rice<br>';
      } else {
        action =
        'Try eating enough vegetables and fruits, and lowering your carbohydrates intake.<br>'
            'Reduce consumption of red meats, and when you do, do so preferably together with rice<br>';
      }
      healthActions.add(HealthAction(action, ''));
      //
      if (rfs.contains('Exercise regularly')) {
        action =
        'You are contributing to your short and long term health by exercising regularly.<br>';
      } else {
        action =
        'Regular exercise is excellent for your body and your mind, and can have a '
            'positive impact on your health long term.<br>You should try to exercise more often, at least for 20 minutes per session, '
            'but of course, according to your health and age.<br>';
      }
      healthActions.add(HealthAction(action, ''));
      // Smoking
      if (rfs.contains('Smoking')) {
        action =
        'Smoking is proven to be an enemy of your health. It is a well known risk factor for Lung cancer, '
            'as well as other types of cancer.<br>'
            'While it can be difficult, the best for your health and those near you, would be to stop smoking.<br>';
      } else {
        action =
        'Try eating enough vegetables and fruits, and lowering your carbohydrates intake.<br>'
            'Reduce consumption of red meats, and when you do, do so preferably together with rice<br>';
      }
      healthActions.add(HealthAction(action, ''));
    }
    return healthActions;
  }

  _evalMedConds() {
    // loop through medconds, id chronic, etc
    // foreach check what we know, link with known pat data,
    // create report/recommendations
  }

}
