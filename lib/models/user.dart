// ignore_for_file: unnecessary_getters_setters

class UserInformation {
  String? _profilePicture;
  String? _userId;
  String? _email;
  String? _displayName;
  String? _about;
  String? _team;
  String? _role;
  String? _joinedAt;
  String? _dateOfBirth;

  UserInformation({
    String? profilePicture,
    String? userId,
    String? email,
    String? displayName,
    String? about,
    String? team,
    String? role,
    String? joinedAt,
    String? dateOfBirth,
  }) {
    if (dateOfBirth != null) {
      _dateOfBirth = dateOfBirth;
    }
    if (profilePicture != null) {
      _profilePicture = profilePicture;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (email != null) {
      _email = email;
    }
    if (displayName != null) {
      _displayName = displayName;
    }
    if (about != null) {
      _about = about;
    }
    if (team != null) {
      _team = team;
    }
    if (role != null) {
      _role = role;
    }
    if (joinedAt != null) {
      _joinedAt = joinedAt;
    }
  }

  String? get dateOfBirth => _dateOfBirth;
  String? get profilePicture => _profilePicture;
  String? get userId => _userId;
  String? get email => _email;
  String? get displayName => _displayName;
  String? get about => _about;
  String? get team => _team;
  String? get role => _role;
  String? get joinedAt => _joinedAt;

  set profilePicture(String? profilePicture) =>
      _profilePicture = profilePicture;
  set userId(String? userId) => _userId = userId;
  set email(String? email) => _email = email;
  set displayName(String? displayName) => _displayName = displayName;
  set about(String? about) => _about = about;
  set team(String? team) => _team = team;
  set role(String? role) => _role = role;
  set joinedAt(String? joinedAt) => _joinedAt = joinedAt;
  set dateOfBirth(String? dateOfBirth) => _dateOfBirth = dateOfBirth;

  UserInformation.fromJson(Map<String, dynamic> json) {
    _profilePicture = json['profilePicture'];
    _userId = json['userId'];
    _email = json['email'];
    _displayName = json['displayName'];
    _about = json['about'];
    _team = json['team'];
    _role = json['role'];
    _joinedAt = json['joinedAt'];
    _dateOfBirth = json['dateOfBirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profilePicture'] = _profilePicture;
    data['userId'] = _userId;
    data['email'] = _email;
    data['displayName'] = _displayName;
    data['about'] = _about;
    data['team'] = _team;
    data['role'] = _role;
    data['joinedAt'] = _joinedAt;
    data['dateOfBirth'] = _dateOfBirth;
    return data;
  }
}
