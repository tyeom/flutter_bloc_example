import 'package:bloc_example/bloc/todo_bloc.dart';
import 'package:bloc_example/bloc/todo_cubit.dart';
import 'package:bloc_example/bloc/todo_event.dart';
import 'package:bloc_example/bloc/todo_state.dart';
import 'package:bloc_example/views/add_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Cubit 사용
    context.read<TodoCubit>().listTodoEvent();

    // context.read<TodoBloc>().add(
    //       GetTodoListEvent(),
    //     );
  }

  Widget _bodyWidget() {
    return Container(
      child: BlocBuilder<TodoCubit, TodoState>(
        builder: (_, state) {
          if (state is EmptyDataState) {
            return Center(child: Text("데이터가 없습니다."));
          } else if (state is LoadingState) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 252, 113, 49)));
          } else if (state is ErrorState) {
            return Center(
                child: Text("데이터 처리중 오류가 발생하였습니다. - ${state.message}"));
          } else if (state is LoadedState) {
            final todoList = state.todoList;
            return ListView.separated(
                itemBuilder: (_, index) {
                  final item = todoList[index];

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
                            // Cubit 사용
                            onTap: () => BlocProvider.of<TodoCubit>(context)
                                .deleteTodoEvent(item.uuid!),
                            // onTap: () => BlocProvider.of<TodoBloc>(context)
                            //     .add(DeleteTodoEvent(uuid: item.uuid!)),
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
                itemCount: todoList.length);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    print('AppView - build');

    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Example')),
      body: _bodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<String>(
              context, MaterialPageRoute(builder: ((context) => AddView())));

          if (result != null && result.isNotEmpty) {
            // Cubit 사용
            context.read<TodoCubit>().createTodoEvent(result);
            //context.read<TodoBloc>().add(CreateTodoEvent(title: result));
          }
        },
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
