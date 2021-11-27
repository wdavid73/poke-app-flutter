import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:poke_app/services/services.dart';
import 'package:poke_app/utils/my_navigator.dart';
import 'package:poke_app/utils/responsive.dart';
import 'package:poke_app/widgets/button_tap.dart';
import 'package:poke_app/widgets/input_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isLoading = false;
  var _session = FlutterSession();
  DateTime currentBackPressTime;
  String _email, _password;
  bool obscurePassword = true;
  GlobalKey<FormState> _formKeyLogIn = GlobalKey();
  final passwordField = TextEditingController();
  RestClientServices _restClientServices = RestClientServices();

  _setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _showMessageError(error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            wordSpacing: 3,
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  _login() async {
    final isOk = _formKeyLogIn.currentState.validate();
    if (isOk) {
      _setLoading();
      Map<String, dynamic> data = {
        "email": _email,
        "password": _password,
      };

      await _restClientServices.login("login", data).then((response) {
        if (response.statusCode == 0) {
          dynamic json = jsonDecode(response.data);
          _session.set("token", json["token"]);
          _formKeyLogIn.currentState.reset();
          MyNavigator.goToListPokemon(context);
        } else {
          dynamic error = jsonDecode(response.message);
          _showMessageError(error["error"]);
        }
      });
      _setLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);

    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: [
            new ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.red,
                ),
              ),
            ),
            Center(
                child: ClipRect(
              child: BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: responsive.height * 0.15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Poke APP",
                              style: TextStyle(
                                fontSize: responsive.dp(4),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: responsive.height * 0.4,
                          ),
                          Center(
                            child: Form(
                              key: _formKeyLogIn,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InputText(
                                    width: responsive.width * 0.8,
                                    formEnabled: true,
                                    obscureText: false,
                                    type: TextInputType.text,
                                    label: "email",
                                    fontSize: responsive.dp(2),
                                    colorText: Colors.white,
                                    onChanged: (text) {
                                      _email = text;
                                    },
                                    validator: (text) {
                                      if (text.trim().length <= 0 ||
                                          text.isEmpty) {
                                        return "Invalid Email";
                                      }
                                      return null;
                                    },
                                  ),
                                  InputText(
                                    width: responsive.width * 0.8,
                                    formEnabled: true,
                                    isPasswordField: true,
                                    obscureText: obscurePassword,
                                    type: TextInputType.text,
                                    label: "password",
                                    fontSize: responsive.dp(2),
                                    colorText: Colors.white,
                                    prefix: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    withPrefix: true,
                                    showPassword: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                    onChanged: (text) {
                                      _password = text;
                                    },
                                    validator: (text) {
                                      if (text.trim().length <= 0 ||
                                          text.isEmpty) {
                                        return "invalid password";
                                      }
                                      return null;
                                    },
                                    controller: passwordField,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: ButtonTap(
                              width: responsive.width * 0.7,
                              text: "Log in",
                              textBold: true,
                              icon: Icons.login_outlined,
                              isLoading: _isLoading,
                              onPressed: () {
                                _login();
                              },
                              iconColor: Colors.redAccent,
                              withShadow: false,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Press Again for Exit"),
        ),
      );
      return Future.value(false);
    }
    exit(0);
  }
}
