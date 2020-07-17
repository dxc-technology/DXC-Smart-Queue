import 'package:flutter/material.dart';

import 'Home.dart';

class FragmentView extends StatefulWidget {

  const FragmentView({ Key key, this.fragment }) : super(key: key);

  final Fragment fragment;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<FragmentView> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'sample text: ${widget.fragment.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(controller: _textController),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

