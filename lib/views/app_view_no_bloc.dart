import 'package:bloc_example/components/listView_add_widget2.dart';
import 'package:flutter/material.dart';

class AppViewNoBloc extends StatefulWidget {
  const AppViewNoBloc({super.key});

  @override
  State<AppViewNoBloc> createState() => _AppViewNoBlocState();
}

class _AppViewNoBlocState extends State<AppViewNoBloc> {
  Widget _bodyWidget() {
    return Container(
      child: ListView_AddWidget2(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('AppViewNoBloc - build');

    return Scaffold(
      appBar: AppBar(title: Text('No BLoC Example')),
      body: _bodyWidget(),
    );
  }
}
