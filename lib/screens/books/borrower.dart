import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/borrowers.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/services/apis/borrowers.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;

import '../widgets/shimmer_loader/table.dart';
class Borrower extends StatefulWidget {
  @override
  State<Borrower> createState() => _BorrowerState();
}

class _BorrowerState extends State<Borrower> {
  final Routes _routes = new Routes();
  final BorrowersApi _borrowersApi = new BorrowersApi();
  final _scrollController = ScrollController();
  List? _logbooks;
  List? _toSearch;
  bool _isFetching = true;

  Future<List<dynamic>> _get() async {
    String jsonString = await rootBundle.loadString('assets/jsons/borrowers.json');
    setState(() {
      _toSearch = jsonDecode(jsonString);
      _logbooks = jsonDecode(jsonString);
      _isFetching = false;
    });
    return jsonDecode(jsonString);
  }

  @override
  void initState() {
    // TODO: implement initState
    _borrowersApi.getBorrowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: borrowersModel.subject,
        builder: (context, snapshot) {
        return !snapshot.hasData ?
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
                            color: x.isEven ? Colors.white : colors.umber.withOpacity(0.1)
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
                          TableCell(child: Center(child: Text('${snapshot.data![x]["book_information"]["title"]}',style: TextStyle(fontFamily: "Roboto_normal",),textAlign: TextAlign.center,maxLines: 3,))),
                          TableCell(child: Center(child: Text('${snapshot.data![x]["borrow_details"]["borrow_date"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                          TableCell(child: Center(child: Text('${snapshot.data![x]["borrow_details"]["end_date"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                          TableCell(child: Center(child: Text('Pending',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
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
                                print("${value.text}");
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