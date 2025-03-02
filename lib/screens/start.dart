import 'package:flutter/material.dart';
import 'package:flutter_camera_task3/homescreen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Camera App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                },
                icon: Text(
                  'Open Camera',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    ));
  }
}
