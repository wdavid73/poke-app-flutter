import 'package:flutter/cupertino.dart';
import 'package:poke_app/pages/home/home.dart';
import 'package:poke_app/pages/pokemon/create_pokemon.dart';
import 'package:poke_app/pages/pokemon/edit_pokemon.dart';
import 'package:poke_app/pages/pokemon/list_pokemon.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return MyHomePage();
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> anotherAnimation, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (_) => false,
    );
  }

  static void goToListPokemon(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return ListPokemon();
        },
        /*transitionDuration: Duration(milliseconds: 500),*/
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> anotherAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
      (_) => false,
    );
  }

  static void goToCreatePokemon(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return CreatePokemon();
        },
        /*transitionDuration: Duration(milliseconds: 500),*/
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> anotherAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  static void goToEditPokemon(BuildContext context, pokemonId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return EditPokemon(
            pokemonId: pokemonId,
          );
        },
        /*transitionDuration: Duration(milliseconds: 500),*/
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> anotherAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }
}
