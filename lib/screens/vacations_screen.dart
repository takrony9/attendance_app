import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_mode.dart';
import '../providers/auth.dart';
import '../widgets/vacation_card.dart';

class VacationsScreen extends StatefulWidget {
  static const routeName = '/vacation-screen';

  @override
  _VacationsScreenState createState() => _VacationsScreenState();
}

class _VacationsScreenState extends State<VacationsScreen> {
  DateTimeRange dateRange;
  List<String> vacations = [];

  void _enterLabel(BuildContext context) {
    String label;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Enter Vacation Label'),
        content: TextField(
          onChanged: (value) {
            label = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () async {
              print(label);
              await Provider.of<Auth>(context, listen: false).addVacation(
                date: vacations,
                label: label,
              );
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void pickDateRange() async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 3)),
    );
    final newDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );
    if (newDateRange == null) return;
    setState(() => dateRange = newDateRange);
    getDaysInBetween(dateRange.start, dateRange.end);
    _enterLabel(context);
  }

  void getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)).toString());
    }
    print(days);
    vacations = days;
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchVacations();
  }

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    final vacation = Provider.of<Auth>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacations'),
        centerTitle: true,
        actions: [
          if (userMode.mode != 'user')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: pickDateRange,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vacation.vacations.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    VacationCard(
                      date: vacation.vacations[index].vacation,
                      label: vacation.vacations[index].label,
                      id: vacation.vacations[index].id,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
