
import 'package:flutter/material.dart';
import 'package:speechandgesture_user/practice1.dart';

class practiceIntro extends StatelessWidget{
  const practiceIntro({Key? key, required this.userID}) : super(key: key);
  final userID;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice DEMO"),
        centerTitle: true,
      ),
      body : const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text ("Thank You for Participating in this Pilot Study!\nThe Next Screen Will Be a Practice Task, for you to prepare for the actual task that follows. Please follow the intructions on the sheet to execute the practice task",
          style: TextStyle(fontSize: 25),),
        )
      ),
      bottomNavigationBar:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(25)
                  ),
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return practice1(userID: userID);
                        },
                      ),
                    )
                  },
                  child: Icon(Icons.arrow_forward)
              ),
            ],
          ),
        ),
      );
  }

}