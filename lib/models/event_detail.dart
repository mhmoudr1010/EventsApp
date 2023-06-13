class EventDetail {
  String? id;
  String description;
  String date;
  String startTime;
  String endTime;
  String speaker;
  bool isFavorite;

  EventDetail({
    this.id,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.speaker,
    required this.isFavorite,
  });

  EventDetail.fromJson(dynamic json)
      : this(
          description: json['description'] as String,
          date: json['date'] as String,
          startTime: json['startTime'] as String,
          endTime: json['endTime'] as String,
          speaker: json['speaker'] as String,
          isFavorite: json['isFavorite'] as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'speaker': speaker,
      'is_favorite': isFavorite,
    };
  }

  /*EventDetail.fromMap(dynamic obj) {
    if (obj != null) {
      id = obj['id'] ?? '';
      description = obj['description'] ?? '';
      date = obj['date'] ?? '';
      startTime = obj['start_time'] ?? '';
      endTime = obj['end_time'] ?? '';
      speaker = obj['speaker'] ?? '';
      isFavorite = obj['is_favourite'] ?? false;
    }
  }*/

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'speaker': speaker,
      'is_favorite': isFavorite,
    };
  }
}
