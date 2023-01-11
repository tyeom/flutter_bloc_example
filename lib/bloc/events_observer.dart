import 'package:bloc_example/bloc/todo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    print('onCreate -- cubit: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    print('onChange -- cubit: ${bloc.runtimeType}, change: $change');
  }
}
