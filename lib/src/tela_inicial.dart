// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:jogo_da_velha/src/game.dart';
import 'package:jogo_da_velha/src/historico.dart';

void main() {
  runApp(TelaInicial());
}

class PlayerNameModel {
  String player1Name;

  PlayerNameModel({required this.player1Name});
}

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController player1Controller = TextEditingController();

  bool showSinglePlayerNameField = true;
  List<bool> isSelectedPlayer = [true, false];
  List<bool> isSelectedMatriz = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController player2Controller =
        TextEditingController(text: !showSinglePlayerNameField ? "Bot" : "");

    int indexIsSelected =
        isSelectedMatriz.indexWhere((isSelected) => isSelected);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo-jogo-da-velha.png',
                  fit: BoxFit.cover),
            ],
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              const Text('Tipo de jogo', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ToggleButtons(
                    isSelected: isSelectedPlayer,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelectedPlayer.length;
                            buttonIndex++) {
                          isSelectedPlayer[buttonIndex] = false;
                          isSelectedPlayer[buttonIndex] = buttonIndex == index;
                        }
                        showSinglePlayerNameField = index == 0;
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 150.0,
                    ),
                    borderWidth: 3,
                    selectedBorderColor:
                        const Color.fromRGBO(118, 118, 128, 0.12),
                    borderColor: const Color.fromRGBO(118, 118, 128, 0.12),
                    children: isSelectedPlayer.asMap().entries.map((entry) {
                      int index = entry.key;
                      bool selected = entry.value;
                      
                      return Container(
                        width: 150,
                        height: 40,
                        alignment: Alignment.center,
                        color: selected
                            ? Colors.white
                            : const Color.fromRGBO(118, 118, 128, 0.12),
                        child: Text(index == 0 ? "vs Jogador" : "vs Bot"),
                      );
                    }).toList(),
                  )
                ],
              ),
              const SizedBox(height: 50),
              const Text('Nome dos jogadores', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 300,
                          height: 40,
                          child: TextFormField(
                            controller: player1Controller,
                            decoration: const InputDecoration(
                              labelText: 'Jogador 1',
                            ),
                            validator: (value) {
                              if (value == "") {
                                return 'Este campo é obrigatório.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 300,
                          height: 40,
                          child: TextFormField(
                            controller: player2Controller,
                            readOnly: !showSinglePlayerNameField,
                            decoration: const InputDecoration(
                              labelText: 'Jogador 2',
                            ),
                            validator: (value) {
                              if (value == "") {
                                return 'Este campo é obrigatório.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50),
              const Text('Tamanho do tabuleiro',
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Container(
                constraints: const BoxConstraints(maxWidth: 300, maxHeight: 40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ToggleButtons(
                    isSelected: isSelectedMatriz,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelectedMatriz.length;
                            buttonIndex++) {
                          isSelectedMatriz[buttonIndex] = buttonIndex == index;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    borderWidth: 3,
                    selectedBorderColor:
                        const Color.fromRGBO(118, 118, 128, 0.12),
                    borderColor: const Color.fromRGBO(118, 118, 128, 0.12),
                    children: isSelectedMatriz.asMap().entries.map((entry) {
                      int index = entry.key;
                      bool selected = entry.value;
                      final buttonText = '${index + 3}x${index + 3}';
                      return Container(
                        width: 150,
                        height: 40,
                        alignment: Alignment.center,
                        color: selected
                            ? Colors.white
                            : const Color.fromRGBO(118, 118, 128, 0.12),
                        child: Text(buttonText),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IniciarGame(
                          player1Controller.text,
                          player2Controller.text,
                          indexIsSelected + 3,
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(300, 40)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Text('Começar Partida'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 218, 236, 255)),
                  minimumSize: MaterialStateProperty.all(const Size(300, 40)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Histórico de Partidas',
                  style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
