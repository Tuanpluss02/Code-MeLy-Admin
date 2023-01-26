// ignore_for_file: unnecessary_getters_setters

class Event {
  String? _eventPicture;
  String? _eventId;
  String? _eventTitle;
  String? _startTime;
  String? _endTime;
  bool _isEnded = false;
  String? _creator;
  String? _description;

  Event({
    String? eventPicture,
    String? eventId,
    String? eventTitle,
    String? startTime,
    String? endTime,
    String? creator,
    String? description,
    bool isEnded = false,
  }) {
    _isEnded = isEnded;
    if (eventPicture != null) {
      _eventPicture = eventPicture;
    }
    if (eventId != null) {
      _eventId = eventId;
    }
    if (eventTitle != null) {
      _eventTitle = eventTitle;
    }
    if (startTime != null) {
      _startTime = startTime;
    }
    if (endTime != null) {
      _endTime = endTime;
    }
    if (creator != null) {
      _creator = creator;
    }
    if (description != null) {
      _description = description;
    }
  }

  String? get eventPicture => _eventPicture;
  String? get eventId => _eventId;
  String? get eventTitle => _eventTitle;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get creator => _creator;
  String? get description => _description;
  bool get isEnded => _isEnded;

  set eventPicture(String? eventPicture) => _eventPicture = eventPicture;
  set eventId(String? eventId) => _eventId = eventId;
  set eventTitle(String? eventTitle) => _eventTitle = eventTitle;
  set startTime(String? startTime) => _startTime = startTime;
  set endTime(String? endTime) => _endTime = endTime;
  set creator(String? creator) => _creator = creator;
  set description(String? description) => _description = description;
  set isEnded(bool isEnded) => _isEnded = isEnded;

  Event.fromJson(Map<String, dynamic> json) {
    _eventPicture = json['eventPicture'];
    _eventId = json['eventId'];
    _eventTitle = json['eventTitle'];
    _startTime = json['startTime'];
    _endTime = json['endTime'];
    _creator = json['creator'];
    _description = json['description'];
    _isEnded = json['isEnded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventPicture'] = _eventPicture;
    data['eventId'] = _eventId;
    data['eventTitle'] = _eventTitle;
    data['startTime'] = _startTime;
    data['endTime'] = _endTime;
    data['creator'] = _creator;
    data['description'] = _description;
    data['isEnded'] = _isEnded;
    return data;
  }
}
