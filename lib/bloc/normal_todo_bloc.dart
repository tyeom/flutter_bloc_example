import 'dart:async';
import 'package:bloc_example/models/todo_model.dart';
import 'package:bloc_example/repository/todo_repository.dart';
import 'package:uuid/uuid.dart';

/// [BLoC 패턴 직접 구현]
/// 비즈니스 로직 처리
class NormalTodoBloc {
  late List<TodoModel> _todoList = [];

  // todo List 상태
  final StreamController<List<TodoModel>> _todoListSubject =
      StreamController<List<TodoModel>>.broadcast();
  Stream<List<TodoModel>> get todoList => _todoListSubject.stream;

  // 에러 상태
  final StreamController<String> _errorMessageSubject =
      StreamController<String>.broadcast();
  Stream<String> get errorMessage => _errorMessageSubject.stream;

  // Repository [이렇게 직접 정의 보다 DI처리로 생성자 의존성 주입으로 받는 것이 좋다.]
  final TodoRepository _repository = TodoRepository();

  // 데이터 로드
  void listTodo() async {
    try {
      final todoJson = await _repository.getListTodo();

      _todoList = todoJson
          .map<TodoModel>(
            (p) => TodoModel.fromJson(p),
          )
          .toList();

      _todoListSubject.sink.add(_todoList);
    } catch (ex) {
      final String errorMessage = ex.toString();
      _errorMessageSubject.sink.add(errorMessage);
    }
  }

  // 데이터 추가
  void createTodo(String title) async {
    try {
      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 임시로 새로 만들어진 TodoModel데이터를 바로 추가해서 스트림 전송
      final fakeTodoList = [
        ..._todoList,
        TodoModel(title: title),
      ];
      _todoListSubject.sink.add(fakeTodoList);

      /// 실제 서버 요청 처리
      /// id, createDT 정보는 서버에서 처리됨을 간주
      const uuid = Uuid();
      final idv4 = uuid.v4();
      TodoModel newTodo = TodoModel(
          uuid: idv4, title: title, createDT: DateTime.now().toString());
      final newTodoJson = await _repository.createTodo(newTodo);

      _todoList.add(TodoModel.fromJson(newTodoJson));
      _todoListSubject.sink.add(_todoList);
    } catch (ex) {
      final String errorMessage = ex.toString();
      _errorMessageSubject.sink.add(errorMessage);
    }
  }

  // 데이터 삭제
  deleteTodo(String uuid) async {
    try {
      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 로컬에서 먼저 삭제처리 후 스트림 전송
      final currentTodoList = [
        ..._todoList,
      ];
      final fakeTodoList =
          currentTodoList.where((item) => item.uuid != uuid).toList();

      _todoListSubject.sink.add(fakeTodoList);

      // 실제 서버에 삭제 요청 처리
      final result = await _repository.deleteTodo(uuid);
      // 삭제 요청 실패시
      if (result == false) {
        _todoListSubject.sink.add(_todoList);
        _errorMessageSubject.sink.add('삭제 요청중 오류 발생');
      }
      else {
        // 로컬 데이터 실제 삭제 처리
        _todoList.removeWhere((item) => item.uuid == uuid);
      }
    } catch (ex) {
      final String errorMessage = ex.toString();
      _errorMessageSubject.sink.add(errorMessage);
    }
  }

  void dispose() {
    _todoListSubject.close();
    _errorMessageSubject.close();
  }
}
