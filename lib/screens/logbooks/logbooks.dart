import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;

class LogBooks extends StatefulWidget {
  @override
  State<LogBooks> createState() => _LogBooksState();
}

class _LogBooksState extends State<LogBooks> {
  final Routes _routes = new Routes();
  final _scrollController = ScrollController();
  List? _logbooks;
  List? _toSearch;
  bool _isFetching = true;

  Future<List<dynamic>> _get() async {
    String jsonString =
    await rootBundle.loadString('assets/jsons/logbooks.json');
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
    _get();
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
            flexibleSpace: Appbar(title: "LOGBOOKS", onchange: (text){
              setState(() {
                _logbooks = _toSearch!.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList();
              });
            },onAdd: (){

            },)
        ),
        backgroundColor: Colors.white,
        body: _isFetching ?
        Center(
          child: CircularProgressIndicator(),
        ) :
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
                    2: FixedColumnWidth(100),
                    3: FlexColumnWidth(),
                    4: FlexColumnWidth(),
                    5: FixedColumnWidth(150),
                    6: FixedColumnWidth(150),
                    7: FixedColumnWidth(150),
                    8: FixedColumnWidth(150),
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
                        TableCell(child: Center(child: Text('Log date',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                        TableCell(child: Center(child: Text('Log time',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                      ],
                    ),
                    for(int x = 0; x < _logbooks!.length; x++)...{
                      TableRow(
                        decoration: BoxDecoration(
                            color: x.isEven ? Colors.white : colors.umber.withOpacity(0.1)
                        ),
                        children: <Widget>[
                          TableCell(child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                            child: Center(child: Text('${_logbooks![x]["id"]}',style: TextStyle(fontFamily: "Roboto_normal"))),
                          )),
                          TableCell(child: Center(child: Text('${_logbooks![x]["name"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["age"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["school_id"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["department"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["year"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["section"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["log_date"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
                          TableCell(child: Center(child: Text('${_logbooks![x]["log_time"]}',style: TextStyle(fontFamily: "Roboto_normal")))),
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