import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'newVersion.dart';
import 'stepper.dart';

Offset _offset = Offset.zero; // changed
double gauche = 0;
double droite = 0;
String accept = " ";

class SwipeFinal extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<SwipeFinal> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 30),
              child: Container(
                child: Swipper(
                  // todo: add the call and reject methods
                  acceptMethod: () {
                    setState(() {
                      accept = 'accept';
                    });
                  },
                  rejectMethod: () {
                    setState(() {
                      accept = 'Declined';
                    });
                  },
                ),
              ),
            ),
            Center(
                child: Container(
              height: 96,
              width: MediaQuery.of(context).size.width - 80,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.grey,
                      ),
                      height: 48,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(
                              Icons.call_received,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: StepperSwipe(
                      withBackground: false,
                      initialValue: 0,
                      speedTransitionLimitCount: 3,
                      firstIncrementDuration: Duration(milliseconds: 500),
                      secondIncrementDuration: Duration(milliseconds: 400),
                      direction: Axis.horizontal,
                      dragButtonColor: Colors.black,
                      withSpring: true,
                      maxValue: 50,
                      stepperValue: 0,
                      withFastCount: true,
                      onChanged: (int val) {
                        print('New value : $val');
                        setState(() {
                          val > 0 ? accept = 'accept' : accept = 'Declined';
                        });
                      },
                    ),
                  ),
                  /*Center(
                    child: Transform.translate(
                      offset: Offset(gauche, droite),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          if (details.delta.dx > 0) {
                            if (gauche + details.delta.distance < 118)
                              setState(() => gauche += details.delta.distance);
                            if (gauche > 100)
                              setState(() {
                                accept = "Accepted";
                              });
                          }
                          if (details.delta.dx < 0) {
                            if (gauche - details.delta.distance > -118)
                              setState(() => gauche -= details.delta.distance);
                            if (gauche < -100)
                              setState(() {
                                accept = "Declined";
                              });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          height: 76,
                          width: 76,
                          child: Icon(
                            Icons.person_pin_circle,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 88.0),
              child: Column(
                children: <Widget>[
                  Text("State is :\n"),
                  Text(
                    accept,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            accept == "Declined" ? Colors.red : Colors.green),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
