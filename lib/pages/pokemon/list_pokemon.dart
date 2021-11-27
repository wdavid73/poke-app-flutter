import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:poke_app/class/pokemon.dart';
import 'package:poke_app/pages/pokemon/create_pokemon.dart';
import 'package:poke_app/services/services.dart';
import 'package:poke_app/utils/my_navigator.dart';
import 'package:poke_app/utils/responsive.dart';

class ListPokemon extends StatefulWidget {
  const ListPokemon({Key key}) : super(key: key);

  @override
  _ListPokemonState createState() => _ListPokemonState();
}

class _ListPokemonState extends State<ListPokemon> {
  var _session = FlutterSession();
  var _isLoading = false;
  List<Pokemon> pokemon = [];
  RestClientServices _restClientServices = RestClientServices();

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
    print("get pokemon");
    _setLoading();
    dynamic token = await _session.get("token");
    await _restClientServices.get("get-pokemon", token).then((response) {
      if (response.statusCode == 0) {
        print("pokemon : ${response.data}");
        var status = jsonDecode(response.data);
        if (status["status"] != "") {
          setState(() {
            pokemon = _parseData(response.data);
          });
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
    _setLoading();
  }

  Future<void> _deletePokemon(pokemonId) async {
    dynamic token = await _session.get("token");
    await _restClientServices
        .delete("delete-pokemon/" + pokemonId.toString(), token)
        .then(
      (response) {
        if (response.statusCode == 0) {
          var status = jsonDecode(response.data);
          if (status["status"] != "") {
            Navigator.pop(context);
            _getPokemon();
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Pokemon Deleted')));
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
          print(response.message);
          dynamic error = jsonDecode(response.message);
          _showMessageError(error["error"]);
        }
      },
    );
  }

  _logout() async {
    dynamic token = await _session.get("token");
    await _restClientServices.logout(token).then((response) {
      if (response.statusCode == 0) {
        _session.set("token", "");
        MyNavigator.goToHome(context);
      } else {
        dynamic error = jsonDecode(response.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error["error"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                wordSpacing: 3,
              ),
            ),
            duration: Duration(seconds: 10),
          ),
        );
      }
    });
  }

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

  showAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _deletePokemon(id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Pokemon",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      content: Text(
        "Are you sure about delete this pokemon?",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
      backgroundColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _parseData(responseBody) {
    final parsed =
        jsonDecode(responseBody)["pokemon"].cast<Map<String, dynamic>>();
    return parsed.map<Pokemon>((json) => Pokemon.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive(context);
    final api = "https://laravel-poke-api.herokuapp.com";
    return Scaffold(
      appBar: AppBar(
        title: Text("List Pokemon"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: _isLoading
            ? Center(
                child: Container(
                  width: responsive.width * 0.1,
                  height: responsive.height * 0.05,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.redAccent,
                    strokeWidth: 3,
                  ),
                ),
              )
            : GridView.count(
                padding: const EdgeInsets.all(8),
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                shrinkWrap: true,
                children: List.generate(
                  pokemon.length,
                  (index) {
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        overlayColor: MaterialStateProperty.all(
                          Colors.blueAccent,
                        ),
                        onLongPress: () {
                          showAlertDialog(context, pokemon[index].id);
                        },
                        onTap: () {
                          MyNavigator.goToEditPokemon(
                              context, pokemon[index].id);
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: responsive.width * 0.3,
                                  height: responsive.height * 0.15,
                                  //decoration: BoxDecoration(),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(),
                                    child: Image.network(
                                      api + pokemon[index].photo,
                                      errorBuilder: (context, e, st) => Image(
                                        image: AssetImage(
                                          "assets/pokebola.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '${pokemon[index].name}'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.dp(2.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndDisplaySelection(context);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePokemon()),
    );

    if (result != null) {
      _getPokemon();
    }
  }
}
