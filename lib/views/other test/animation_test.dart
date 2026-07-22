import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollListView extends StatefulWidget {
  const AutoScrollListView({super.key});

  @override
  _AutoScrollListViewState createState() => _AutoScrollListViewState();
}

class _AutoScrollListViewState extends State<AutoScrollListView> {
  ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _scrollIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start a timer to trigger scrolling every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _autoScrollList();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    _scrollController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _autoScrollList() {
    // Calculate the next index to scroll to
    _scrollIndex++;
    if (_scrollIndex >= 10) {
      _scrollIndex = 0; // Reset index when reaching the end
    }

    // Animate the list to the new index
    _scrollController.animateTo(
      _scrollIndex * 100.0, // Adjust item size if necessary
      duration: Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auto Scroll ListView')),
      body: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blue,
            child: Center(
              child: Text(
                'Item $index',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}

// void main() => runApp(MaterialApp(home: AutoScrollListView()));
