import 'package:flutter/material.dart';

// ignore: unused_element
Widget get _unUsed {
  return Center(
    child: Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // _updateState(DetailsPageState.hasError);
          },
          child: Text('update state Error'),
        ),
        ElevatedButton(
          onPressed: () {
            // _updateState(DetailsPageState.initial);
          },
          child: Text('update state initial'),
        ),
        Text('_state.name'),
        ElevatedButton(
          onPressed: () {},
          child: Text('show modal'),
        ),
      ],
    ),
  );
}
