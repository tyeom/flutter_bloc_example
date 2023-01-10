import 'package:bloc_example/bloc/normal_todo_bloc.dart';
import 'package:bloc_example/components/listView_add_widget.dart';
import 'package:bloc_example/models/todo_model.dart';
import 'package:bloc_example/views/add_view.dart';
import 'package:flutter/material.dart';

class AppViewWithNormalBloc extends StatefulWidget {
  const AppViewWithNormalBloc({super.key});

  static final NormalTodoBloc todoBloc = NormalTodoBloc();

  @override
  State<AppViewWithNormalBloc> createState() => _AppViewWithNormalBlocState();
}

class _AppViewWithNormalBlocState extends State<AppViewWithNormalBloc> {
  final NormalTodoBloc _todoBloc = AppViewWithNormalBloc.todoBloc;

  @override
  void initState() {
    super.initState();

    _todoBloc.listTodo();
  }

  @override
  void dispose() {
    super.dispose();
    _todoBloc.dispose();
  }

  Widget _bodyWidget() {
    return Container(
      child: ListView_AddWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('AppViewWithNormalBloc - build');

    return Scaffold(
      appBar: AppBar(title: Text('BLoC Example')),
      body: _bodyWidget(),
    );
  }
}
