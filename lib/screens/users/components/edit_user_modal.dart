import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_book/functions/loaders.dart';
import 'package:library_book/screens/widgets/button.dart';
import 'package:library_book/services/apis/users.dart';
import 'package:library_book/utils/snackbars/snackbar_message.dart';

import '../../../utils/palettes/app_colors.dart' hide Colors;

class EditUserModal extends StatefulWidget {
  final Map details;
  EditUserModal({required this.details});
  @override
  State<EditUserModal> createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final Materialbutton _materialbutton = new Materialbutton();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final UsersApi _usersApi = new UsersApi();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String _year = "";
  String _course = "";
  String _department = "";
  Uint8List? _pickedImageBytes;
  String _base64 = "";
  List? _filters;

  Future<String?> _convertBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        setState(() {
          _base64 = base64Encode(fileBytes);
          _pickedImageBytes = result.files.first.bytes;
          print("GET IMAGE BYTE $_pickedImageBytes");
        });
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadJson();
    _fname.text = widget.details["firstname"];
    _lname.text = widget.details["lastname"];
    _phone.text = "${widget.details["phone"]}";
    _email.text = "${widget.details["email"]}";
    _year = "${widget.details["year"] ?? ""}";
    _base64 = widget.details!["base64Image"];
    _pickedImageBytes = widget.details!["base64Image"] == "" ? null : base64Decode(widget.details!["base64Image"]);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fname.dispose();
    _lname.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 650,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _pickedImageBytes != null ?
                                    MemoryImage(_pickedImageBytes!) : NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                                )
                            ))
                      ),
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async{
                                  _convertBase64();
                                },
                                child: CircleAvatar(
                                  backgroundColor: colors.coffee,
                                  child: Icon(Icons.edit,color: colors.umber,),
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _fname,
                  style: TextStyle(fontFamily: "OpenSans"),
                  decoration: InputDecoration(
                    hintText: 'Firstname',
                    prefixIcon: Icon(Icons.person),
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _lname,
                  style: TextStyle(fontFamily: "OpenSans"),
                  decoration: InputDecoration(
                    hintText: 'Lastname',
                    prefixIcon: Icon(Icons.person),
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _phone,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    prefixIcon: Icon(Icons.calendar_month),
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _email,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    prefixIcon: Icon(Icons.calendar_month),
                    hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                    ),
                  ),
                  onChanged: (text) {

                  },
                ),
                SizedBox(
                  height: 15,
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    items: <String>[
                      '1st year',
                      '2nd year',
                      '3rd year',
                      '4th year'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Row(
                      children: [
                        Icon(Icons.signal_cellular_alt),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_year.isEmpty
                            ? 'Year'
                            : _year,style: TextStyle(fontFamily: "OpenSans",fontSize: 16, color: Colors.black),),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _year = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
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
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    items: <String>[
                      for(int x = 0; x < _filters!.length; x++)...{
                        "${_filters![x]["department"]}"
                      }
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(_department.isEmpty
                              ? '${widget.details["department"] ?? ""}'
                              : _department,style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _department = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
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
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    items: <String>[
                      if(_department.isNotEmpty)...{
                        for(int x = 0; x < _filters!.where((s) => s["department"] == _department).toList().first["courses"].length; x++)...{
                          "${_filters!.where((s) => s["department"] == _department).toList().first["courses"][x]}"
                        }
                      }
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(_course.isEmpty
                              ? '${widget.details["course"] ?? ""}'
                              : _course,style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),),
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _course = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                _materialbutton.materialButton("Update", (){
                  if(_fname.text.isEmpty || _lname.text.isEmpty || _phone.text.isEmpty || _email.text.isEmpty || _year == "" ){
                    _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                  }else{
                    Map _payload = {
                      "id": "${widget.details["id"]}",
                      "firstname": _fname.text,
                      "lastname": _lname.text,
                      "phone": _phone.text,
                      "email": _email.text,
                      "year": _year,
                      "department": _department == "" ? widget.details["department"] ?? "" : _department,
                      "course":  _course == "" ? widget.details["course"] ?? "" : _course,
                      "base64Image": _base64,
                      "password": widget.details["password"],
                    };
                    print(widget.details["id"]);
                    _screenLoaders.functionLoader(context);
                    _usersApi.edit(id: widget.details["id"], payload: _payload).whenComplete((){
                      Navigator.of(context).pop(null);
                      Navigator.of(context).pop(null);
                      _snackbarMessage.snackbarMessage(context, message: "Book details updated successfully!");
                    });
                  }
                }),
                SizedBox(
                  height: 20,
                )
              ],
            ),
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

  Future<void> _loadJson() async {
    final String response = await rootBundle.loadString('assets/jsons/filter_students.json');
    final data = json.decode(response);
    setState(() {
      _filters = data;
    });
    print("FILTERS $data");
  }
}
