import 'package:firebase_database/firebase_database.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/borrowers.dart';
import '../../models/users.dart';

class BorrowersApi{
  Future getBorrowers() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('requests');
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
}

