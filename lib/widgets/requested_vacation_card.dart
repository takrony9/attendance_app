import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class RequestedVacationCard extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String userName;
  final String label;
  final String status;
  final int id;

  RequestedVacationCard(
      {this.label,
      this.id,
      this.userName,
      this.startDate,
      this.endDate,
      this.status});

  @override
  _RequestedVacationCardState createState() => _RequestedVacationCardState();
}

class _RequestedVacationCardState extends State<RequestedVacationCard> {
  void chosenReplay(BuildContext ctx, String replay) {
    Provider.of<Auth>(ctx, listen: false)
        .response(id: widget.id, replay: replay);
  }

  Color color;
  void chooseColor() {
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
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.userName),
              Spacer(),
              Text(widget.startDate + '=>' + widget.endDate),
              Spacer(),
              Text(widget.label == null ? '' : widget.label),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () => chosenReplay(context, 'ACCEPTED'),
                color: Colors.green,
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => chosenReplay(context, 'REJECTED'),
                color: Colors.red,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
