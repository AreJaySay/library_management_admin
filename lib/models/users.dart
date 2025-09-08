import 'package:rxdart/rxdart.dart';

class UsersModel{
  // ALL USERS
  BehaviorSubject<List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  List get value => subject.value;

  update({required List data}){
    subject.add(data);
    search.add(data);
  }

  // TO SEARCH
  BehaviorSubject<List> search = new BehaviorSubject();
  Stream get streamSearch => search.stream;
  List get valueSearch => search.value;

  // CURRENT USERS
  BehaviorSubject<Map> loggedUser = new BehaviorSubject();
  Stream get streamLogged => loggedUser.stream;
  Map get valueLogged => loggedUser.value;

  updateUser({required Map data}){
    loggedUser.add(data);
  }
}
final UsersModel usersModel = new UsersModel();