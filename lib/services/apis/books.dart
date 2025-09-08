import 'package:firebase_database/firebase_database.dart';
import 'package:library_book/models/books.dart';
import '../../models/users.dart';

class BooksApi{
  Future getBooks() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('books');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          booksModel.update(data: data.values.toList());
          print("BOOKS ${data.values.toList()}");
        } else if (data is List) {
          booksModel.update(data: data);
        }
      } else {
        booksModel.update(data: []);
      }
    });
  }
}

