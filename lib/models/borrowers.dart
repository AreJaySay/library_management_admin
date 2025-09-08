import 'package:rxdart/rxdart.dart';

class BorrowersModel{
  // ALL BORROWERS
  BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get value => subject.value;

  update({required List data}){
    subject.add(data);
  }
  // TO SEARCH
  BehaviorSubject<List> search = new BehaviorSubject();
  Stream get streamSearch => search.stream;
  List get valueSearch => search.value;
}
final BorrowersModel borrowersModel = new BorrowersModel();