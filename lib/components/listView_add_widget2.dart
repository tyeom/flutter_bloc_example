import 'package:bloc_example/models/todo_model.dart';
import 'package:bloc_example/repository/todo_repository.dart';
import 'package:flutter/material.dart';

/// Bloc 패턴 적용 X 용도 위젯
/// 렌더링이 다시 발생되는지 확인용도로 임의로 별도 위젯으로 처리
class ListView_AddWidget2 extends StatefulWidget {
  const ListView_AddWidget2({super.key});

  @override
  State<ListView_AddWidget2> createState() => _ListView_AddWidget2State();
}

class _ListView_AddWidget2State extends State<ListView_AddWidget2> {
  final TextEditingController _titleController = TextEditingController();
  final TodoRepository _repository = TodoRepository();
  final List<TodoModel> _todoList = [];
  // 최초 로드 여부
  bool _isFirstLoaded = false;

  // 데이터 로드
  Future<List<TodoModel>> _listTodo() async {
    try {
      if (_isFirstLoaded) return _todoList;

      final todoJson = await _repository.getListTodo();

      _todoList.addAll(todoJson
          .map<TodoModel>(
            (p) => TodoModel.fromJson(p),
          )
          .toList());
      _isFirstLoaded = true;
    } catch (ex) {
      print(ex.toString());
    }

    return _todoList;
  }

  // 데이터 추가
  Future<void> _addTodo(String title) async {
    try {
      final todoJson = await _repository.createTodo(TodoModel(
          uuid: 'a-b-c-d', title: title, createDT: DateTime.now().toString()));
      setState(() {
        _todoList.add(TodoModel.fromJson(todoJson));
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ListView_AddWidget2 - build !!!');

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                ),
              ),
              IconButton(
                onPressed: () => _addTodo(_titleController.text),
                icon: const Icon(Icons.add_task),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: FutureBuilder(
            future: _listTodo(),
            builder: (_, snapshot) {
              if (snapshot.hasData == false) return Container();

              return ListView.separated(
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index] as TodoModel;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              item.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _todoList
                                      .removeWhere((p) => p.uuid == item.uuid);
                                });
                              },
                              child: const Icon(Icons.delete),
                            )
                          ],
                        ),
                        Text(
                          item.createDT.toString(),
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (_, index) => const Divider(),
                  itemCount: snapshot.data!.length);
            },
          )),
        ]),
      ),
    );
  }
}
