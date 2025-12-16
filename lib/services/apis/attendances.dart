import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/attendances.dart';
import '../../models/users.dart';

class AttendancesApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future get() async {
    // GET
    DatabaseReference ref = FirebaseDatabase.instance.ref('attendances');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          List _res = [];

          final grouped = groupById(data.values.toList());
          List<dynamic> mapList = convertToMapList(grouped);
          for(int x = 0; x < mapList.length; x++){
            _res.add([
              mapList[x]["items"].first,
              mapList[x]["items"].last,
              usersModel.value.where((s) => s["school_id"] == mapList[x]["items"].first["school_id"]).toList().isEmpty ? {} :
              usersModel.value.where((s) => s["school_id"] == mapList[x]["items"].first["school_id"]).toList().first]);
          }
          print("ATTENDANCE ${_res.first}");
          attendanceModel.update(data: _res);
          attendanceModel.updateSearch(data: _res);
        } else if (data is List) {
          attendanceModel.update(data: data);
          attendanceModel.updateSearch(data: data);
        }
      } else {
        attendanceModel.update(data: []);
        attendanceModel.updateSearch(data: []);
      }
    });
  }

  Map<String, List> groupById(List items) {
    final Map<String, List> grouped = {};
    for (var item in items) {
      final key = "${item['school_id']}|${DateFormat.yMMMd().format(DateTime.parse(item['date_time']))}";
      grouped[key] == null && ((grouped[key] = []) != null);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  List convertToMapList(grouped) {
    return grouped.entries.map((entry) {
      return {
        "id": entry.key,
        "items": entry.value,   // You can also map to JSON if needed
      };
    }).toList();
  }

}

// class Item {
//   final String school_id;
//   final DateTime dateTime;
//
//   Item({required this.school_id, required this.dateTime});
// }