import 'package:flutter/material.dart';
import 'presentation/custom_icons_icons.dart';
import 'random_parser.dart';
import 'random_bases.dart';

class CharacterGenerator extends StatelessWidget {
  const CharacterGenerator({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: const StatefulCharacterGenerator(title: 'Menu'),
    );
  }
}

class StatefulCharacterGenerator extends StatefulWidget {

  const StatefulCharacterGenerator({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulCharacterGenerator> createState() => _CharacterGeneratorState();
}

class _CharacterGeneratorState extends State<StatefulCharacterGenerator> {

  TextEditingController parameterNameController = TextEditingController();
  final List<String> parameterName = <String>[];
  final List<IconData> icon = <IconData>[];
  final List<String> values = <String>[];
  final List<bool> showIcon = <bool>[];
  String dropdownValue = '';
  ReturnedObject _rO = ReturnedObject(CustomIcons.archer, '', false);

  void addItemToList(String _parameterName,IconData _icon,String _values, bool _showIcon){
    setState(() {
      parameterName.add(_parameterName);
      icon.add(_icon);
      values.add(_values);
      showIcon.add(_showIcon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character generator"),
      ),
      body: Center(
          child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: parameterName.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.purple[200],
                    margin: EdgeInsets.all(2),
                    child: Center(
                        child: RichText(text: TextSpan(
                          children: [

                          TextSpan(text: ('${parameterName[index]}: '), style: const TextStyle(color: Colors.black, fontSize: 20)),
                          TextSpan(text: '${values[index]}', style:  const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),

                          showIcon[index] ? WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(icon[index], size: 20),
                            ),
                          ): const TextSpan(text: ""),
                        ],),
                        )
                    ),
                  );
                }
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Add new paramter'),
            content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Wrap(
            children: [
              TextFormField(
                controller: parameterNameController,
                decoration: const InputDecoration(
                  hintText: 'Name, alignment etc.',
                  labelText: 'Parameter name',
                ),
              ),
              const SizedBox(height: 75),
              FutureBuilder<List<String>>(
              future: getBases(),
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  if (dropdownValue == '') {
                    dropdownValue = snapshot.data![0];
                  }
                  return DropdownButtonFormField <String>(
                    decoration: const InputDecoration(
                      labelText: 'Random value from',
                    ),
                    value: dropdownValue,
                    elevation: 16,
                    items: snapshot.data!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  );
                }else{
                   return const Text('Awaiting result...');
                }
              }
              )
            ],
          );
          },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async => {_rO = await GenerateParameter("assets/randomBases/" + dropdownValue + ".txt"), Navigator.pop(context, 'OK'), addItemToList(parameterNameController.text, _rO.icon, _rO.values, _rO.showIcon)},
                child: const Text('Add'),
              ),
            ],
            elevation: 24,
          ),
        ),
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}