import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:turn_game/util/turn_manager.dart';

class TurnPainel extends StatefulWidget {
  const TurnPainel({super.key});

  @override
  State<TurnPainel> createState() => _TurnPainelState();
}

class _TurnPainelState extends State<TurnPainel> {
  late TurnManager _turnManager;
  @override
  void initState() {
    _turnManager = BonfireInjector.instance.get();
    _turnManager.addListener(_turnListener);
    super.initState();
  }

  @override
  void dispose() {
    _turnManager.removeListener(_turnListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(child: Container()),
            Text(
              _getText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  void _turnListener() {
    setState(() {
      
    });
  }

  String _getText() {
    if (_turnManager.ownerTurn == OwnerTurn.ally) {
      return 'Ally turn';
    } else {
      return 'Enemy turn';
    }
  }
}
