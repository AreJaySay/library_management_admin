import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_book/models/attendances.dart';
import 'package:library_book/models/users.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../utils/snackbars/snackbar_message.dart';
import '../../widgets/button.dart';

class Filter extends StatefulWidget {
  final Function(Map) onConfirm;
  const Filter({required this.onConfirm});
  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final Materialbutton _materialbutton = new Materialbutton();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  List? _filters;
  Map? _selected;
  bool _isSelectAll = false;
  bool _isLoading = true;

  Future<void> _loadJson() async {
    final String response = await rootBundle.loadString('assets/jsons/filter_students.json');
    final data = json.decode(response);
    setState(() {
      _filters = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadJson().whenComplete((){
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 350,
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
                  Text("Add Filter",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 15),),
                  Spacer(),
                  Checkbox(
                    activeColor: colors.umber,
                    value: _isSelectAll,
                    onChanged: (v){
                      setState(() {
                        _isSelectAll = !_isSelectAll;
                        _selected = null;
                        usersModel.update(data: usersModel.valueSearch);
                        attendanceModel.update(data: attendanceModel.valueSearch);
                      });
                    },
                  ),
                  Text("Select All",style: TextStyle(fontFamily: "OpenSans",),),
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
                child: _isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                ) :
                DropdownButton<Map>(
                  focusColor: Colors.white,
                  style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  items: <Map>[
                    for(int x = 0; x < _filters!.length; x++)...{
                      _filters![x],
                    },
                  ].map((Map value) {
                    return DropdownMenuItem<Map>(
                      value: value,
                      child: Text("${value["department"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                    );
                  }).toList(),
                  hint: Text(_selected == null
                      ? 'Select department'
                      : "Grade ${_selected!["department"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _selected == null ? Colors.grey : Colors.black),),
                  borderRadius: BorderRadius.circular(10),
                  underline: SizedBox(),
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selected = value;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              IgnorePointer(
                ignoring: _selected == null,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.umber.withOpacity(0.1)),
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                    ),
                  ),
                  child: _selected == null ?
                  SizedBox() :
                  DropdownButton<String>(
                    focusColor: Colors.white,
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    items: <String>[
                      if(_selected!["courses"].isNotEmpty)...{
                        for(int x = 0; x < _selected!["courses"]!.length; x++)...{
                          _selected!["courses"][x],
                        },
                      }
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Text(
                      _selected!["courses"].isEmpty ? "No section available" :
                      _selected!["selected_section"] == "" ? 'Select course'
                          : _selected!["selected_section"],style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: _selected!["selected_section"] == "" ? Colors.grey : Colors.black),),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    icon: _selected!["courses"].isEmpty ? SizedBox() : Icon(Icons.arrow_drop_down_sharp),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selected!["selected_section"] = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              Spacer(),
              _materialbutton.materialButton("Continue", (){
                if(_selected!["selected_section"] != ""){
                  if(_selected != null){
                    widget.onConfirm(_selected!);
                  }
                  Navigator.of(context).pop(_selected);
                }else{
                  _snackbarMessage.snackbarMessage(context, message: "Select course to continue.", is_error: true);

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
}
