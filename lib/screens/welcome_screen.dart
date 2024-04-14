import 'package:chat_app/screens/rounded_button.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
        duration: Duration(seconds: 1), vsync: this, upperBound: 1);
    // animation =
    //     CurvedAnimation(curve: Curves.decelerate, parent: animationController);
    animationController.forward();
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(animationController);
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animationController.reverse(from: 1);
    //   } else if (status == AnimationStatus.dismissed) {
    //     animationController.forward();
    //   }
    //   print(status);
    // });
    animationController.addListener(() {
      setState(() {});
      // print(animationController.value);
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController
        .dispose(); // to remove animation when this state is getting destroyed
  }

  //static variables
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'Hero',
                  child: Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Image.asset('images/chat.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Simple Chat',
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                        ),
                        speed: Duration(milliseconds: 100))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                buttonText: 'Login',
                functionNavigator: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                color: Colors.lightBlueAccent),
            RoundedButton(
                buttonText: 'Register',
                functionNavigator: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
