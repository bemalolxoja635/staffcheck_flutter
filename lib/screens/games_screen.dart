import 'package:flutter/material.dart';
import 'dart:math';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late List<List<int>> grid;
  int score = 0;
  bool isGameOver = false;
  final int size = 4;

  @override
  void initState() {
    super.initState();
    _initGrid();
  }

  void _initGrid() {
    grid = List.generate(size, (_) => List.filled(size, 0));
    score = 0;
    isGameOver = false;
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    List<Point<int>> emptySpots = [];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) emptySpots.add(Point(r, c));
      }
    }
    if (emptySpots.isEmpty) return;
    
    var random = Random();
    var point = emptySpots[random.nextInt(emptySpots.length)];
    grid[point.x][point.y] = random.nextInt(10) < 9 ? 2 : 4;
  }

  void _checkGameOver() {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) return;
        if (r > 0 && grid[r][c] == grid[r - 1][c]) return;
        if (r < size - 1 && grid[r][c] == grid[r + 1][c]) return;
        if (c > 0 && grid[r][c] == grid[r][c - 1]) return;
        if (c < size - 1 && grid[r][c] == grid[r][c + 1]) return;
      }
    }
    setState(() => isGameOver = true);
  }

  void _handleSwipe(DragEndDetails details) {
    if (isGameOver) return;
    
    bool moved = false;
    double dx = details.velocity.pixelsPerSecond.dx;
    double dy = details.velocity.pixelsPerSecond.dy;

    if (dx.abs() > dy.abs()) {
      if (dx > 0) moved = _moveRight();
      else moved = _moveLeft();
    } else {
      if (dy > 0) moved = _moveDown();
      else moved = _moveUp();
    }

    if (moved) {
      setState(() {
        _addRandomTile();
        _checkGameOver();
      });
    }
  }

  bool _moveLeft() {
    bool moved = false;
    for (int r = 0; r < size; r++) {
      List<int> row = grid[r].where((val) => val != 0).toList();
      for (int i = 0; i < row.length - 1; i++) {
        if (row[i] == row[i + 1]) {
          row[i] *= 2;
          score += row[i];
          row.removeAt(i + 1);
          moved = true;
        }
      }
      while (row.length < size) {
        row.add(0);
      }
      for (int c = 0; c < size; c++) {
        if (grid[r][c] != row[c]) moved = true;
        grid[r][c] = row[c];
      }
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int r = 0; r < size; r++) {
      List<int> row = grid[r].where((val) => val != 0).toList();
      for (int i = row.length - 1; i > 0; i--) {
        if (row[i] == row[i - 1]) {
          row[i] *= 2;
          score += row[i];
          row.removeAt(i - 1);
          i--;
          moved = true;
        }
      }
      while (row.length < size) {
        row.insert(0, 0);
      }
      for (int c = 0; c < size; c++) {
        if (grid[r][c] != row[c]) moved = true;
        grid[r][c] = row[c];
      }
    }
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    for (int c = 0; c < size; c++) {
      List<int> col = [];
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != 0) col.add(grid[r][c]);
      }
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          score += col[i];
          col.removeAt(i + 1);
          moved = true;
        }
      }
      while (col.length < size) {
        col.add(0);
      }
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != col[r]) moved = true;
        grid[r][c] = col[r];
      }
    }
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    for (int c = 0; c < size; c++) {
      List<int> col = [];
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != 0) col.add(grid[r][c]);
      }
      for (int i = col.length - 1; i > 0; i--) {
        if (col[i] == col[i - 1]) {
          col[i] *= 2;
          score += col[i];
          col.removeAt(i - 1);
          i--;
          moved = true;
        }
      }
      while (col.length < size) {
        col.insert(0, 0);
      }
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != col[r]) moved = true;
        grid[r][c] = col[r];
      }
    }
    return moved;
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2: return Colors.orange[100]!;
      case 4: return Colors.orange[200]!;
      case 8: return Colors.orange[300]!;
      case 16: return Colors.orange[400]!;
      case 32: return Colors.orange[500]!;
      case 64: return Colors.deepOrange[400]!;
      case 128: return Colors.deepOrange[500]!;
      case 256: return Colors.red[400]!;
      case 512: return Colors.red[500]!;
      case 1024: return Colors.yellow[600]!;
      case 2048: return Colors.amber[700]!;
      default: return Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048 Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initGrid()),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          GestureDetector(
            onPanEnd: _handleSwipe,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: size * size,
                itemBuilder: (context, index) {
                  int r = index ~/ size;
                  int c = index % size;
                  int val = grid[r][c];
                  return Container(
                    decoration: BoxDecoration(
                      color: _getTileColor(val),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        val == 0 ? '' : '$val',
                        style: TextStyle(
                          fontSize: val > 100 ? 20 : 28,
                          fontWeight: FontWeight.bold,
                          color: val > 4 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (isGameOver)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Game Over!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
