import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/functions/loaders.dart';
import 'package:library_book/models/reservations.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/services/apis/notifications.dart';
import 'package:library_book/services/apis/reservations.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;
import 'package:library_book/utils/snackbars/snackbar_message.dart';

import '../widgets/shimmer_loader/table.dart';
class Reservations extends StatefulWidget {
  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  final _scrollController = ScrollController();
  final ReservationApis _reservationApis = new ReservationApis();
  final NotificationApis _notificationApis = new NotificationApis();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();

  @override
  void initState() {
    // TODO: implement initState
    _reservationApis.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: reservationModel.subject,
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
                2: FixedColumnWidth(100),
                3: FlexColumnWidth(),
                4: FlexColumnWidth(),
                5: FlexColumnWidth(),
                6: FlexColumnWidth(),
                7: FlexColumnWidth(),
                8: FlexColumnWidth(),
                9: FlexColumnWidth(),
                10: FlexColumnWidth(),
                11: FlexColumnWidth(),
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
                    TableCell(child: Center(child: Text('Created at',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,))),
                    TableCell(child: Center(child: Text('Reserve date',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                    TableCell(child: Center(child: Text('Return date',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
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
                      TableCell(child: Center(child: Text('${DateFormat("MMM dd, yyyy").format(DateTime.parse(snapshot.data![x]["created_at"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${DateFormat("MMM dd, yyyy").format(DateTime.parse(snapshot.data![x]["borrow_details"]["borrow_date"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                      TableCell(child: Center(child: Text('${DateFormat("MMM dd, yyyy").format(DateTime.parse(snapshot.data![x]["borrow_details"]["end_date"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
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
                            if(value.text == "Accept"){
                              _accept(details: snapshot.data![x]);
                            }else{
                              _decline(details: snapshot.data![x]);
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
        );
      }
    );
  }
  void _accept({required Map details}){
    bool _isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with buttons
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500),),
          content: Text('Are you sure you want to accept this reservation?',style: TextStyle(fontFamily: "OpenSans"),),
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
                _reservationApis.action(details: details, status: "Accepted").whenComplete((){
                  _reservationApis.delete(id: details["id"]);
                  Navigator.of(context).pop(null);
                  _notificationApis.add(payload: details, type: "borrow_accepted", content: "Request to borrow is accepted by admin!");
                  _snackbarMessage.snackbarMessage(context, message: "Successfully accepted reservation!");
                });
              },
              child: Text('Confirm',style: TextStyle(fontFamily: "OpenSans", color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  void _decline({required Map details}){
    bool _isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with buttons
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500),),
          content: Text('Are you sure you want to decline this reservation?',style: TextStyle(fontFamily: "OpenSans"),),
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
                _reservationApis.action(details: details, status: "Declined").whenComplete((){
                  _reservationApis.delete(id: details["id"]);
                  Navigator.of(context).pop(null);
                  _notificationApis.add(payload: details, type: "borrow_declined", content: "Request to borrow is declined by admin!");
                  _snackbarMessage.snackbarMessage(context, message: "Successfully declined reservation!");
                });
              },
              child: Text('Decline',style: TextStyle(fontFamily: "OpenSans", color: Colors.white),),
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