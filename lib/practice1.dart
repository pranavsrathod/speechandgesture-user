import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:speechandgesture_user/Task1Trial3.dart';
import 'package:speechandgesture_user/demoTask1.dart';
import 'package:speechandgesture_user/userTask1.dart';
// import 'package:speech_timestamp/googleAPI.dart';

class practice1 extends StatefulWidget{
  const practice1({Key? key, required this.userID}) : super(key: key);
  final userID;
  @override
  _practice1 createState() => _practice1(userID);
}
class _practice1 extends State<practice1>{
  _practice1(this.userID);
  final userID;
  final recorder = FlutterSoundRecorder();
  var _recorderIsReady = false;
  var _iconFlag = true;
  late DateTime recorderStart;
  late DateTime initCall;

  // late var recorderStart = startRecorder();


  Future<String> startRecorder() async {
    if (!_recorderIsReady) {
      return "Recorder Not Ready";
    }
    recorderStart = DateTime.now();
    await recorder.startRecorder(
      // codec: Codec.pcm,
        sampleRate: 16000,
        // numChannels: 1,
        // codec: Codec.pcm16WAV,
        toFile: '$dirPath/practiceTask1'
    );
    // recorderStart = DateTime.now();
    return "Started Recording";
  }
  late final startTime;
  var _lastX, _lastY;
  late final dirPath;
  // final String directory = (await getApplicationSupportDirectory()).path;
  // final path = "$directory/csv-${DateTime.now()}.csv";
  List<List<String>> data = [["User ID", "taskID", "taskType", "TimeStamp", "status", "Finger ID", "global coordinates","local coordinates", "Touch Pressure" , "intendedGesture"]];

  returnSubcollection (String status, PointerEvent details, DateTime timestamp){
    // var timeDiff = details.timeStamp.inMilliseconds;
    var timeDiff = timestamp.difference(initCall).inMilliseconds;
    data.add(["Name", "1", "touch", timeDiff.toString(), status, details.pointer.toString(), [details.position.dx, details.position.dy].toString(),[details.localPosition.dx, details.localPosition.dy].toString(), details.pressure.toString(), "select object"]);

    // return newSubCollection;
  }

  // addToList(PointerEvent details, String status) {
  //   returnSubcollection(status, x, y, DateTime.now().millisecondsSinceEpoch.toString());
  // }

  void addTouchStart(PointerEvent details){
    returnSubcollection("Touch Start", details, DateTime.now());
    // returnSubcollection("Touch Start", details.position.dx, details.position.dy, details.timeStamp, details.localPosition.dx, details.localPosition.dy, details.pressure);
  }

  void addTouchUpdate(PointerEvent details){
    returnSubcollection("Touch Update", details, DateTime.now());
    // returnSubcollection("Touch Start", details.position.dx, details.position.dy, details.timeStamp, details.localPosition.dx, details.localPosition.dy, details.pressure);
  }

  void addTouchEnd(PointerEvent details){
    returnSubcollection("Touch End", details, DateTime.now());
    // returnSubcollection("Touch Start", details.position.dx, details.position.dy, details.timeStamp, details.localPosition.dx, details.localPosition.dy, details.pressure);
  }


  Future stopRecorder() async {
    if (!_recorderIsReady) {
      return;
    }
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print(path);
    print(audioFile.toString());
    // print ('Recorded Audio $audioFile');
    var _fileBytes = await audioFile.readAsBytes();
    var _base64String = base64Encode(_fileBytes);

    var audioCSV = [["recorderStartAt", "audioBase64", "audioFilePath"], [recorderStart.millisecondsSinceEpoch.toString(), _base64String, audioFile.toString()]];
    String csvData = ListToCsvConverter().convert(audioCSV);
    // final String directory = (await getApplicationSupportDirectory()).path;
    // final audioCSVpath = "$dirPath/audioCSV.csv";
    // print(audioCSVpath);
    // final File file = File(audioCSVpath);
    // await file.writeAsString(csvData);
    // var encoded = {
    //   "audioBase64": _base64String,
    //   "start": _startTime,
    //   "end": _endTime
    // };
    // print(_base64String);

    // logging the data to the firebase collection.
    // var db = FirebaseFirestore.instance;
    // db.collection("audio").add(encoded).then((value) =>
    //     print("Recording Logged Successfully"));
  }

  Future<String> initRecorder() async {
    // late DateTime initCall;
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Cannot Record, Microphone Permission Not Granted';
    }
    await recorder.openRecorder(
      // focus: AudioFocus.requestFocusAndStopOthers,
    );
    _recorderIsReady = true;
    print(DateTime.now().millisecondsSinceEpoch);
    await startRecorder();

    startTime = DateTime.now().millisecondsSinceEpoch;
    return "Recorder Initialised";
  }
  void createTaskDirectory() async {
    final directory = await getExternalStorageDirectory();
    dirPath = '${directory!.path}/${userID}/demoTask' ;
    print(dirPath);
    var dirExists =  await Directory(dirPath).exists();
    if (!dirExists) {
      // print("Making New Directory in External Storage");
      await new Directory(dirPath).create();
    }
  }

  @override
  void initState() {
    initCall = DateTime.now();
    createTaskDirectory();
    super.initState();
    initRecorder();

    // startRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Practice Task"),
              centerTitle: true,
      ),
      body: Center(
        child: Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Text ("Make Gesture on the Image"),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Listener(
                  onPointerDown: addTouchStart,
                  onPointerMove: addTouchUpdate,
                  onPointerUp: addTouchEnd,
                  child:
                  Image.network('https://st.depositphotos.com/1646176/2736/i/950/depositphotos_27369537-stock-photo-child-on-the-road.jpg'),
                ),
              ),
              // ElevatedButton (
              //   style: ElevatedButton.styleFrom(
              //       shape: CircleBorder(),
              //       padding : EdgeInsets.all(20)
              //   ),
              //   onPressed: () async {
              //     setState ((){});
              //     if (recorder.isRecording) {
              //       // _endTime = DateTime.now();
              //       _iconFlag = false;
              //       await stopRecorder();
              //
              //     } else {
              //       _iconFlag = true;
              //       await startRecorder();
              //       // _startTime = DateTime.now();
              //     }
              //   },
              //   child: Icon (
              //     (_iconFlag)? Icons.mic : Icons.mic_off,
              //     size: 75,
              //     color: Colors.black,
              //   ),
              // ),
              // Text(recorder.isRecording? "Recording In Progress," : "Turn On Mic To Record"),
            ]
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(25)
                ),
                onPressed: generateCSV,
                child: Icon(Icons.arrow_forward)
            ),
          ],
        ),
      ),
    );

  }

  generateCSV() async {

    print(data);
    String csvData = ListToCsvConverter().convert(data);
    // final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$dirPath/practiceTask1.csv";
    final File file = File(path);
    await file.writeAsString(csvData);
    // await Share.shareFiles([path], text: "User : ${userID} - Task 1");
    print(path);

    if (!_recorderIsReady) {
      return;
    }
    final audioPath = await recorder.stopRecorder();
    // final audioFile = File(path!);

    print(audioPath);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return userTask1(
            userID: userID,
            trialNum: 1,
          );
        },
      ),
    );
  }

}