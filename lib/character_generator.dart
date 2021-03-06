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

class Parameter{
  String parameterFile;
  String parameterName;
  IconData icon;
  String values;
  bool showIcon;

  Parameter(this.parameterFile, this.parameterName, this.icon, this.values, this.showIcon);
}

class _CharacterGeneratorState extends State<StatefulCharacterGenerator> {

  TextEditingController parameterNameController = TextEditingController();
  final List<Parameter> parameters = <Parameter>[];

  String dropdownValue = '';
  ReturnedObject _rO = ReturnedObject(CustomIcons.archer, '', false);

  void addItemToList(String _parameterName,IconData _icon,String _values, bool _showIcon, String _parameterFile){
    setState(() {
      parameters.add(Parameter(_parameterFile, _parameterName, _icon, _values, _showIcon));
    });
  }

  void replaceItemInList(int id, IconData _icon,String _values, bool _showIcon){
    setState(() {
      parameters[id].icon = (_icon);
      parameters[id].values = (_values);
      parameters[id].showIcon = (_showIcon);
    });
  }

  void removeItemFromList(int id){
    setState(() {
      parameters.removeAt(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character generator"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.file_open),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(CustomIcons.dice),
            onPressed: () async => {
              for(int index = 0; index < parameters.length; index++){
                _rO = await GenerateParameter(
                    "assets/randomBases/" + parameters[index].parameterFile +
                        ".txt"),
                replaceItemInList(index, _rO.icon, _rO.values, _rO.showIcon)
              }
            },
          ),
        ],
      ),
      body: Center(
          child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: parameters.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.purple[200],
                    margin: const EdgeInsets.all(2),
                    child: Row(
                        children: [Expanded(
                          child: RichText(text: TextSpan(
                            children: [

                            TextSpan(text: ('  ${parameters[index].parameterName}: '), style: const TextStyle(color: Colors.black, fontSize: 20)),
                            TextSpan(text: parameters[index].values, style:  const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),

                            parameters[index].showIcon ? WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Icon(parameters[index].icon, size: 20),
                              ),
                            ): const TextSpan(text: ""),

                          ],),
                          ),

                        ),
                        Column(
                          children: [IconButton(
                            icon: const Icon(CustomIcons.dice),
                          color: Colors.purple,
                          onPressed: () async => {_rO = await GenerateParameter("assets/randomBases/" + parameters[index].parameterFile + ".txt"), replaceItemInList(index, _rO.icon, _rO.values, _rO.showIcon)},
                          )]
                        ),
                        Column(
                            children: [IconButton(
                              icon: const Icon(Icons.clear),
                              color: Colors.purple,
                              onPressed: () {removeItemFromList(index);},
                            )]
                        )
                    ]
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
                onPressed: () async => {_rO = await GenerateParameter("assets/randomBases/" + dropdownValue + ".txt"), Navigator.pop(context, 'OK'), addItemToList(parameterNameController.text, _rO.icon, _rO.values, _rO.showIcon, dropdownValue)},
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