import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> getBases () async{

  // >> To get paths you need these 2 lines
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  // >> To get paths you need these 2 lines

  final paths = manifestMap.keys
      .where((String key) => key.contains('randomBases/'))
      .where((String key) => key.contains('.txt'))
      .toList();


  List<String> shortPaths = <String>[];
  for (var path in paths) {
    String workingCopy = path.replaceAll('assets/randomBases/', '');
    shortPaths.add(workingCopy.replaceAll('.txt', ''));
  }
  return shortPaths;
}