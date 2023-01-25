import 'package:rive/rive.dart';

class RiveAssets {
  final String arboard, stateMachine, tiltle;
  late SMIBool? input;
  RiveAssets(
      {required this.arboard,
      required this.stateMachine,
      required this.tiltle,
      this.input});
  set setInput(SMIBool? input) => this.input = input;
}

List<RiveAssets> botIcons = [
  RiveAssets(
      arboard: 'HOME', stateMachine: 'HOME_interactivity', tiltle: 'Home'),
  RiveAssets(
      arboard: 'SEARCH',
      stateMachine: 'SEARCH_Interactivity',
      tiltle: 'Search'),
  RiveAssets(
      arboard: 'BELL', stateMachine: 'BELL_Interactivity', tiltle: 'Events'),
  RiveAssets(
      arboard: 'USER', stateMachine: 'USER_Interactivity', tiltle: 'Users'),
  RiveAssets(
      arboard: 'SETTINGS',
      stateMachine: 'SETTINGS_Interactivity',
      tiltle: 'Settings'),
];
