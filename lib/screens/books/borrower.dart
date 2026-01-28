import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/borrowers.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/services/apis/borrowers.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;
import 'package:library_book/utils/snackbars/snackbar_message.dart';
import 'package:universal_html/html.dart' as html;

import '../widgets/button.dart';
import '../widgets/shimmer_loader/table.dart';
class Borrower extends StatefulWidget {
  @override
  State<Borrower> createState() => _BorrowerState();
}

class _BorrowerState extends State<Borrower> {
  final Routes _routes = new Routes();
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final BorrowersApi _borrowersApi = new BorrowersApi();
  final _scrollController = ScrollController();
  final currencyFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱ ',
    decimalDigits: 2,
  );


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: borrowersModel.subject,
        builder: (context, snapshot) {
        return !snapshot.hasData ?
          TableLoader() :
          snapshot.data!.isEmpty ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: 200,
                  height: 200,
                  image: AssetImage("assets/icons/no_data_found.jpg"),
                ),
                Text("No Data Found !",style: TextStyle(fontFamily: "OpenSans",fontSize: 20,color: Colors.grey.shade400),)
              ],
            ),
          ) :
          Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Table(
              border: TableBorder.all(color: colors.umber.withOpacity(0.1)),
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(100),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(80),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
                5: FixedColumnWidth(100),
                6: FixedColumnWidth(100),
                7: FlexColumnWidth(),
                8: FixedColumnWidth(120),
                9: FixedColumnWidth(120),
                10: FixedColumnWidth(120),
                11: FixedColumnWidth(100),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    TableCell(child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                      child: Center(child: Text('ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold),)),
                    )),
                    TableCell(child: Center(child: Text('Name',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Age',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('School ID',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Department',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Year',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Section',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Book title',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Borrow date',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Return date',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Status',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
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
                      TableCell(child: Center(child: Text('${snapshot.data![x]["borrower"]["name"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["borrower"]["age"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["borrower"]["school_id"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["borrower"]["department"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["borrower"]["year"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${snapshot.data![x]["borrower"]["section"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${jsonDecode(snapshot.data![x]["book_information"])["title"]}',style: TextStyle(fontFamily: "Roboto_normal",),textAlign: TextAlign.center,maxLines: 3,))),
                      TableCell(child: Center(child: Text('${DateFormat("MMM dd, yyyy").format(DateTime.parse(snapshot.data![x]["borrow_details"]["borrow_date"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${DateFormat("MMM dd, yyyy").format(DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays < 0 ?
                        "Over Due"
                        : DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays == 0 ?
                        "Due Today/Tomorrow"
                        : "--"}',style: TextStyle(fontFamily: "Roboto_normal" , color: DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays < 0 ? Colors.red : DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays == 0 ? Colors.orange : colors.coffee),textAlign: TextAlign.center,),
                      ))),
                      TableCell(child: Center(
                        child: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: (){
                            print(snapshot.data![x]["id"]);
                            _settle(id:snapshot.data![x]["id"], dayspenalty: DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays);
                          },
                        ),
                      )),

                    ],
                  ),
                }
              ],
            ),
          ),
        );
      }
    );
  }
  void _settle({required int dayspenalty, required String id}){
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            content: Container(
              width: 350,
              height: 330,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Penalty",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 16),),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: dayspenalty >= 0 ?
                          Center(
                            child: Text("--",style: TextStyle(color: colors.clay, fontFamily: "OpenSans",fontSize: 20),),
                          ) :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("₱10.00 x ${dayspenalty.toString().replaceAll("-", "")} days",style: TextStyle(fontSize: 15, fontFamily: "OpenSans"),),
                              Text("${currencyFormat.format(10 * dayspenalty).replaceAll("-", "")}",style: TextStyle(fontFamily: "OpenSans",fontSize: 33, fontWeight: FontWeight.bold, color: Colors.red.shade300),),
                            ],
                          ),
                        ),
                        Spacer(),
                        _materialbutton.materialButton(dayspenalty >= 0 ? "Returned" : "Settle", (){
                          _confirmSettle(id: id);
                        }),
                      ],
                    ),
                  ),
                  Positioned(
                    right: -40,
                    top: -30,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: colors.umber,),
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }

  void _confirmSettle({required String id}){
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with buttons
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500),),
          content: Text('Are you sure you want to settle this borrowed book?',style: TextStyle(fontFamily: "OpenSans"),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(fontFamily: "OpenSans", color: Colors.black54),),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colors.umber),
              ),
              onPressed: () {
                print(id);
                _borrowersApi.settle(id: id).whenComplete((){
                  Navigator.of(context).pop(null);
                  Navigator.of(context).pop(null);
                  _snackbarMessage.snackbarMessage(context, message: "Successfully settle borrowed book!");
                });
              },
              child: Text('Confirm',style: TextStyle(fontFamily: "OpenSans", color: Colors.white),),
            ),
          ],
        );
      },
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