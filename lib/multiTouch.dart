
import 'package:flutter/material.dart';

class multiTouch extends StatefulWidget{
  const multiTouch({Key? key}) : super(key: key);
  @override
  _multiTouch createState() => _multiTouch();

}

class _multiTouch extends State<multiTouch>{
  void _newPointer(PointerEvent details){
    print ("New Pointer added at ${details.position.dx}, ${details.position.dy}, ${details.pointer}");
  }

  void _movePointer(PointerEvent details){
    print ("Pointer moved to ${details.position.dx}, ${details.position.dy}, ${details.pointer}");
  }
  void _removePointer (PointerEvent details){
    print ("Gesture of Finger Ended to ${details.position.dx}, ${details.position.dy}, ${details.pointer}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multi Touch Demo"),
        centerTitle: true,
      ),
      body : Listener(
        onPointerDown: _newPointer,
        onPointerMove: _movePointer,
        onPointerUp: _removePointer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(width: 5, color: Colors.red)
            ),
            // child: Listener(
            //   onPointerDown:  _newPointer,
            // )
            // child: GestureDetector(
            //   onScaleStart: (details) => {
            //     print("${details.pointerCount} ${details.focalPoint.dx}")
            //   },
            //   onScaleUpdate: (details) => {
            //     print("${details.pointerCount} ${details.focalPoint.dx}")
            //   },
            //   onTap: () => {
            //     print ("Tap Detechted")
            //   },
            // ),
          ),
        ),
      )
    );
  }


}

