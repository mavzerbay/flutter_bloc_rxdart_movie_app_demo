import 'package:flutter/material.dart';

class ErrorWidget extends StatefulWidget {
  final String error;
  const ErrorWidget({
    Key key,
    this.error,
  }) : super(key: key);
  @override
  _ErrorWidgetState createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<ErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Error occured : ${widget.error}")],
      ),
    );
  }
}
