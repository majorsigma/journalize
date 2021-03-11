import 'package:flutter/material.dart';

class AddEditPage extends StatefulWidget {
  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  DateTime todaysDate = DateTime.now();
  TextEditingController _calendarTextEditingController;

  @override
  void initState() {
    _calendarTextEditingController =
        TextEditingController(text: todaysDate.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Hello",
                  ),
                  onTap: () {
                    Future<TimeOfDay> selectedTime = showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    selectedTime.then(
                      (value) => print("Selected time is: ${value.format(context)}"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
