import 'package:flutter/material.dart';

import '../Model/universe_model.dart';


class ViewUniversPage extends StatelessWidget {
  final UniverResponse? data;

  const ViewUniversPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data?.name ?? ""),
      ),
      body: ListView.builder(
          itemCount: data?.univers.length ?? 0,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(data?.univers[index].name ?? "",style: TextStyle(color: Colors.white),),
                        Text(data?.univers[index].webPages?.first ?? "",style: TextStyle(color: Colors.white),),
                      ],
                    ),




              ),
            );
          }),
    );
  }
}