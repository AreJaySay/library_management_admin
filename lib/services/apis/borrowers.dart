import 'package:firebase_database/firebase_database.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/borrowers.dart';
import '../../models/users.dart';

class BorrowersApi{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future get({bool isOverdue = false}) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('borrow');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          if(isOverdue){
            borrowersModel.update(data: data.values.toList().where((s) => DateTime.parse(s["borrow_details"]["end_date"]).difference(DateTime.now()).inDays < 0).toList());
          }else{
            borrowersModel.update(data: data.values.toList().where((s) => s["status"] == "Accepted").toList());
          }
        } else if (data is List) {
          borrowersModel.update(data: data);
        }
      } else {
        borrowersModel.update(data: []);
      }
    });
  }

  Future settle({required String id})async{
    DatabaseReference usersRef = database.ref('borrow');
    FirebaseDatabase.instance.ref().child('borrow').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      await usersRef.update({
        "${event.snapshot.key!}/status": "Returned",
      });
    });
  }
}

