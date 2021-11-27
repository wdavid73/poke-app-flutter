import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poke_app/class/pokemon.dart';
import 'package:poke_app/services/services.dart';
import 'package:poke_app/utils/my_navigator.dart';
import 'package:poke_app/utils/responsive.dart';
import 'package:poke_app/widgets/button_tap.dart';
import 'package:poke_app/widgets/input_text.dart';

class EditPokemon extends StatefulWidget {
  final int pokemonId;

  const EditPokemon({
    Key key,
    this.pokemonId,
  }) : super(key: key);

  @override
  _EditPokemonState createState() => _EditPokemonState();
}

class _EditPokemonState extends State<EditPokemon> {
  bool _isLoading = false, _imageNull = false;
  String _name, _image;
  int _ps, _atq, _df, _atqSql, _dfSql, _spl, _vel, _acc, _evs;
  GlobalKey<FormState> _formEditPokemon = GlobalKey();
  RestClientServices _restClientServices = RestClientServices();
  Pokemon pokemon;
  final picker = ImagePicker();
  var _session = FlutterSession();
  final api = "https://laravel-poke-api.herokuapp.com";

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    this._getPokemon();
    super.initState();
  }

  Future<void> _getPokemon() async {
    dynamic token = await _session.get("token");
    await _restClientServices
        .get("details-pokemon/" + widget.pokemonId.toString(), token)
        .then((response) {
      if (response.statusCode == 0) {
        var status = jsonDecode(response.data);
        if (status["status"] != "") {
          setState(() {
            pokemon = _parseData(response.data);
          });
          print(response.data);
          _setData(pokemon);
        } else {
          var error = {};
          error["error"] = "Token Expired";
          _showMessageError(error);
          var timer = Timer(
            Duration(seconds: 1),
            () => MyNavigator.goToHome(context),
          );
          timer.cancel();
        }
      } else {
        dynamic error = jsonDecode(response.message);
        _showMessageError(error["error"]);
      }
    });
  }

  Future<void> _editPokemon() async {
    final isOk = _formEditPokemon.currentState.validate();
    if (isOk) {
      _setLoading();
      Map<String, dynamic> data = {
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
          .put("update-pokemon/" + widget.pokemonId.toString(), data, token)
          .then((response) {
        if (response.statusCode == 0) {
          _showMessage("Pokemon Updated");
          Navigator.pop(context, "Updated");
        } else {
          dynamic error = jsonEncode(response.message);
          _showMessageError(error["error"]);
        }
      });
      _setLoading();
    }
  }

  _setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  _setData(Pokemon pokemon) {
    setState(() {
      _name = pokemon.name;
      _ps = pokemon.ps;
      _atq = pokemon.atq;
      _df = pokemon.df;
      _atqSql = pokemon.atqSql;
      _dfSql = pokemon.dfSql;
      _spl = pokemon.spl;
      _vel = pokemon.vel;
      _acc = pokemon.acc;
      _evs = pokemon.evs;
      _image = api + pokemon.photo;
    });
  }

  _parseData(responseBody) {
    return Pokemon.fromJson(jsonDecode(responseBody));
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

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Pokemon"),
      ),
      body: pokemon != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(""),
                    Center(
                      child: Form(
                        key: _formEditPokemon,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: responsive.width * 0.3,
                                height: responsive.height * 0.15,
                                //decoration: BoxDecoration(),
                                //child: Text("Imagen $_image"),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(),
                                  child: Image.network(
                                    _image,
                                    errorBuilder: (context, e, st) => Image(
                                      image: AssetImage(
                                        "assets/pokebola.png",
                                      ),
                                    ),
                                  ),
                                ), /**/
                              ),
                            ),
                            InputText(
                              width: responsive.width * 0.8,
                              initialValue: _name,
                              formEnabled: false,
                              obscureText: false,
                              type: TextInputType.text,
                              label: "Nombre",
                              fontSize: responsive.dp(2),
                              colorText: Colors.black,
                            ),
                            InputText(
                              width: responsive.width * 0.8,
                              initialValue: _ps.toString(),
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
                                  initialValue: _atq.toString(),
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
                                    if (text.trim().length <= 0 ||
                                        text.isEmpty) {
                                      return "Invalid ATQ";
                                    }
                                    return null;
                                  },
                                ),
                                InputText(
                                  width: responsive.width * 0.4,
                                  initialValue: _df.toString(),
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
                                    if (text.trim().length <= 0 ||
                                        text.isEmpty) {
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
                                  initialValue: _atqSql.toString(),
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
                                    if (text.trim().length <= 0 ||
                                        text.isEmpty) {
                                      return "Invalid Email";
                                    }
                                    return null;
                                  },
                                ),
                                InputText(
                                  width: responsive.width * 0.4,
                                  initialValue: _dfSql.toString(),
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
                                    if (text.trim().length <= 0 ||
                                        text.isEmpty) {
                                      return "Invalid Email";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            InputText(
                              width: responsive.width * 0.8,
                              initialValue: _vel.toString(),
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
                              initialValue: _acc.toString(),
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
                              initialValue: _evs.toString(),
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
                                text: "Update",
                                textBold: true,
                                icon: Icons.login_outlined,
                                isLoading: _isLoading,
                                onPressed: () {
                                  _editPokemon();
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
            )
          : Center(
              child: Container(
                width: responsive.width * 0.1,
                height: responsive.height * 0.05,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 3,
                ),
              ),
            ),
    );
  }
}
