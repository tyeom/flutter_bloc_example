// state base class
import 'package:bloc_example/models/todo_model.dart';

abstract class TodoState {}

// 데이터가 없는 상태
class EmptyDataState extends TodoState {}

// 데이터 로드 요청중 상태
class LoadingState extends TodoState {}

// 오류발생 상태
class ErrorState extends TodoState {
  final String message;

  ErrorState({
    required this.message,
  });
}

// 데이터 로드 완료 상태
class LoadedState extends TodoState {
  // 로드 결과 데이터 리스트
  final List<TodoModel> todoList;

  LoadedState({
    required this.todoList,
  });
}