import 'package:flutter/material.dart';

class AddView extends StatelessWidget {
  AddView({super.key});

  final TextEditingController _titleController = TextEditingController();

  Widget _bodyWidget(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _titleController,
              ),
            ),
            IconButton(
              onPressed: () =>
                  Navigator.pop<String>(context, _titleController.text),
              icon: const Icon(Icons.add_task),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내용 추가')),
      body: _bodyWidget(context),
    );
  }
}
