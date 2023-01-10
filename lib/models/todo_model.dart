class TodoModel {
  final String? uuid;
  final String title;
  final String? createDT;

  TodoModel({
    this.uuid,
    required this.title,
    this.createDT,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      createDT: json['createDT'] as String);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'title': title,
        'createDT': createDT,
      };
}
