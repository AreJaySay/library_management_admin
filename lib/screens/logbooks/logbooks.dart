import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/attendances.dart';
import 'package:library_book/models/users.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/services/apis/attendances.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
import '../../widgets/no_data_widget.dart';
import '../users/components/filters.dart';
import '../widgets/button.dart';
import '../widgets/shimmer_loader/table.dart';
import 'components/date_type.dart';

class LogBooks extends StatefulWidget {
  @override
  State<LogBooks> createState() => _LogBooksState();
}

class _LogBooksState extends State<LogBooks> {
  final Routes _routes = new Routes();
  final _scrollController = ScrollController();
  final GlobalKey _printKey = GlobalKey();
  final Materialbutton _materialbutton = new Materialbutton();
  final AttendancesApis _attendancesApis = new AttendancesApis();

  @override
  void initState() {
    // TODO: implement initState
    _attendancesApis.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: attendanceModel.subject,
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(
                elevation: 1,
                shadowColor: Colors.grey.shade200,
                centerTitle: false,
                backgroundColor: Colors.white,
                flexibleSpace: Appbar(title: "LOGBOOKS", onchange: (text){
                  setState(() {
                    // _logbooks = _toSearch!.where((s) => s["name"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                    List _res = attendanceModel.valueSearch.where((s) => s.last["name"].toString().toLowerCase().contains(text.toLowerCase())).toList();
                    attendanceModel.update(data: _res);
                  });
                }, onPrint: ()async{
                  _createExcel(datas: snapshot.data!);
                },onAdd: (){},
                  datePicker: IconButton(
                    icon: Icon(Icons.date_range, color: colors.umber,),
                    onPressed: () async{
                      await showDialog<void>(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))
                                  ),
                                  content: DateType()
                              )
                      );
                    },
                  ),
                  filterWidget: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white),
                    ),
                    onPressed: () async {
                      await showDialog<void>(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))
                                  ),
                                  content: Filter(
                                    onConfirm: (v) {
                                      List _res = attendanceModel.valueSearch.where((s) => s.last["department"] == v["department"] && s.last["course"] == v["selected_section"]).toList();
                                      attendanceModel.update(data: _res);
                                    },
                                  )
                              )
                      );
                    },
                    child: Row(
                      children: [
                        Text("Filter", style: TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.w600,
                            color: colors.umber),),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_drop_down_sharp, color: colors.umber,)
                      ],
                    ),
                  ),
                )
            ),
            backgroundColor: Colors.white,
            body: !snapshot.hasData ?
            TableLoader() :
            snapshot.data!.isEmpty ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NoDataWidget(),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      height: 45,
                      width: 300,
                      child: _materialbutton.materialButton("Refresh", (){
                        attendanceModel.update(data: attendanceModel.valueSearch);
                      })
                  )
                ],
              ),
            ) :
            Stack(
              children: [
                RepaintBoundary(
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
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(100),
                          3: FlexColumnWidth(),
                          4: FlexColumnWidth(),
                          5: FixedColumnWidth(150),
                          6: FixedColumnWidth(150),
                          7: FixedColumnWidth(200),
                          8: FixedColumnWidth(200),
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
                              TableCell(child: Center(child: Text('Log In',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
                              TableCell(child: Center(child: Text('Log Out',style: TextStyle(fontFamily: "Roboto_normal",fontWeight: FontWeight.bold,fontSize: 15)))),
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
                                TableCell(child: Center(child: Text('${snapshot.data![x].last["name"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x].last["age"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x].last["school_id"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x].last["department"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x].last["year"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${snapshot.data![x].last["section"]}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${DateFormat("dd MMM yyyy h:mm").format(DateTime.parse(snapshot.data![x].first["date_time"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                                TableCell(child: Center(child: Text('${DateFormat("dd MMM yyyy h:mm").format(DateTime.parse(snapshot.data![x][1]["date_time"]))}',style: TextStyle(fontFamily: "Roboto_normal"),textAlign: TextAlign.center,))),
                              ],
                            ),
                          }
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        );
      }
    );
  }

  Future _createExcel({required List datas}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Logbooks'];
    sheet.appendRow([
      TextCellValue("ID"),
      TextCellValue("Name"),
      TextCellValue("Age"),
      TextCellValue("School ID"),
      TextCellValue("Department"),
      TextCellValue("Year"),
      TextCellValue("Section"),
      TextCellValue("Log In"),
      TextCellValue("Log Out"),
    ]);
    for(int x = 0; x < datas.length; x++){
      sheet.appendRow([
        TextCellValue("${x+1}"),
        TextCellValue("${usersModel.value.where((s) => s["school_id"] == datas[x].first["school_id"]).toList().first["name"]}"),
        TextCellValue("${usersModel.value.where((s) => s["school_id"] == datas[x].first["school_id"]).toList().first["age"]}"),
        TextCellValue("${usersModel.value.where((s) => s["school_id"] == datas[x].first["school_id"]).toList().first["school_id"]}"),
        TextCellValue("${usersModel.value.where((s) => s["school_id"] == datas[x].first["school_id"]).toList().first["department"]}"),
        TextCellValue("${usersModel.value.where((s) => s["school_id"] == datas[x].first["school_id"]).toList().first["year"]}"),
        TextCellValue("${usersModel.value.where((s) => s["school_id"] == datas[x].first["school_id"]).toList().first["section"]}"),
        TextCellValue("${datas[x].first["date_time"] == null ? "--" : DateFormat("dd MMM yyyy h:mm").format(DateTime.parse(datas[x].first["date_time"]))}"),
        TextCellValue("${datas[x].last["date_time"] == null ? "--" : DateFormat("dd MMM yyyy h:mm").format(DateTime.parse(datas[x].last["date_time"]))}"),
      ]);
    }

    final fileBytes = excel.encode()!;
    final content = base64Encode(fileBytes);
    final anchor = html.AnchorElement(
      href: "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$content",
    )
      ..setAttribute("download", "logbooks.xlsx")
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