import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:speechandgesture_user/demoTask1.dart';
import 'package:speechandgesture_user/multiTouch.dart';
import 'package:speechandgesture_user/practice1.dart';
import 'package:speechandgesture_user/practiceIntro.dart';

// void main (){
//   runApp(MaterialApp(
//       home : demoTask1()
//   ));
// }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  var isEmpty = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text ("Enter User ID", style: TextStyle(fontSize: 20, fontFamily: "Comic Sans MS"),),
            const SizedBox(
              height: 10,
            ),
            TextField(
              // onSubmitted: (String value){
              //   print(value);
              // },
              controller: _textController,
              decoration: InputDecoration(
                  hintText: 'USER ID',
                  border: OutlineInputBorder(),
                  errorText: isEmpty? 'Field Cannot Be Empty' : null,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: (){
                      _textController.clear();
                    },

                  )
              ),
            ),
            ElevatedButton(
                onPressed: (){
                  setState ((){
                    _textController.text.isEmpty ? isEmpty = true : isEmpty = false;
                  });

                  print(_textController.text);
                  if (_textController.text.isNotEmpty){

                    createUserFolder(_textController.text);
                    // print ("Path : ${createUserFolder(_textController.text)}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => practiceIntro(userID: _textController.text)),
                    );
                  }

                },
                child : Text("Submit")
            )
          ],
        ),
      ),
    );
  }
  void createUserFolder(String userID) async {
    final directory = await getExternalStorageDirectory();
    final dirPath = '${directory!.path}/${userID}' ;
    var dirExists =  await Directory(dirPath).exists();
    if (!dirExists) {
      print("Making New Directory in External Storage");
      await new Directory(dirPath).create();
    } else {
      print ("User ID and Directory already exists");
    }
    print (dirPath);
    // return dirPath;
  }
}
