import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poke_app/services/services.dart';
import 'package:poke_app/utils/responsive.dart';
import 'package:poke_app/widgets/button_tap.dart';
import 'package:poke_app/widgets/input_text.dart';

class CreatePokemon extends StatefulWidget {
  const CreatePokemon({Key key}) : super(key: key);

  @override
  _CreatePokemonState createState() => _CreatePokemonState();
}

class _CreatePokemonState extends State<CreatePokemon> {
  bool _isLoading = false, _imageNull = false;
  File _image;
  String _name;
  int _ps, _atq, _df, _atqSql, _dfSql, _spl, _vel, _acc, _evs;
  GlobalKey<FormState> _formCreatePokemon = GlobalKey();
  RestClientServices _restClientServices = RestClientServices();
  final picker = ImagePicker();
  var _session = FlutterSession();

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
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }

  _showMessage(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
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

  Future<void> _createPokemon() async {
    final isOk = _formCreatePokemon.currentState.validate();
    if (isOk && _image != null) {
      _setLoading();
      Map<String, dynamic> data = {
        "photo": _image,
        "name": _name,
        "ps": _ps,
        "atq": _atq,
        "df": _df,
        "atqSql": _atqSql,
        "dfSql": _dfSql,
        "spl": _spl,
        "vel": _vel,
        "acc": _acc,
        "evs": _evs,
      };

      dynamic token = await _session.get("token");
      await _restClientServices
          .postWithImage("create-pokemon", data, token, _image.path)
          .then((response) {
        if (response.statusCode == 0) {
          _formCreatePokemon.currentState.reset();
          setState(() {
            _image = null;
          });
          _showMessage("Pokemon Created");
          Navigator.pop(context, "Created");
        } else {
          dynamic error = response.message.runtimeType == String
              ? jsonEncode(response.message)
              : response.message;
          print(error);
          //_showMessageError(error);
        }
      });
      _setLoading();
    }
  }

  Future _getImage() async {
    await picker.getImage(source: ImageSource.gallery).then((image) async {
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      } else {
        setState(() {
          _imageNull = true;
        });
        _showMessageError("Image not selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Pokemon"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Form(
                  key: _formCreatePokemon,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_image == null)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () => _getImage(),
                            child: Container(
                              width: responsive.width * 0.5,
                              height: responsive.height * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: _imageNull
                                    ? Border.all(
                                        color: Colors.red,
                                        width: responsive.width * 0.01,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    color: Colors.white,
                                    size: responsive.dp(5),
                                  ),
                                  Text(
                                    "select a image".toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: responsive.dp(2),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () => _getImage(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                                width: responsive.width * 0.5,
                                height: responsive.width * 0.5,
                              ),
                            ),
                          ),
                        ),
                      InputText(
                        width: responsive.width * 0.8,
                        formEnabled: true,
                        obscureText: false,
                        type: TextInputType.text,
                        label: "Nombre",
                        fontSize: responsive.dp(2),
                        colorText: Colors.black,
                        onChanged: (text) {
                          _name = text;
                        },
                        validator: (text) {
                          if (text.trim().length <= 0 || text.isEmpty) {
                            return "Invalid Name";
                          }
                          return null;
                        },
                      ),
                      InputText(
                        width: responsive.width * 0.8,
                        formEnabled: true,
                        obscureText: false,
                        type: TextInputType.phone,
                        label: "Puntos de Salud",
                        fontSize: responsive.dp(2),
                        colorText: Colors.black,
                        onChanged: (text) {
                          _ps = int.parse(text);
                        },
                        validator: (text) {
                          if (text.trim().length <= 0 || text.isEmpty) {
                            return "Invalid PS";
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputText(
                            width: responsive.width * 0.4,
                            formEnabled: true,
                            obscureText: false,
                            type: TextInputType.phone,
                            label: "Ataque",
                            fontSize: responsive.dp(2),
                            colorText: Colors.black,
                            onChanged: (text) {
                              _atq = int.parse(text);
                            },
                            validator: (text) {
                              if (text.trim().length <= 0 || text.isEmpty) {
                                return "Invalid ATQ";
                              }
                              return null;
                            },
                          ),
                          InputText(
                            width: responsive.width * 0.4,
                            formEnabled: true,
                            obscureText: false,
                            type: TextInputType.phone,
                            label: "Defensa",
                            fontSize: responsive.dp(2),
                            colorText: Colors.black,
                            onChanged: (text) {
                              _df = int.parse(text);
                            },
                            validator: (text) {
                              if (text.trim().length <= 0 || text.isEmpty) {
                                return "Invalid DEF";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputText(
                            width: responsive.width * 0.4,
                            formEnabled: true,
                            obscureText: false,
                            type: TextInputType.phone,
                            label: "Ataque Especial",
                            fontSize: responsive.dp(2),
                            colorText: Colors.black,
                            onChanged: (text) {
                              _atqSql = int.parse(text);
                            },
                            validator: (text) {
                              if (text.trim().length <= 0 || text.isEmpty) {
                                return "Invalid Email";
                              }
                              return null;
                            },
                          ),
                          InputText(
                            width: responsive.width * 0.4,
                            formEnabled: true,
                            obscureText: false,
                            type: TextInputType.phone,
                            label: "Defensa Especial",
                            fontSize: responsive.dp(2),
                            colorText: Colors.black,
                            onChanged: (text) {
                              _dfSql = int.parse(text);
                            },
                            validator: (text) {
                              if (text.trim().length <= 0 || text.isEmpty) {
                                return "Invalid Email";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      InputText(
                        width: responsive.width * 0.8,
                        formEnabled: true,
                        obscureText: false,
                        type: TextInputType.phone,
                        label: "Velocidad",
                        fontSize: responsive.dp(2),
                        colorText: Colors.black,
                        onChanged: (text) {
                          _vel = int.parse(text);
                        },
                        validator: (text) {
                          if (text.trim().length <= 0 || text.isEmpty) {
                            return "Invalid VEL";
                          }
                          return null;
                        },
                      ),
                      InputText(
                        width: responsive.width * 0.8,
                        formEnabled: true,
                        obscureText: false,
                        type: TextInputType.phone,
                        label: "Precision",
                        fontSize: responsive.dp(2),
                        colorText: Colors.black,
                        onChanged: (text) {
                          _acc = int.parse(text);
                        },
                        validator: (text) {
                          if (text.trim().length <= 0 || text.isEmpty) {
                            return "Invalid ACC";
                          }
                          return null;
                        },
                      ),
                      InputText(
                        width: responsive.width * 0.8,
                        formEnabled: true,
                        obscureText: false,
                        type: TextInputType.phone,
                        label: "Evasion",
                        fontSize: responsive.dp(2),
                        colorText: Colors.black,
                        onChanged: (text) {
                          _evs = int.parse(text);
                        },
                        validator: (text) {
                          if (text.trim().length <= 0 || text.isEmpty) {
                            return "Invalid EVS";
                          }
                          return null;
                        },
                      ),
                      Center(
                        child: ButtonTap(
                          width: responsive.width * 0.7,
                          text: "Create",
                          textBold: true,
                          icon: Icons.login_outlined,
                          isLoading: _isLoading,
                          onPressed: () {
                            _createPokemon();
                          },
                          iconColor: Colors.redAccent,
                          withShadow: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
