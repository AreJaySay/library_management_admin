import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:library_book/models/books.dart';
import 'package:library_book/models/borrowers.dart';
import 'package:library_book/models/reservations.dart';
import 'package:library_book/models/users.dart';
import 'package:library_book/screens/inventory/components/top_card.dart';
import 'package:library_book/services/apis/books.dart';
import 'package:library_book/services/apis/borrowers.dart';
import 'package:library_book/services/apis/reservations.dart';
import 'package:library_book/services/apis/users.dart';
import 'package:library_book/services/routes.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../books/books.dart';
import '../widgets/appbar.dart';

class Inventory extends StatefulWidget {
  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final Routes _routes = new Routes();
  final BooksApi _booksApi = new BooksApi();
  final BorrowersApi _borrowersApi = new BorrowersApi();
  final ReservationApis _reservationApis = new ReservationApis();
  final UsersApi _usersApi = new UsersApi();
  final _scrollController = ScrollController();
  List? _users;

  @override
  void initState() {
    // TODO: implement initState
    _booksApi.get();
    _borrowersApi.get();
    _reservationApis.get();
    _usersApi.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.grey.shade200,
          centerTitle: false,
          backgroundColor: Colors.white,
          flexibleSpace: Appbar(
            title: "INVENTORY",
            onchange: (text) {

            },
            hasPrinting: false,
            onPrint: () async {},
            onAdd: () {},
            datePicker: SizedBox(),
            hasSearch: false,
            filterWidget: SizedBox()),
          ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  StreamBuilder(
                    stream: booksModel.subject,
                    builder: (context, snapshot) {
                      return TopCard(icon: Icons.book,value: !snapshot.hasData ? "--" : "${snapshot.data!.length}", title: "Total Books");
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StreamBuilder(
                    stream: usersModel.subject,
                    builder: (context, snapshot) {
                      return TopCard(icon: Icons.people_alt_outlined,value: !snapshot.hasData ? "--" : "${snapshot.data!.length}", title: "Total Members");
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StreamBuilder(
                    stream: borrowersModel.subject,
                    builder: (context, snapshot) {
                      return TopCard(icon: Icons.menu_book_outlined,value: !snapshot.hasData ? "--" : "${snapshot.data!.length}", title: "Borrowed Books");
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StreamBuilder(
                    stream: reservationModel.subject,
                    builder: (context, snapshot) {
                      return TopCard(icon: Icons.menu_book_outlined,value: !snapshot.hasData ? "--" : "${snapshot.data!.length}", title: "Reserved Books");
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StreamBuilder(
                    stream: borrowersModel.subject,
                    builder: (context, snapshot) {

                      return TopCard(icon: Icons.menu_book_outlined,value: !snapshot.hasData ? "--" : "${snapshot.data!.where((s) => DateTime.parse(s["borrow_details"]["end_date"]).difference(DateTime.now()).inDays < 0).length}", title: "Overdue Books");
                    }
                  )
                ],
              ),
            ),
            Expanded(
              flex: 15,
              child: Padding(
                padding: EdgeInsetsGeometry.only(bottom: 50),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 0),
                              blurRadius: 9,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60,
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text("Books Circulation", style: TextStyle(fontFamily: "AppFontStyle", fontSize: 15, fontWeight: FontWeight.w600),),
                            ),
                            Divider(color: Colors.grey.shade300,),
                            SizedBox(
                              height: 70,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                legendDot(const Color(0xFF00BCD4), "Borrowed Books"),
                                const SizedBox(width: 20),
                                legendDot(const Color(0xFFFFD600), "Reserved Books"),
                                const SizedBox(width: 20),
                                legendDot(const Color(0xFFFF3D00), "Overdue Books"),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 350,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  StreamBuilder(
                                    stream: borrowersModel.subject,
                                    builder: (context, snapshot) {
                                      return StreamBuilder(
                                        stream: reservationModel.subject,
                                        builder: (context, reserveSnapshot) {
                                          return PieChart(
                                            PieChartData(
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 110, // 👈 hole size
                                              sections: [
                                                PieChartSectionData(
                                                  value: !snapshot.hasData ? 0 : double.parse("${snapshot.data!.length}"),
                                                  color: Color(0xFF00BCD4), // Issued
                                                  radius: 50,
                                                  showTitle: false,
                                                ),
                                                PieChartSectionData(
                                                  value: !reserveSnapshot.hasData ? 0 : double.parse("${reserveSnapshot.data!.length}"),
                                                  color: const Color(0xFFFFD600), // Reserved
                                                  radius: 50,
                                                  showTitle: false,
                                                ),
                                                PieChartSectionData(
                                                  value: !snapshot.hasData ? 0 : double.parse("${snapshot.data!.where((s) => DateTime.parse(s["borrow_details"]["end_date"]).difference(DateTime.now()).inDays < 0).length}"),
                                                  color: const Color(0xFFFF3D00), // Overdue
                                                  radius: 50,
                                                  showTitle: false,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      );
                                    }
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        "60%",
                                        style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "AVG. Exceptions",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 0),
                              blurRadius: 9,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60,
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text("Books Circulation", style: TextStyle(fontFamily: "AppFontStyle", fontSize: 15, fontWeight: FontWeight.w600),),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: StreamBuilder(
                                  stream: booksModel.subject,
                                  builder: (context, snapshot) {
                                    return Scrollbar(
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        controller: _scrollController,
                                        child: Table(
                                          border: TableBorder.all(
                                              color: colors.umber.withOpacity(0.1)),
                                          columnWidths: const <int, TableColumnWidth>{
                                            0: FixedColumnWidth(100),
                                            1: FixedColumnWidth(100),
                                            2: FixedColumnWidth(120),
                                            3: FixedColumnWidth(150),
                                          },
                                          defaultVerticalAlignment: TableCellVerticalAlignment
                                              .middle,
                                          children: <TableRow>[
                                            TableRow(
                                              children: <Widget>[
                                                TableCell(child: Padding(
                                                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                                  child: Center(child: Text(
                                                      'Title', style: TextStyle(
                                                      fontFamily: "Roboto_normal",
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15))),
                                                )),
                                                TableCell(child: Center(child: Text(
                                                    'Author', style: TextStyle(
                                                    fontFamily: "Roboto_normal",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)))),
                                                TableCell(child: Center(child: Text(
                                                    'Publisher', style: TextStyle(
                                                    fontFamily: "Roboto_normal",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)))),

                                                TableCell(child: Center(child: Text(
                                                    'Percentage', style: TextStyle(
                                                    fontFamily: "Roboto_normal",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)))),
                                              ],
                                            ),
                                            if(snapshot.hasData)...{
                                              for(int x = 0; x < snapshot.data!.length; x++)...{
                                                TableRow(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                  ),
                                                  children: <Widget>[
                                                    TableCell(child: Padding(
                                                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                                                      child: Center(child: Text('${snapshot.data![x]["title"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,)),
                                                    )),
                                                    TableCell(child: Center(child: Text('${snapshot.data![x]["author"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                                    TableCell(child: Center(child: Text('${snapshot.data![x]["publisher"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                                    TableCell(child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: LinearPercentIndicator(
                                                            animation: true,
                                                            barRadius: Radius.circular(1000),
                                                            lineHeight: 12.0,
                                                            animationDuration: 2500,
                                                            percent: (double.parse(snapshot.data![x]["stock"])).floor()/(double.parse(snapshot.data![x]["overall_stock"])).floor(),
                                                            center: SizedBox(),
                                                            linearStrokeCap: LinearStrokeCap.round,
                                                            progressColor: Color.fromRGBO(18, 125, 194, 1),
                                                          ),
                                                        ),
                                                        Text("${snapshot.data![x]["stock"]}/${snapshot.data![x]["overall_stock"]}"),
                                                        // Text("${((double.parse(snapshot.data![x]["overall_stock"]) - double.parse(snapshot.data![x]["stock"])) / double.parse(snapshot.data![x]["overall_stock"])) * 100}"),
                                                        // Text("${borrowersModel.value.where((s) => jsonDecode(s["book_information"])["isbn"] == snapshot.data![x]["isbn"]).toList().length}%",style: TextStyle(fontSize: 11),),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              }
                                            }
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              ),
                            ),
                          ],
                        ),
                    ))
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
  Widget legendDot(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
  double findPercentage(double x, double y) {
    if (y == 0) return 0.0; // Avoid division by zero
    return (x / y) * 100.0;
  }
}
