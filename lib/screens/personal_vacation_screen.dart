import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import '../models/firebase_notification.dart';
import '../providers/auth.dart';
import '../widgets/personal_vacation_card.dart';

class PersonalVacationsScreen extends StatefulWidget {
  static const routeName = '/personal-vacation-screen';

  @override
  _PersonalVacationsScreenState createState() =>
      _PersonalVacationsScreenState();
}

class _PersonalVacationsScreenState extends State<PersonalVacationsScreen> {
  DateTimeRange dateRange;
  String startDate;
  String endDate;
  //FirebaseNotification firebase;

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
              //print(label);
              await Provider.of<Auth>(context, listen: false)
                  .addPersonalVacation(
                startDate: startDate,
                endDate: endDate,
                label: label,
              );
              //firebase.subscribeToTopic('notify');
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
    //getDaysInBetween(dateRange.start, dateRange.end);
    startDate = dateRange.start.toString();
    endDate = dateRange.end.toString();
    _enterLabel(context);
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchPersonalVacations();
  }

  @override
  Widget build(BuildContext context) {
    final personal = Provider.of<Auth>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacations'),
        centerTitle: true,
        actions: [
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
                itemCount: personal.personalVacations.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    PersonalVacationCard(
                      label: personal.personalVacations[index].label,
                      startDate: personal.personalVacations[index].startDate,
                      endDate: personal.personalVacations[index].endDate,
                      id: personal.personalVacations[index].id,
                      status: personal.personalVacations[index].status,
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
