// 실제 서버 요청 부분
import 'package:bloc_example/models/todo_model.dart';

class TodoRepository {
  Future<List<Map<String, dynamic>>> getListTodo() async {
    print('TodoRepository - getListTodo');

    // 서버 요청 딜레이 5sec
    await Future.delayed(Duration(seconds: 5));

    return [
      {
        'uuid': 'aa-bb-cc-dd',
        'title': '할일 1',
        'createDT': DateTime.now().toString(),
      },
    ];
  }

  Future<Map<String, dynamic>> createTodo(TodoModel todo) async {
    print('TodoRepository - createTodo');

    // 서버 요청 딜레이 5sec
    await Future.delayed(Duration(seconds: 5));

    return todo.toJson();
  }

  Future<bool> deleteTodo(String uuid) async {
    print('TodoRepository - deleteTodo');

    // 서버 요청 딜레이 5sec
    await Future.delayed(Duration(seconds: 5));

    return false;
  }
}
