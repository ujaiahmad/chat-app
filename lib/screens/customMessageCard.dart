import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomMessageCard extends StatelessWidget {
  const CustomMessageCard({
    Key? key,
    required this.messageSender,
    required this.messageText,
    required this.messageTime,
    required this.textColour,
    required this.cardColour,
    required this.crossAxisAlignmentColumn,
    required this.roundedRectangleBorder,
    required this.mainAxisAlignmentRow,
  }) : super(key: key);

  final String messageSender;
  final String messageText;
  final Timestamp messageTime;
  final Color textColour;
  final Color cardColour;
  final CrossAxisAlignment crossAxisAlignmentColumn;
  final MainAxisAlignment mainAxisAlignmentRow;
  final RoundedRectangleBorder roundedRectangleBorder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignmentRow,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: crossAxisAlignmentColumn,
            children: [
              Text(
                messageSender,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Card(
                color: cardColour,
                shape: roundedRectangleBorder,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    messageText,
                    style: TextStyle(color: textColour),
                  ),
                ),
              ),
              Text(
                DateFormat.jm().format(messageTime.toDate().toLocal()),
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
