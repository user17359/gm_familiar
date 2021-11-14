import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'presentation/custom_icons_icons.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class ReturnedObject {
  IconData icon;
  String values;
  bool showIcon;

  ReturnedObject(this.icon, this.values, this.showIcon);
}

Future<ReturnedObject> GenerateParameter(String src) async {
  var rng = new Random();
  bool _showIcon;
  IconData _icon = CustomIcons.archer;
  String _value;
  String fileContent = await rootBundle.loadString(src);
  List<String> fileLines = fileContent.split("\n");
  int random = (rng.nextInt(fileLines.length - 1) + 1);
  if(fileLines[0].contains('n')) {
    _showIcon = false;
    _value = fileLines[random];
  } else {
    _showIcon = true;
    List<String> parametersInLine = fileLines[random].split(";");
    String _temp = parametersInLine[1].trimRight();
    _value = parametersInLine[0];
    print(parametersInLine[1]);
    print(getIcons.containsKey(parametersInLine[1]));
    _icon = getIcons[_temp] ?? CustomIcons.plain_dagger;
  }
  return ReturnedObject(_icon, _value, _showIcon);
}