class TaskModel {
  final int? id;
  final String title;
  final String note;
  final int isCompleted;
  final String date;
  final String startTime;
  final String endTime;
  final int remind;
  final String repeat;

  const TaskModel({
    this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isCompleted: json['isCompleted'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      remind: json['remind'],
      repeat: json['repeat'],
    );
  }
}
