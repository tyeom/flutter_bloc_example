import 'package:bloc_example/bloc/todo_event.dart';
import 'package:bloc_example/bloc/todo_state.dart';
import 'package:bloc_example/models/todo_model.dart';
import 'package:bloc_example/repository/todo_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

/// [flutter_bloc 패키지 사용해서 BLoC 패턴 적용]
/// 비즈니스 로직 처리
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  // Repository 생성자 의존성 주입 처리
  TodoBloc({
    required this.repository,
  }) : super(EmptyDataState()) {
    on<GetTodoListEvent>((_, emit) => _listTodoEvent());
    on<CreateTodoEvent>((event, _) => _createTodoEvent(event.title));
    on<DeleteTodoEvent>((event, _) => _deleteTodoEvent(event.uuid));
  }

  Future<void> _listTodoEvent() async {
    try {
      // 로딩 상태 반환 [스트림 처리]
      emit(LoadingState());

      final todoJson = await repository.getListTodo();

      final todoList = todoJson
          .map<TodoModel>(
            (p) => TodoModel.fromJson(p),
          )
          .toList();

      emit(LoadedState(todoList: todoList));
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }

  Future<void> _createTodoEvent(String title) async {
    try {
      // 현재 상태가 로드 완료 상태 일때만 데이터 추가
      if (state is LoadedState == false) return;

      // 현재 상태
      final loadedState = (state as LoadedState);

      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 임시로 새로 만들어진 TodoModel데이터를 바로 추가해서 스트림 전송
      final fakeTodoList = [
        ...loadedState.todoList,
        TodoModel(title: title),
      ];

      emit(LoadedState(todoList: fakeTodoList));

      /// 실제 서버 요청 처리
      /// id, createDT 정보는 서버에서 처리됨을 간주
      const uuid = Uuid();
      final idv4 = uuid.v4();
      TodoModel newTodo = TodoModel(
          uuid: idv4, title: title, createDT: DateTime.now().toString());
      final newTodoJson = await repository.createTodo(newTodo);
      emit(LoadedState(
        todoList: [
          ...loadedState.todoList,
          newTodo,
        ],
      ));
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }

  Future<void> _deleteTodoEvent(String uuid) async {
    try {
      // 현재 상태가 로드 완료 상태 일때만 데이터 삭제
      if (state is LoadedState == false) return;

      // 현재 상태
      final loadedState = (state as LoadedState);

      /// fake 데이터 [실제 서버에 요청전 결과 데이터를 빠르게 보여주기 위해]
      /// 로컬에서 먼저 삭제처리 후 스트림 전송
      final currentTodoList = [
        ...loadedState.todoList,
      ];
      final fakeTodoList =
          currentTodoList.where((item) => item.uuid != uuid).toList();
      emit(LoadedState(todoList: fakeTodoList));

      // 실제 서버에 삭제 요청 처리
      final result = await repository.deleteTodo(uuid);
      // 삭제 요청 실패시
      if (result == false) {
        emit(loadedState);
      } else {
        // 로컬 데이터 실제 삭제 처리
        loadedState.todoList.removeWhere((item) => item.uuid == uuid);
      }
    } catch (ex) {
      emit(ErrorState(message: ex.toString()));
    }
  }
}
