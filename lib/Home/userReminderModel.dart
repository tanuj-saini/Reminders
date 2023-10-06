import 'dart:convert';

class UserReminderModel {
  final String title;
  final String ReminderText;
  final String Latitude;
  final String Longitude;
  final String reminderUid;

  UserReminderModel({
    required this.title,
    required this.ReminderText,
    required this.Latitude,
    required this.Longitude,
    required this.reminderUid,
  });

  UserReminderModel copyWith({
    String? title,
    String? ReminderText,
    String? Latitude,
    String? Longitude,
    String? reminderUid,
  }) {
    return UserReminderModel(
      title: title ?? this.title,
      ReminderText: ReminderText ?? this.ReminderText,
      Latitude: Latitude ?? this.Latitude,
      Longitude: Longitude ?? this.Longitude,
      reminderUid: reminderUid ?? this.reminderUid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ReminderText': ReminderText,
      'Latitude': Latitude,
      'Longitude': Longitude,
      'reminderUid': reminderUid,
    };
  }

  factory UserReminderModel.fromMap(Map<String, dynamic> map) {
    T isA<T>(k) => map[k] is T
        ? map[k]
        : throw ArgumentError.value(map[k], k, '$T ← ${map[k].runtimeType}');
    return UserReminderModel(
      title: isA<String>('title'),
      ReminderText: isA<String>('ReminderText'),
      Latitude: isA<String>('Latitude'),
      Longitude: isA<String>('Longitude'),
      reminderUid: isA<String>('reminderUid'),
    );
  }

  @override
  String toString() {
    return 'UserReminderModel(title: $title, ReminderText: $ReminderText, Latitude: $Latitude, Longitude: $Longitude, reminderUid: $reminderUid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserReminderModel &&
        other.title == title &&
        other.ReminderText == ReminderText &&
        other.Latitude == Latitude &&
        other.Longitude == Longitude &&
        other.reminderUid == reminderUid;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        ReminderText.hashCode ^
        Latitude.hashCode ^
        Longitude.hashCode ^
        reminderUid.hashCode;
  }
}
