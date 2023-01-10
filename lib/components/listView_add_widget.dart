import 'package:bloc_example/bloc/normal_todo_bloc.dart';
import 'package:bloc_example/models/todo_model.dart';
import 'package:bloc_example/views/app_view_with_normal_bloc.dart';
import 'package:flutter/material.dart';

/// Normal Bloc 패턴 용도 위젯
/// 상태관리가 제대로 되면서 위젯 렌더링이 다시 발생되는지 확인용도로
/// 임의로 별도 위젯으로 처리
class ListView_AddWidget extends StatelessWidget {
  final NormalTodoBloc _todoBloc = AppViewWithNormalBloc.todoBloc;
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('ListView_AddWidget - build !!!');

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
                onPressed: () => _todoBloc.createTodo(_titleController.text),
                icon: const Icon(Icons.add_task),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: StreamBuilder(
            stream: _todoBloc.todoList,
            initialData: [],
            builder: (_, snapshot) {
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
                              onTap: () => _todoBloc.deleteTodo(item.uuid!),
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
