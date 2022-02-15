import 'package:flutter/material.dart';
import 'package:sqflite_app/src/data/model/grocery.dart';
import 'src/data/helper/local_db_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<MyApp> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: TextField(controller: textController),),
        body: FutureBuilder<List<Grocery>>(
            future: DatabaseHelper.instance.getGroceries(),
            builder: (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
              if(snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.map((grocery) {
                    return Center(
                      child: Card(
                        color: selectedId == grocery.id
                            ? Colors.white70
                            : Colors.white,
                        child: ListTile(
                          title: Text(grocery.name),
                          onTap: () {
                            setState(() {
                              if (selectedId == null) {
                                textController.text = grocery.name;
                                selectedId = grocery.id;
                              } else {
                                textController.text = '';
                                selectedId = null;
                              }
                            });
                          },
                          onLongPress: () => setState(() => DatabaseHelper.instance.remove(grocery.id!)),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Center(child: Text('Loading...'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? await DatabaseHelper.instance.update(Grocery(id: selectedId, name: textController.text))
                : await DatabaseHelper.instance.add(Grocery(name: textController.text));
            setState(() {
              textController.clear();
              selectedId = null;
            });
          },
        ),
      ),
    );
  }
}


