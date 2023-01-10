// event base class
abstract class TodoEvent {}

// 데이터 로드 이벤트
class GetTodoListEvent extends TodoEvent {}

// 데이터 추가 이벤트
class CreateTodoEvent extends TodoEvent {
  final String title;

  CreateTodoEvent({
    required this.title,
  });
}

// 데이터 삭제 이벤트
class DeleteTodoEvent extends TodoEvent {
  final String uuid;

  DeleteTodoEvent({
    required this.uuid,
  });
}
