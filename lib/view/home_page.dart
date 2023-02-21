import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_app/view/universe_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:http/http.dart' as http;

import '../Model/universe_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<UniverResponse>? box;
  UniverResponse? data;
  final name = TextEditingController();

  void _incrementConter(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Name"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    var res = await http.get(Uri.parse(
                        "http://universities.hipolabs.com/search?country=${name.text}"));
                    data = UniverResponse.fromJson(
                        jsonDecode(res.body), name.text);
                    box!.put(name.text,
                        data ?? UniverResponse(univers: [], name: name.text));
                    //Person newPerson = Person.fromJson(jsonDecode(res.body));
                    //box!.put(name.text, newPerson);
                    setState(() {});
                    Navigator.pop(context);
                    name.clear();
                  },
                  child: const Text("Save"))
            ],
          );
        });
  }

  hiveInit() async {
    box = await Hive.openBox<UniverResponse>('myBox3');
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
          title: const Text("hive"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: box?.values.length ?? 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewUniversPage(
                                data: box?.values.elementAt(index))));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8, top: 10),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(4, 10),
                              blurRadius: 5),
                        ],
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(box?.values.elementAt(index).name ?? "",style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              box?.deleteAt(index);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                );
              }),
        ),

        // ListView.builder(
        //     itemCount: box?.values.length ?? 0,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 24),
        //         child: Container(
        //           margin: const EdgeInsets.only(bottom: 8,top: 10),
        //           padding: const EdgeInsets.all(24),
        //           decoration: BoxDecoration(
        //             boxShadow:[
        //               BoxShadow(
        //                 color: Colors.grey.withOpacity(0.5),
        //                 offset: const Offset(4,10),
        //                 blurRadius: 5
        //               ),
        //             ],
        //               color: Colors.blue,
        //               borderRadius: BorderRadius.circular(24)
        //           ),
        //           child: Row(
        //             children: [
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 children: [
        //                   Text(box?.values.elementAt(index).name ?? ''),
        //                   Text((box?.values.elementAt(index).count ?? '').toString()),
        //                 ],
        //               ),
        //               Spacer(),
        //               IconButton(
        //                   onPressed: () {
        //                     box?.deleteAt(index);
        //                     setState(() {});
        //                   },
        //                   icon: const Icon(Icons.delete,color: Colors.grey,))
        //             ],
        //           ),
        //         ),
        //       );
        //     }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _incrementConter(context);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
