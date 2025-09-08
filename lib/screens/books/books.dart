import 'dart:convert';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/users.dart';
import 'package:library_book/screens/books/borrower.dart';
import 'package:library_book/screens/books/components/add_book.dart';
import 'package:library_book/screens/books/reservation.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/services/apis/books.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/shimmer_loader/table.dart';


class Books extends StatefulWidget {
  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final Routes _routes = new Routes();
  final BooksApi _booksApi = new BooksApi();
  final _scrollController = ScrollController();
  List? _toSearch;
  String _selected = "book";


  Future _deleteBook(String data)async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collectionRef = firestore.collection("books");
      DocumentReference docRef = collectionRef.doc(data);
      await docRef.delete();
      print('Document with ID $data deleted successfully from books.');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _booksApi.getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: booksModel.subject,
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.grey.shade200,
                centerTitle: false,
                backgroundColor: Colors.white,
                flexibleSpace: Appbar(isReservation: true,isBook: true,title: "BOOKS",onchange: (text){
                  setState(() {
                     booksModel.update(data: booksModel.valueSearch!.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList());
                  });
                }, selected: (value){
                   setState(() {
                     _selected = value;
                   });
                },onAdd: (){
                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          content: AddBook(details: {})
                      )
                  );
                },)
            ),
            backgroundColor: Colors.white,
            body: _selected == "borrower" ?
            Borrower() :
            _selected == "reservation" ?
            Reservations() :
            !snapshot.hasData ?
            TableLoader() :
            Stack(
              children: [
                Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    child: Table(
                      border: TableBorder.all(color: colors.umber.withOpacity(0.1)),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(100),
                        1: FixedColumnWidth(150),
                        2: FixedColumnWidth(150),
                        3: FlexColumnWidth(),
                        4: FlexColumnWidth(),
                        5: FixedColumnWidth(250),
                        6: FixedColumnWidth(100),
                        7: FixedColumnWidth(100),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            TableCell(child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                              child: Center(child: Text('ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold),)),
                            )),
                            TableCell(child: Center(child: Text('Image',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            TableCell(child: Center(child: Text('ISBN',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            TableCell(child: Center(child: Text('Title',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            TableCell(child: Center(child: Text('Summary',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            TableCell(child: Center(child: Text('Author',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            TableCell(child: Center(child: Text('Stock',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                            TableCell(child: Center(child: Text('Action',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                          ],
                        ),
                        for(int x = 0; x < snapshot.data!.length; x++)...{
                          TableRow(
                            decoration: BoxDecoration(
                                color: x.isEven ? Colors.white : colors.umber.withOpacity(0.1)
                            ),
                            children: <Widget>[
                              TableCell(child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                child: Center(child: Text('${x+1}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,)),
                              )),
                              TableCell(child: Center(
                                child: Image(
                                  image: AssetImage("assets/icons/book.png"),
                                  width: 25,
                                  height: 25,
                                  color: colors.umber,
                                ),
                              ),
                              ),
                              TableCell(child: Center(child: Text('${snapshot.data![x]["isbn"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                              TableCell(child: Center(child: Text('${snapshot.data![x]["title"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                              TableCell(child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                child: Center(child: Text('${snapshot.data![x]["summary"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis,)),
                              )),
                              TableCell(child: Center(child: Text('${snapshot.data![x]["author"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                              TableCell(child: Center(child: Text('${snapshot.data![x]["stock"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                              TableCell(child: Center(child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  customButton: Icon(
                                      Icons.more_vert,
                                      color: colors.clay
                                  ),
                                  items: [
                                    ...MenuItems.firstItems.map(
                                          (item) => DropdownMenuItem<MenuItem>(
                                        value: item,
                                        child: MenuItems.buildItem(item),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    MenuItems.onChanged(context, value! as MenuItem);
                                    if(value.text == "Edit"){

                                    }
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    width: 160,
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                    ),
                                    offset: const Offset(0, 8),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    customHeights: [
                                      ...List<double>.filled(MenuItems.firstItems.length, 48),

                                    ],
                                    padding: const EdgeInsets.only(left: 16, right: 16),
                                  ),
                                ),
                              ))),
                            ],
                          ),
                        }
                      ],
                    ),
                  ),
                ),
              ],
            )
        );
      }
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share];

  static const home = MenuItem(text: 'Accept', icon: Icons.check);
  static const share = MenuItem(text: 'Decline', icon: Icons.cancel_outlined);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: colors.umber, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              color: colors.umber,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
    }
  }
}