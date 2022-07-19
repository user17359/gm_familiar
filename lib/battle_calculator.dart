import 'package:flutter/material.dart';
import 'presentation/custom_icons_icons.dart';

class BattleCalculator extends StatelessWidget {
  const BattleCalculator({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const StatefulBattleCalculator(title: 'Menu'),
    );
  }
}

class StatefulBattleCalculator extends StatefulWidget {

  const StatefulBattleCalculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulBattleCalculator> createState() => _BattleCalculatorState();
}

class _BattleCalculatorState extends State<StatefulBattleCalculator> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battle calculator"),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.purple[300],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("Party 1", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(CustomIcons.dice_d20),
                        label: const Text('Random Character Generator'),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              )
            ),
            Padding(padding: const EdgeInsets.all(5.0)),
            Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.purple[300],
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Party 2", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
            ),
          ],
        )
      )
    );
  }
}