import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

class Swipper extends StatefulWidget {
  final Function acceptMethod;
  final Function rejectMethod;

  const Swipper({Key key, this.acceptMethod, this.rejectMethod})
      : super(key: key);

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swipper> with SingleTickerProviderStateMixin {
  bool greenSize, redSize;

  @override
  void initState() {
    super.initState();
    greenSize = false;
    redSize = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        child: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Container(
            color: Colors.black45,
            child: Center(
              // todo : here's the everything
              child: Container(
                height: 80,
                width: 300,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(32)),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 150),
                            curve: Curves.easeInOutCubic,
                            width: redSize ? 80 : 56,
                            height: redSize ? 80 : 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: Icon(
                              Icons.close,
                              color: Colors.red[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 150),
                            curve: Curves.easeInOutCubic,
                            width: greenSize ? 80 : 56,
                            height: greenSize ? 80 : 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: Icon(
                              Icons.call_received,
                              color: Colors.green[400],
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Slider(
                      call: widget.acceptMethod,
                      reject: widget.rejectMethod,
                      onDragUpdateGreen: () {
                        if (greenSize == false)
                          setState(() {
                            greenSize = true;
                            print(greenSize);
                          });
                        else if (greenSize == true)
                          setState(() {
                            greenSize = false;
                            print(greenSize);
                          });
                      },
                      onDragUpdateRed: () {
                        if (redSize == false)
                          setState(() {
                            redSize = true;
                            print(redSize);
                          });
                        else if (redSize == true)
                          setState(() {
                            redSize = false;
                            print(redSize);
                          });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Slider extends StatefulWidget {
  final Function call;
  final Function reject;
  final Function onDragUpdateGreen;
  final Function onDragUpdateRed;
  final ValueChanged<double> valueChanged;

  Slider(
      {this.call,
      this.reject,
      this.onDragUpdateGreen,
      this.onDragUpdateRed,
      this.valueChanged});

  @override
  SliderState createState() {
    return new SliderState();
  }
}

class SliderState extends State<Slider> {
  ValueNotifier<double> valueListener = ValueNotifier(.5);
  bool greenSize;
  bool redSize;

  @override
  void initState() {
    valueListener.addListener(notifyParent);
    greenSize = true;
    redSize = true;
    super.initState();
  }

  void notifyParent() {
    if (widget.valueChanged != null) {
      widget.valueChanged(valueListener.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      width: 300,
      child: Builder(
        builder: (context) {
          final handle = GestureDetector(
            onHorizontalDragUpdate: (details) {
              valueListener.value =
                  (valueListener.value + details.delta.dx / context.size.width)
                      .clamp(.0, 1.0);
              if ((valueListener.value > 0.8) && greenSize) {
                widget.onDragUpdateGreen();
                greenSize = false;
              } else if ((valueListener.value < 0.8) && !greenSize) {
                widget.onDragUpdateGreen();
                greenSize = true;
              }
              if ((valueListener.value < 0.2) && redSize) {
                widget.onDragUpdateRed();
                redSize = false;
              } else if ((valueListener.value > 0.2) && !redSize) {
                widget.onDragUpdateRed();
                redSize = true;
              }
            },
            onHorizontalDragEnd: (details) {
              if (valueListener.value > 0.8) {
                valueListener.value = 1.0;
                widget.call();
              } else if (valueListener.value < 0.2) {
                valueListener.value = 0.0;
                widget.reject();
              } else
                valueListener.value = 0.5;
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: (() {
                    if ((greenSize == true) && (redSize == false))
                      return Colors.transparent;
                    else if ((redSize == true) && (greenSize == false))
                      return Colors.transparent;
                    else
                      return Colors.yellow[800];
                  }()),
                  border: Border.all(
                      color: (() {
                        if ((greenSize == true) && (redSize == false))
                          return Colors.red[400];
                        else if ((redSize == true) && (greenSize == false))
                          return Colors.green[400];
                        else
                          return Colors.transparent;
                      }()),
                      width: 2)),
              child: Icon(
                Icons.person,
                color: (() {
                  if ((greenSize == true) && (redSize == false))
                    return Colors.red[400];
                  else if ((redSize == true) && (greenSize == false))
                    return Colors.green[400];
                  else
                    return Colors.black;
                }()),
                size: ((greenSize == false) || (redSize == false)) ? 0 : 36,
              ),
            ),
          );

          return AnimatedBuilder(
            animation: valueListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(valueListener.value * 2 - 1, .5),
                child: child,
              );
            },
            child: handle,
          );
        },
      ),
    );
  }
}
