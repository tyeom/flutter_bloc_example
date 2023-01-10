import 'package:bloc_example/bloc/todo_bloc.dart';
import 'package:bloc_example/bloc/todo_cubit.dart';
import 'package:bloc_example/repository/todo_repository.dart';
import 'package:bloc_example/views/app_view.dart';
import 'package:bloc_example/views/app_view_with_normal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // BLoC 패턴 직접 구현
  //runApp(const MyApp());

  // flutter_bloc 패키지 사용
  // runApp(BlocProvider(
  //   // TodoRepository DI 처리
  //   create: (_) => TodoBloc(repository: TodoRepository()),
  //   child: const MyApp(),
  // ));

  // flutter_bloc 패키지 사용 - Cubit 사용
  runApp(BlocProvider(
    // TodoRepository DI 처리
    create: (_) => TodoCubit(repository: TodoRepository()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // BLoC 패턴 직접 구현 사용
      //home: const AppViewWithNormalBloc(),

      // flutter_bloc 패키지 사용
      home: const AppView(),
    );
  }
}
