import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:hive/hive.dart';
import 'package:hive_app/person_model.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
      title: 'Hive',
      theme: ThemeData(
        useMaterial3: true,
        
      ),
      home: const MyHomePage(title: 'Hive Lesson'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<Person>? box;
  final name = TextEditingController();
  final age = TextEditingController();

  void _incrementCounter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                ),
                TextFormField(
                  controller: age,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    box!.put(
                        DateTime.now().toString(),
                        Person(
                            name: name.text, age: int.tryParse(age.text) ?? 0));
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Save'))
            ],
          );
        });
  }

  hiveInit() async {
    box = await Hive.openBox('myBox');
    setState(() {});
  }

  @override
  void initState() {
    hiveInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20),
          itemCount: box?.values.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Name: ${box?.values.elementAt(index).name ?? ''}'),
                      Text('Age: ${(box?.values.elementAt(index).age ?? '').toString()}'),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        box?.deleteAt(index);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            );
          }),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
