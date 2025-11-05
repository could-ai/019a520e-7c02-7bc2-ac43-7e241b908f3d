import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _timer = 30;
  Timer? _countdownTimer;
  String _result = "Waiting...";
  int? _selectedColorIndex;

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _countdownTimer?.cancel();
    _timer = 30;
    _result = "Waiting for result...";
    _selectedColorIndex = null;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        timer.cancel();
        showResult();
      }
    });
  }

  void showResult() {
    int winningColorIndex = Random().nextInt(_colors.length);
    setState(() {
      if (_selectedColorIndex != null) {
        if (_selectedColorIndex == winningColorIndex) {
          _result = "You Won!";
        } else {
          _result = "You Lost!";
        }
      } else {
        _result = "No selection made.";
      }
    });

    // Restart timer for the next round after a delay
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        startTimer();
      });
    });
  }

  void _placeBet(int index) {
    if (_timer > 5) { // Can only bet if more than 5 seconds are left
      setState(() {
        _selectedColorIndex = index;
      });
    } else {
      // Optionally show a message that betting is closed for this round
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Color Trading Game"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimerCard(),
            const SizedBox(height: 20),
            _buildResultDisplay(),
            const SizedBox(height: 20),
            _buildColorOptions(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedColorIndex != null ? () {} : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Place Trade"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Time Remaining",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "00:$_timer",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _timer <= 10 ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultDisplay() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Text(
          _result,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildColorOptions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: _colors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _placeBet(index),
          child: Container(
            decoration: BoxDecoration(
              color: _colors[index],
              borderRadius: BorderRadius.circular(8),
              border: _selectedColorIndex == index
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
