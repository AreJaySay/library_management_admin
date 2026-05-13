import 'dart:convert';
import 'dart:ui' as ui;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/users.dart';
import 'package:library_book/screens/users/components/edit_user_modal.dart';
import 'package:library_book/screens/widgets/appbar.dart';
import 'package:library_book/screens/widgets/shimmer_loader/table.dart';
import 'package:library_book/services/apis/users.dart';
import 'package:library_book/services/routes.dart';
import 'package:library_book/utils/palettes/app_colors.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:universal_html/html.dart' as html;
import '../../widgets/no_data_widget.dart';
import '../widgets/button.dart';
import 'components/delete_modal.dart';
import 'components/filters.dart';

class Users extends StatefulWidget {
  final bool isInventory;
  Users({this.isInventory = false});
  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final Routes _routes = new Routes();
  final Materialbutton _materialbutton = new Materialbutton();
  final UsersApi _usersApi = new UsersApi();
  final _scrollController = ScrollController();
  final GlobalKey _printKey = GlobalKey();
  List? _toSearch;

  @override
  void initState() {
    // TODO: implement initState
    _usersApi.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersModel.subject,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                  elevation: 1,
                  shadowColor: Colors.grey.shade200,
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(left: widget.isInventory ? 50 : 0),
                    child: Appbar(
                      title: "STUDENTS",
                      onchange: (text) {
                        List _res = usersModel.valueSearch.where((s) =>
                            s["name"].toString().toLowerCase().contains(
                                text.toLowerCase())).toList();
                        usersModel.update(data: _res);
                      },
                      onPrint: () async {
                        _createExcel(datas: snapshot.data!);
                      },
                      onAdd: () {},
                      datePicker: IconButton(
                        icon: Icon(Icons.date_range, color: colors.umber,),
                        onPressed: () {
                          _selectMonth(context);
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
                                          print(v);
                                          List _res = usersModel.valueSearch.where((s) => s["department"] == v["department"] && s["course"] == v["selected_section"]).toList();
                                          usersModel.update(data: _res);
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
                    ),
                  )),
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
                        usersModel.update(data: usersModel.valueSearch);
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
                          border: TableBorder(
                            horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(150),
                            1: FixedColumnWidth(150),
                            2: FlexColumnWidth(),
                            3: FlexColumnWidth(),
                            4: FixedColumnWidth(200),
                            5: FixedColumnWidth(200),
                            6: FixedColumnWidth(100),
                            7: FixedColumnWidth(150),
                            8: FixedColumnWidth(150),
                            9: FixedColumnWidth(100),
                          },
                          defaultVerticalAlignment: TableCellVerticalAlignment
                              .middle,
                          children: <TableRow>[
                            TableRow(
                              children: <Widget>[
                                TableCell(child: Center(child: Text('Photo',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                      vertical: 10),
                                  child: Center(child: Text('ID',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold),)),
                                )),
                                TableCell(child: Center(child: Text('First name',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Center(child: Text('Last name',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Center(child: Text('Email',
                                    style: TextStyle(
                                    fontFamily: "Roboto_normal",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)))),
                                TableCell(child: Center(child: Text('Phone',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Center(child: Text('Year group',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Center(child: Text('Department',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Center(child: Text('Course',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                                TableCell(child: Center(child: Text('Action',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                              ],
                            ),
                            for(int x = 0; x < snapshot.data!.length; x++)...{
                              TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.white
                                ),
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                          child: snapshot
                                              .data![x]["base64Image"] != "" && snapshot.data![x]["base64Image"] != null ?
                                          Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(1000),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: MemoryImage(
                                                          base64Decode(snapshot
                                                              .data![x]["base64Image"]))
                                                  )
                                              )):
                                          Center(child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "https://cdn-icons-png.freepik.com/512/8742/8742495.png")
                                          ))
                                      ),
                                    ),
                                  ),
                                  TableCell(child: Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                        vertical: 10),
                                    child: Center(child: Text('${snapshot.data![x]["id"]}',
                                        style: TextStyle(
                                            fontFamily: "Roboto_normal"))),
                                  )),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["firstname"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["lastname"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["email"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["phone"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["year"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["department"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(child: Text(
                                    '${snapshot.data![x]["course"]}',
                                    style: TextStyle(
                                        fontFamily: "Roboto_normal"),
                                    textAlign: TextAlign.center,))),
                                  TableCell(child: Center(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          customButton: Icon(
                                              Icons.more_vert,
                                              color: colors.clay
                                          ),
                                          items: [
                                            ...MenuItems.firstItems.map(
                                                  (item) =>
                                                  DropdownMenuItem<MenuItem>(
                                                    value: item,
                                                    child: MenuItems.buildItem(
                                                        item),
                                                  ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            MenuItems.onChanged(
                                                context, value! as MenuItem);
                                            showDialog<void>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        backgroundColor: Colors
                                                            .white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    20.0))
                                                        ),
                                                        content: value.text == "Edit" ? EditUserModal(details: snapshot.data![x],) : DeleteModal(details: snapshot.data![x],)
                                                    )
                                            );
                                          },
                                          dropdownStyleData: DropdownStyleData(
                                            width: 160,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(4),
                                              color: Colors.white,
                                            ),
                                            offset: const Offset(0, 8),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            customHeights: [
                                              ...List<double>.filled(
                                                  MenuItems.firstItems.length,
                                                  48),

                                            ],
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
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
                  ),
                ],
              )
          );
        }
    );
  }

  Future _createExcel({required List datas}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Students'];
    sheet.appendRow([
      TextCellValue("ID"),
      TextCellValue("Firstname"),
      TextCellValue("Lastname"),
      TextCellValue("School Id"),
      TextCellValue("Email"),
      TextCellValue("Phone"),
      TextCellValue("Year"),
      TextCellValue("Department"),
      TextCellValue("Course"),
    ]);
    for (int x = 0; x < datas.length; x++) {
      sheet.appendRow([
        TextCellValue("${x + 1}"),
        TextCellValue("${datas[x]["firstname"]}"),
        TextCellValue("${datas[x]["lastname"]}"),
        TextCellValue("${datas[x]["id"]}"),
        TextCellValue("${datas[x]["email"]}"),
        TextCellValue("${datas[x]["phone"]}"),
        TextCellValue("${datas[x]["year"]}"),
        TextCellValue("${datas[x]["department"]}"),
        TextCellValue("${datas[x]["course"]}"),
      ]);
    }

    final fileBytes = excel.encode()!;
    final content = base64Encode(fileBytes);
    final anchor = html.AnchorElement(
      href: "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$content",
    )
      ..setAttribute("download", "Students.xlsx")
      ..click();
  }

  Future<void> _selectMonth(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      List _res = usersModel.valueSearch.where((s) => DateFormat.yMMM().format(DateTime.parse(s["created_at"])) == DateFormat.yMMM().format(picked)).toList();
      usersModel.update(data: _res);
      print(picked);
    }
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