import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:turn_game/game.dart';
import 'package:turn_game/turn_manager.dart';

Vector2 tileSize = Vector2.all(16);
void main() {
  BonfireInjector.instance.put((i) => TurnManager());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TurnGame(),
    );
  }
}
