import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/borrowers.dart';
import 'package:library_book/models/reservations.dart';
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
import 'package:universal_html/html.dart' as html;
import '../../services/apis/borrowers.dart';
import '../../widgets/no_data_widget.dart';
import '../widgets/shimmer_loader/table.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Books extends StatefulWidget {
  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final Routes _routes = new Routes();
  final BooksApi _booksApi = new BooksApi();
  final BorrowersApi _borrowersApi = new BorrowersApi();
  final _scrollController = ScrollController();
  final GlobalKey _printKey = GlobalKey();
  List? _toSearch;
  String _selected = "book";

  @override
  void initState() {
    // TODO: implement initState
    _booksApi.get();
    _borrowersApi.get();
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
                  List _res = booksModel.valueSearch.where((s) => s["title"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                  booksModel.update(data: _res);
                }, selected: (value){
                   setState(() {
                     _selected = value;
                   });
                }, onPrint: (){
                  if(_selected == "borrower"){
                    _excelBorrowers(datas: borrowersModel.value);
                  }else if(_selected == "reservation"){
                    _excelReservations(datas: reservationModel.value);
                  }else{
                    _excelBooks(datas: snapshot.data!);
                  }
                },onAdd: (){
                  showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          content: AddBook()
                      )
                  );
                })
            ),
            backgroundColor: Colors.white,
            body: _selected == "borrower" ?
            RepaintBoundary(
              key: _printKey,
              child: Borrower(),
            ) :
            _selected == "reservation" ?
            RepaintBoundary(
              key: _printKey,
              child: Reservations(),
            ) :
            !snapshot.hasData ?
            TableLoader() :
            snapshot.data!.isEmpty ?
            NoDataWidget() :
            Stack(
              children: [
                StreamBuilder(
                  stream: borrowersModel.subject,
                  builder: (context, borrowSnapshot) {
                    return RepaintBoundary(
                      key: _printKey,
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          controller: _scrollController,
                          child: Table(
                            border: TableBorder.all(color: colors.umber.withOpacity(0.1)),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(100),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(120),
                              3: FixedColumnWidth(150),
                              4: FixedColumnWidth(150),
                              5: FixedColumnWidth(150),
                              6: FixedColumnWidth(150),
                              7: FlexColumnWidth(),
                              8: FixedColumnWidth(100),
                              9: FixedColumnWidth(100),
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
                                  TableCell(child: Center(child: Text('Isbn',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Subject',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Title',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Author',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Publisher',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Summary',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Stock',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                  TableCell(child: Center(child: Text('Action',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                                ],
                              ),
                              for(int x = 0; x < snapshot.data!.length; x++)...{
                                TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  children: <Widget>[
                                    TableCell(child: Padding(
                                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                      child: Center(child: Text('${x+1}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,)),
                                    )),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: snapshot.data![x]["base64Image"] != "" ?
                                          Image.memory(
                                            base64Decode(snapshot.data![x]["base64Image"]),
                                            width: 35,
                                            height: 55,
                                            fit: BoxFit.fill,
                                          ) :
                                          Image(
                                            image: AssetImage("assets/icons/book.png"),
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(child: Center(child: Text('${snapshot.data![x]["isbn"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${snapshot.data![x]["subject"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${snapshot.data![x]["title"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${snapshot.data![x]["author"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Center(child: Text('${snapshot.data![x]["publisher"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                    TableCell(child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                      child: Center(child: Text('${snapshot.data![x]["summary"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,maxLines: 3,overflow: TextOverflow.ellipsis,)),
                                    )),
                                    if(borrowSnapshot.hasData)...{
                                      if(int.parse(snapshot.data![x]["stock"])-borrowSnapshot.data!.where((s) => json.decode(s["book_information"])["isbn"] == snapshot.data![x]["isbn"]).toList().length == 0)...{
                                        TableCell(child: Center(child: Text('No \nAvailable',style: TextStyle(color: Colors.grey.shade300),textAlign: TextAlign.center,))),
                                      }else...{
                                        TableCell(child: Center(child: Text('${int.parse(snapshot.data![x]["stock"])-borrowersModel.value.where((s) => json.decode(s["book_information"])["isbn"] == snapshot.data![x]["isbn"]).toList().length}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                      },
                                    }else...{
                                      TableCell(child: Center(child: CircularProgressIndicator())),
                                    },
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
                                            showDialog<void>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                    ),
                                                    content: AddBook(details: snapshot.data![x])
                                                )
                                            );
                                          }else{
                                            _booksApi.delete(isbn: snapshot.data![x]["isbn"]);
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
                    );
                  }
                ),
              ],
            )
        );
      }
    );
  }

  Future _excelBooks({required List datas}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Books'];
    sheet.appendRow([
      TextCellValue("ID"),
      TextCellValue("Isbn"),
      TextCellValue("Subject"),
      TextCellValue("Title"),
      TextCellValue("Author"),
      TextCellValue("Publisher"),
      TextCellValue("Summary"),
      TextCellValue("Stock"),
    ]);
    for(int x = 0; x < datas.length; x++){
      sheet.appendRow([
        TextCellValue("${x+1}"),
        TextCellValue("${datas[x]["isbn"]}"),
        TextCellValue("${datas[x]["subject"]}"),
        TextCellValue("${datas[x]["title"]}"),
        TextCellValue("${datas[x]["author"]}"),
        TextCellValue("${datas[x]["publisher"]}"),
        TextCellValue("${datas[x]["summary"]}"),
        TextCellValue("${datas[x]["stock"]}"),
      ]);
    }
    final fileBytes = excel.encode()!;
    final content = base64Encode(fileBytes);
    final anchor = html.AnchorElement(
      href: "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$content",
    )
      ..setAttribute("download", "Books.xlsx")
      ..click();
  }

  Future _excelBorrowers({required List datas}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Borrowers'];
    sheet.appendRow([
      TextCellValue("ID"),
      TextCellValue("Name"),
      TextCellValue("Age"),
      TextCellValue("School ID"),
      TextCellValue("Department"),
      TextCellValue("Year"),
      TextCellValue("Section"),
      TextCellValue("Book title"),
      TextCellValue("Borrow date"),
      TextCellValue("Return date"),
      TextCellValue("Status"),
    ]);
    for(int x = 0; x < datas.length; x++){
      sheet.appendRow([
        TextCellValue("${x+1}"),
        TextCellValue("${datas[x]["borrower"]["name"]}"),
        TextCellValue("${datas[x]["borrower"]["age"]}"),
        TextCellValue("${datas[x]["borrower"]["school_id"]}"),
        TextCellValue("${datas[x]["borrower"]["department"]}"),
        TextCellValue("${datas[x]["borrower"]["year"]}"),
        TextCellValue("${datas[x]["borrower"]["section"]}"),
        TextCellValue("${jsonDecode(datas[x]["book_information"])["title"]}"),
        TextCellValue("${DateFormat("MMM dd, yyyy").format(DateTime.parse(datas[x]["borrow_details"]["borrow_date"]))}"),
        TextCellValue("${DateFormat("MMM dd, yyyy").format(DateTime.parse(datas[x]["borrow_details"]["end_date"]))}"),
        TextCellValue("${DateTime.parse(datas[x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays < 0 ? "Over Due" : DateTime.parse(datas[x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays == 0 ? "Due Today" : "--"}"),
      ]);
    }
    final fileBytes = excel.encode()!;
    final content = base64Encode(fileBytes);
    final anchor = html.AnchorElement(
      href: "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$content",
    )
      ..setAttribute("download", "Borrowers.xlsx")
      ..click();
  }

  Future _excelReservations({required List datas}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Reservations'];
    sheet.appendRow([
      TextCellValue("ID"),
      TextCellValue("Name"),
      TextCellValue("Age"),
      TextCellValue("School ID"),
      TextCellValue("Department"),
      TextCellValue("Year"),
      TextCellValue("Section"),
      TextCellValue("Book title"),
      TextCellValue("Borrow date"),
      TextCellValue("Return date"),
    ]);
    for(int x = 0; x < datas.length; x++){
      sheet.appendRow([
        TextCellValue("${x+1}"),
        TextCellValue("${datas[x]["borrower"]["name"]}"),
        TextCellValue("${datas[x]["borrower"]["age"]}"),
        TextCellValue("${datas[x]["borrower"]["school_id"]}"),
        TextCellValue("${datas[x]["borrower"]["department"]}"),
        TextCellValue("${datas[x]["borrower"]["year"]}"),
        TextCellValue("${datas[x]["borrower"]["section"]}"),
        TextCellValue("${jsonDecode(datas[x]["book_information"])["title"]}"),
        TextCellValue("${DateFormat("MMM dd, yyyy").format(DateTime.parse(datas[x]["borrow_details"]["borrow_date"]))}"),
        TextCellValue("${DateFormat("MMM dd, yyyy").format(DateTime.parse(datas[x]["borrow_details"]["end_date"]))}"),
      ]);
    }
    final fileBytes = excel.encode()!;
    final content = base64Encode(fileBytes);
    final anchor = html.AnchorElement(
      href: "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$content",
    )
      ..setAttribute("download", "Reservations.xlsx")
      ..click();
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

  static const home = MenuItem(text: 'Edit', icon: Icons.edit);
  static const share = MenuItem(text: 'Delete', icon: Icons.delete);

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