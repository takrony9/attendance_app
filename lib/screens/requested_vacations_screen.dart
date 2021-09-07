import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_mode.dart';
import '../providers/auth.dart';
import '../widgets/requested_vacation_card.dart';

class RequestedVacationsScreen extends StatelessWidget {
  static const routeName = '/requested-vacations';

  Future<void> _refresh(BuildContext context, String userMode) async {
    await Provider.of<Auth>(context, listen: false)
        .fetchRequestedVacations(userMode);
  }

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    final requestedVacation = Provider.of<Auth>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Requested Vacations'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context, userMode.mode),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: requestedVacation.requestedVacations.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    RequestedVacationCard(
                      label: requestedVacation.requestedVacations[index].label,
                      startDate:
                          requestedVacation.requestedVacations[index].startDate,
                      endDate:
                          requestedVacation.requestedVacations[index].endDate,
                      id: requestedVacation.requestedVacations[index].id,
                      userName:
                          requestedVacation.requestedVacations[index].userName,
                      status:
                          requestedVacation.requestedVacations[index].status,
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
