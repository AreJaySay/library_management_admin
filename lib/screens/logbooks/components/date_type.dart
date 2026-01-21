import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/attendances.dart';
import 'package:library_book/models/users.dart';
import 'package:library_book/screens/logbooks/components/weekly_report.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../utils/snackbars/snackbar_message.dart';
import '../../widgets/button.dart';

class DateType extends StatefulWidget {
  @override
  State<DateType> createState() => _DateTypeState();
}

class _DateTypeState extends State<DateType> {
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  String _selected = "";
  bool _isRefresh = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Filter Report",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 15),),
                  Spacer(),
                  Checkbox(
                    activeColor: colors.umber,
                    value: _isRefresh,
                    onChanged: (v){
                      setState(() {
                        _isRefresh = !_isRefresh;
                        _selected = "";
                      });
                      usersModel.update(data: usersModel.valueSearch);
                      attendanceModel.update(data: attendanceModel.valueSearch);
                    },
                  ),
                  Text("Refresh",style: TextStyle(fontFamily: "OpenSans",),),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.umber.withOpacity(0.1)),
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                  ),
                ),
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  items: <String>[
                    "Daily",
                    "Weekly",
                    "Monthly"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text("$value",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                    );
                  }).toList(),
                  hint: Text(_selected == ""
                      ? 'Select type'
                      : "$_selected",style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _selected == null ? Colors.grey : Colors.black),),
                  borderRadius: BorderRadius.circular(10),
                  underline: SizedBox(),
                  isExpanded: true,
                  onChanged: (value) async{
                    Navigator.of(context).pop(null);
                    if (value != null) {
                      setState(() {
                        _selected = value;
                        if(_selected == "Weekly"){
                          showDialog<void>(
                            context: context,
                              builder: (context) =>
                                AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                Radius.circular(20.0))
                              ),
                              content: WeeklyReports()
                            )
                           );
                        }else if(_selected == "Monthly"){
                          _selectMonth(context);
                        }else{
                          _selectDay(context);
                        }
                      });
                    }
                  },
                ),
              ),
              Spacer(),
              _materialbutton.materialButton("Continue", (){
                if(_selected != ""){
                  Navigator.of(context).pop(_selected);
                }else{
                  _snackbarMessage.snackbarMessage(context, message: "Select type to continue.", is_error: true);

                }
              }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
          Positioned(
            right: -40,
            top: -35,
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
    );
  }

  Future<void> _selectMonth(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      List _res = attendanceModel.valueSearch.where((s) => DateFormat.yMMM().format(DateTime.parse(s.first["date_time"])) == DateFormat.yMMM().format(picked)).toList();
      attendanceModel.update(data: _res);
    }
  }

  Future<void> _selectDay(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // The initially selected date
      firstDate: DateTime(2000),  // The earliest date a user can select
      lastDate: DateTime(2030),   // The latest date a user can select
    );
    if (picked != null) {
      List _res = attendanceModel.valueSearch.where((s) => DateFormat.d().format(DateTime.parse(s.first["date_time"])) == DateFormat.d().format(picked)).toList();
      attendanceModel.update(data: _res);
    }
  }
}
