import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart';

void main()=> runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin
{
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future _startAnimation() async
  {
    try
    {
      await animationController.forward().orCancel;
      await animationController.reverse().orCancel;
    } on TickerCanceled
    {
      print('Animation failed');
    }
  }

  @override
  Widget build(BuildContext context) {

    timeDilation = 15.0;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animations'),
        ),
        body: GestureDetector(
          onTap: ()
          {
            _startAnimation();
          },
          child: Center(
            child: Container(
              width: 350.0,
              height: 350.0,
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.6),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.8))
              ),
              child: AnimatedBox(controller: animationController,),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {

  AnimatedBox({Key key, this.controller})
  : opacity = Tween<double>(
    begin: 0.0,
    end: 1.0
  ).animate(
    CurvedAnimation(parent: controller, curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn))
  ), rotate = Tween<double>(
    begin: 0.0,
    end: 3.141 * 4
  ).animate(
    CurvedAnimation(parent: controller, curve: Interval(0.1, 0.3, curve: Curves.easeIn))
  ), movement = EdgeInsetsTween(
    begin: EdgeInsets.only(bottom: 10.0, left: 0.0),
    end: EdgeInsets.only(bottom: 100.0, left: 75.0)
  ).animate(
    CurvedAnimation(parent: controller, curve: Interval(0.3, 0.4, curve: Curves.fastOutSlowIn))
  ), width = Tween<double>(
    begin: 50.0,
    end: 200.0
  ).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.3, 0.6, curve: Curves.fastOutSlowIn))
  ), height = Tween<double>(
      begin: 50.0,
      end: 200.0
  ).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.4, 0.6, curve: Curves.fastOutSlowIn))
  ),
  radius = BorderRadiusTween(
    begin: BorderRadius.circular(0.0),
    end: BorderRadius.circular(100.0)
  ).animate(
      CurvedAnimation(parent: controller, curve: Interval(0.5, 0.75, curve: Curves.ease))
  ), color = ColorTween(
    begin: Colors.black38,
    end: Colors.yellow
  ).animate(
    CurvedAnimation(parent: controller, curve: Interval(0.0, 0.75, curve: Curves.linear))
  ), super(key : key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> movement;
  final Animation<BorderRadius> radius;
  final Animation<Color> color;
  final Animation<double> rotate;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child)
        {
          return Container(
            padding: movement.value,
            transform: Matrix4.identity()..rotateZ(rotate.value),
            alignment: Alignment.center,
            child: Opacity(
              opacity: opacity.value,
              child: Container(
                width: width.value,
                height: height.value,
                decoration: BoxDecoration(
                  color: color.value,
                  border: Border.all(
                    color: Colors.orange,
                    width: 3.0,
                  ),
                  borderRadius: radius.value
                ),
              ),
            ),

          );
        }
    );
  }
}

