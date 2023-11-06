import 'dart:async';
import 'dart:math';

Future<List<int>> botMove(List<List<String>> matrix) async {
  await Future.delayed(const Duration(milliseconds: 400));

  final emptyCells = <List<int>>[];

  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      if (matrix[i][j].isEmpty) {
        emptyCells.add([i, j]);
      }
    }
  }

  if (emptyCells.isNotEmpty) {
    final random = Random();
    final randomMove = emptyCells[random.nextInt(emptyCells.length)];
    return randomMove;
  }

  return [];
}

bool checkWinner(matrix) {
  // Verifica as linhas
  for (int i = 0; i < matrix.length; i++) {
    if (matrix[i][0] != '' && matrix[i].every((cell) => cell == matrix[i][0])) {
      return true;
    }
    // Verifica as colunas
    if (matrix[0][i] != '' &&
        List.generate(matrix.length, (j) => matrix[j][i])
            .every((cell) => cell == matrix[0][i])) {
      return true;
    }
  }

  // Verifica a diagonal principal
  if (matrix[0][0] != '' &&
      List.generate(matrix.length, (i) => matrix[i][i])
          .every((cell) => cell == matrix[0][0])) {
    return true;
  }

  // Verifica a diagonal secundária
  if (matrix[0][matrix.length - 1] != '' &&
      List.generate(matrix.length, (i) => matrix[i][matrix.length - 1 - i])
          .every((cell) => cell == matrix[0][matrix.length - 1])) {
    return true;
  }

  return false;
}
