import 'package:flutter/material.dart';

class PersonalVacationCard extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String label;
  final int id;
  final String status;
  PersonalVacationCard(
      {this.startDate, this.endDate, this.label, this.id, this.status});

  @override
  _PersonalVacationCardState createState() => _PersonalVacationCardState();
}

class _PersonalVacationCardState extends State<PersonalVacationCard> {
  Color color = Colors.black;
  void chooseColor() {
    //print(widget.id);
    if (widget.status == ' PENDING') {
      setState(() {
        color = Colors.black;
      });
    }
    if (widget.status == 'ACCEPTED') {
      setState(() {
        color = Colors.green;
      });
    }
    if (widget.status == 'REJECTED') {
      setState(() {
        color = Colors.red;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chooseColor();
  }

  @override
  Widget build(BuildContext context) {
    //final userMode = Provider.of<UserMode>(context, listen: false);
    return Card(
      child: Row(
        children: [
          Text(widget.startDate + '=>' + widget.endDate),
          Spacer(),
          Text(widget.label == null ? '' : widget.label),
          Spacer(),
          Text(
            widget.status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
