import 'package:firebase_database/firebase_database.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/borrowers.dart';
import 'package:library_book/models/notifications.dart';
import '../../models/users.dart';

class NotificationApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('admin_notifications');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          notificationModel.update(data: data.values.toList());
        } else if (data is List) {
          notificationModel.update(data: data);
        }
      } else {
        notificationModel.update(data: []);
      }
    });
  }

  Future showed({required String id})async{
    DatabaseReference usersRef = database.ref('admin_notifications');
    FirebaseDatabase.instance.ref().child('admin_notifications').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/is_showed": "1",
      });
    });
  }

  Future seen({required String id})async{
    DatabaseReference usersRef = database.ref('admin_notifications');
    FirebaseDatabase.instance.ref().child('admin_notifications').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/is_read": "1",
      });
    });
  }
}

