import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowReportScreen extends StatefulWidget {
  static const routeName = '/show-report';

  @override
  _ShowReportScreenState createState() => _ShowReportScreenState();
}

class _ShowReportScreenState extends State<ShowReportScreen> {
  var _search = false;
  DateTime _selectedDate;

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
      print(DateFormat.yMd().format(_selectedDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Report'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _datePicker,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _search = !_search;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _search
                ? Container(
                    width: width * 0.8,
                    height: height * 0.05,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 20,
                  ),
            if (_search) SizedBox(height: 20),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FractionColumnWidth(0.4),
                1: FractionColumnWidth(0.3),
                2: FractionColumnWidth(0.3),
              },
              border: TableBorder(
                verticalInside: BorderSide(color: Colors.black),
                horizontalInside: BorderSide(color: Colors.black),
              ),
              children: [
                TableRow(
                  children: [
                    Text(
                      'Employee',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'CheckIn Time',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'CheckOut Time',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
