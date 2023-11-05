// ignore_for_file: prefer_interpolation_to_compose_strings, depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jogo_da_velha/src/tela_inicial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class IniciarGame extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final int lenMatrix;

  const IniciarGame(this.player1Name, this.player2Name, this.lenMatrix);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<IniciarGame> {
  Color jogador1Color = Colors.blue;
  Color jogador2Color = Colors.red;
  String namePlayer1 = '';
  String namePlayer2 = '';
  String winner = '';
  String currentPlayer = '';
  int lengthMatrix = 0;

  late List<List<String>> matrix;

  @override
  void initState() {
    super.initState();
    namePlayer1 = widget.player1Name;
    namePlayer2 = widget.player2Name;
    currentPlayer = namePlayer1;

    lengthMatrix = widget.lenMatrix;
    matrix = List.generate(lengthMatrix, (_) => List.filled(lengthMatrix, ''));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          forceMaterialTransparency: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Vez do Jogador',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              currentPlayer,
              style: TextStyle(
                  fontSize: 24,
                  color: currentPlayer == namePlayer1
                      ? jogador1Color
                      : jogador2Color),
            ),
            const SizedBox(height: 50),
            buildMatrix(),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: resetGame,
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 40)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: const Text('Recomeçar'),
            ),
            ElevatedButton(
              onPressed: () {
                saveGame; // Salvar o jogo antes de voltar para a tela inicial
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaInicial()),
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
                'Novo jogo',
                style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMatrix() {
    final cellSize = 300.0 / lengthMatrix;
    final fontSize = cellSize * 0.6;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(lengthMatrix, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(lengthMatrix, (col) {
            return Container(
              width: cellSize,
              height: cellSize,
              margin: const EdgeInsets.all(0),
              child: ElevatedButton(
                onPressed: () {
                  onCellPressed(row, col);
                },
                style: ButtonStyle(
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                  ),
                  side: const MaterialStatePropertyAll(BorderSide(
                      color: Colors.black,
                      width: 0.5,
                      style: BorderStyle.solid)),
                ),
                child: Center(
                  child: Text(
                    matrix[row][col],
                    style: TextStyle(
                      fontSize: fontSize,
                      color: matrix[row][col] == 'X'
                          ? jogador1Color
                          : jogador2Color,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Future<File> get patch async {
    final patch = await getApplicationDocumentsDirectory();
    return File(patch.path + '/game_history.txt');
  }

  Future<void> get saveGame async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);
    final savedGame = '$namePlayer1,$namePlayer2,$winner,$formattedDate,$formattedTime\n';
    final file = await patch;

    file.writeAsString(savedGame, mode: FileMode.append, flush: false);
  }

  void resetGame() {
    setState(() {
      for (int i = 0; i < lengthMatrix; i++) {
        for (int j = 0; j < lengthMatrix; j++) {
          matrix[i][j] = '';
        }
      }
      saveGame;
      currentPlayer = namePlayer1;
    });
  }

  bool checkWinner() {
    // Verifica as linhas
    for (int i = 0; i < lengthMatrix; i++) {
      if (matrix[i][0] != '' &&
          matrix[i].every((cell) => cell == matrix[i][0])) {
        return true;
      }
    }

    // Verifica as colunas
    for (int i = 0; i < lengthMatrix; i++) {
      if (matrix[0][i] != '' &&
          List.generate(lengthMatrix, (j) => matrix[j][i])
              .every((cell) => cell == matrix[0][i])) {
        return true;
      }
    }

    // Verifica a diagonal principal
    if (matrix[0][0] != '' &&
        List.generate(lengthMatrix, (i) => matrix[i][i])
            .every((cell) => cell == matrix[0][0])) {
      return true;
    }

    // Verifica a diagonal secundária
    if (matrix[0][lengthMatrix - 1] != '' &&
        List.generate(lengthMatrix, (i) => matrix[i][lengthMatrix - 1 - i])
            .every((cell) => cell == matrix[0][lengthMatrix - 1])) {
      return true;
    }

    return false;
  }

  void onCellPressed(int row, int col) {
    if (matrix[row][col] == '') {
      setState(() {
        matrix[row][col] = currentPlayer == namePlayer1 ? 'X' : 'O';

        if (checkWinner()) {
          winner = currentPlayer == namePlayer1 ? namePlayer1 : namePlayer2;
          showWinnerDialog(winner);
        } else if (matrix
            .every((row) => row.every((cell) => cell.isNotEmpty))) {
          showDrawDialog();
        } else {
          currentPlayer =
              currentPlayer == namePlayer1 ? namePlayer2 : namePlayer1;
        }
      });
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vencedor'),
          content: Text('$winner venceu!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((value) {
      resetGame();
    });
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empate'),
          content: const Text('O jogo terminou em empate!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((value) {
      winner = "Empate";
      resetGame();
    });
  }
}
