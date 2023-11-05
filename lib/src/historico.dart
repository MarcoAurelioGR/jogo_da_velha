// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> gameHistory = [];

  @override
  void initState() {
    super.initState();
    loadGameHistory();
  }

  Future<void> loadGameHistory() async {
    try {
      final patch = await getApplicationDocumentsDirectory();
      final file = File(patch.path + '/game_history.txt');
      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          gameHistory =
              contents.split('\n').where((line) => line.isNotEmpty).toList();
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading game history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              color: Color.fromRGBO(0, 122, 255, 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              'Voltar',
              style: TextStyle(
                color: Color.fromRGBO(0, 122, 255, 1),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, right: 0, bottom: 30.0),
            child: Align(
              alignment: Alignment.centerLeft, // Alinha à esquerda
              child: Text(
                'Histórico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gameHistory.length,
              itemBuilder: (context, index) {
                final gameInfo = gameHistory[index].split(",");
                final namePlayer1 = gameInfo[0];
                final namePlayer2 = gameInfo[1];
                final winner = gameInfo[2];
                final date = gameInfo[3];
                final time = gameInfo[4];

                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: namePlayer1,
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                        TextSpan(
                          text: ' vs ',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        TextSpan(
                          text: namePlayer2,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        TextSpan(
                          text: winner == 'Empate' ? ' Empate' : ' Vencedor: ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: winner == 'Empate' ? '' : winner,
                            style: TextStyle(
                                fontSize: 18,
                                color: winner == namePlayer1
                                    ? Colors.blue
                                    : Colors.red)),
                        TextSpan(
                          text: '\n$date - $time',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HistoryPage(),
  ));
}
