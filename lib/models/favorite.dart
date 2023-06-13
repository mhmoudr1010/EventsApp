class Favorite {
  String? id;
  String eventId;
  String userId;

  Favorite({
    required this.id,
    required this.eventId,
    required this.userId,
  });

  Favorite.fromMap(dynamic document)
      : this(
          id: document.id,
          eventId: document.get('eventId'),
          userId: document.get('userId'),
        );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['eventId'] = eventId;
    map['userId'] = userId;
    return map;
  }

  Map<String, dynamic> toMap1() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
    };
  }
}
