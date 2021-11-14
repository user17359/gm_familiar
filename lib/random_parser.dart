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
  String _value;
  String fileContent = await rootBundle.loadString(src);
  List<String> fileLines = fileContent.split("\n");
  if(fileLines[0].contains('n')) {
    int random = rng.nextInt(fileLines.length - 1);
    _showIcon = false;
    _value = fileLines[random];
  } else {
    _showIcon = true;
    _value = "placeholder";
  }
  return ReturnedObject(CustomIcons.archer, _value, _showIcon);
}