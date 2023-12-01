import 'package:demo_sqlite/database.dart';
import 'package:flutter/material.dart';

final dbHelper = DatabaseHelper();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final textController = new TextEditingController();
  List<String> listItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    List<String> loadedItems = [];
    final allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      loadedItems.add(row["name"]);
    }
    setState(() {
      listItem = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
            ),
            ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> row = {
                    DatabaseHelper.columnName: textController.text,
                  };
                  await dbHelper.insert(row);
                  setState(() {
                    listItem.add(textController.text);
                  });
                },
                child: Text("ADD")),
            Expanded(
                child: ListView.builder(
              itemCount: listItem.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(listItem[index]));
              },
            )),
          ],
        ),
      ),
    );
  }
}
