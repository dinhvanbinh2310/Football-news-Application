import 'event_model.dart';

// Hàm parse dữ liệu từ JSON
List<Event> parseEvents(List<dynamic> jsonList) {
  return jsonList.map((json) => Event.fromJson(json)).toList();
}
