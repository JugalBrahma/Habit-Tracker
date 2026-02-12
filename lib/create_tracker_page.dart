import 'package:flutter/material.dart';

class CreateTrackerPage extends StatefulWidget {
  final String title;
  const CreateTrackerPage({super.key, required this.title});

  @override
  State<CreateTrackerPage> createState() => _CreateTrackerPageState();
}

class _CreateTrackerPageState extends State<CreateTrackerPage> {
  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),

      body: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: "eg:- Study routine, Gym..",
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w200,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
