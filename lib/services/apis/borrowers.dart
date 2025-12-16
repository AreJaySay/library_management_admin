import 'package:firebase_database/firebase_database.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/borrowers.dart';
import '../../models/users.dart';

class BorrowersApi{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('borrow');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          borrowersModel.update(data: data.values.toList());
          print("BORROWERS ${data.values.toList()}");
        } else if (data is List) {
          borrowersModel.update(data: data);
        }
      } else {
        borrowersModel.update(data: []);
      }
    });
  }

  Future settle({required String id})async{
    FirebaseDatabase.instance.ref().child('borrow').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("borrow/${event.snapshot.key!}");
      await ref.remove();
    });
  }
}

