
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:library_book/models/reservations.dart';

import '../../models/books.dart';

class ReservationApis{
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future action({required Map details, required String status})async{
    DatabaseReference usersRef = database.ref('borrow');
    await usersRef.push().set({
      "id": "${10000 + Random().nextInt(90000)}",
      "borrower": {
        "name": details["borrower"]["name"],
        "age": details["borrower"]["age"],
        "email": details["borrower"]["email"],
        "school_id": details["borrower"]["school_id"],
        "department": details["borrower"]["department"],
        "year": details["borrower"]["year"],
        "section": details["borrower"]["section"],
      },
      "book_information": details["book_information"],
      "borrow_details": {
        "borrow_date": details["borrow_details"]["borrow_date"],
        "end_date": details["borrow_details"]["end_date"],
      },
      "status": status,
      "created_at": details["created_at"],
      "accepted_at": "${DateTime.now()}",
    });
  }

  Future delete({required String id})async{
    FirebaseDatabase.instance.ref().child('reservations').orderByChild("id").equalTo(id).onChildAdded.forEach((event)async{
      DatabaseReference ref = FirebaseDatabase.instance.ref("reservations/${event.snapshot.key!}");
      await ref.remove();
    });
  }

  Future get() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('reservations');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          reservationModel.update(data: data.values.toList());
          print("RESERVATIONS ${data.values.toList()}");
        } else if (data is List) {
          reservationModel.update(data: data);
        }
      } else {
        reservationModel.update(data: []);
      }
    });
  }
}