import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _schoolid = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String _department = "";
  String _year = "";
  String _section = "";
  Uint8List? _pickedImageBytes;
  String _base64 = "";

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
    _name.text = widget.details["name"];
    _age.text = "${widget.details["age"]}";
    _schoolid.text = "${widget.details["school_id"]}";
    _email.text = "${widget.details["email"]}";
    _department = widget.details["department"];
    _year = "${widget.details["year"]} year";
    _section = widget.details["section"];
    _base64 = widget.details!["base64Image"];
    _pickedImageBytes = widget.details!["base64Image"] == "" ? null : base64Decode(widget.details!["base64Image"]);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _age.dispose();
    _schoolid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 750,
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
                  child: CircleAvatar(
                      minRadius: 50,
                      maxRadius: 70,
                      backgroundColor: Colors.grey.shade100,
                      child: Stack(
                        children: [
                          Center(
                            child: _pickedImageBytes != null ?
                            Image.memory(
                              _pickedImageBytes!,
                              width: 60,
                              height: 110,
                              fit: BoxFit.cover,
                            ) :
                            Image(
                              image: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                              width: 130,
                              height: 130,
                            ),
                          ),
                          Align(
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
                        ],
                      )
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _name,
                  style: TextStyle(fontFamily: "OpenSans"),
                  decoration: InputDecoration(
                    hintText: 'Fullname',
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
                  controller: _age,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Age',
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
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _schoolid,
                  style: TextStyle(fontFamily: "OpenSans"),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'School ID',
                    prefixIcon: Icon(Icons.assignment_ind),
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
                      'College of Arts and Science',
                      'College of Education',
                      'College of Nursing',
                      'College of Engineering'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Row(
                      children: [
                        Icon(Icons.apartment),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_department.isEmpty
                            ? 'Department'
                            : _department,style: TextStyle(fontFamily: "OpenSans",fontSize: 16),),
                      ],
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
                            : _year,style: TextStyle(fontFamily: "OpenSans",fontSize: 16),),
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
                    style: TextStyle(fontFamily: "OpenSans",fontSize: 16),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    items: <String>[
                      'A',
                      'B',
                      'C',
                      'D',
                      'E',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                      );
                    }).toList(),
                    hint: Row(
                      children: [
                        Icon(Icons.abc),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_section.isEmpty
                            ? 'Section'
                            : _section,style: TextStyle(fontFamily: "OpenSans",fontSize: 16),),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    underline: SizedBox(),
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _section = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                _materialbutton.materialButton("Update", (){
                  if(_name.text.isEmpty || _age.text.isEmpty || _schoolid.text.isEmpty || _department == "" || _department == "" || _section == ""){
                    _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
                  }else{
                    Map _payload = {
                      "name": _name.text,
                      "age": _age.text,
                      "email": _email.text,
                      "school_id": _schoolid.text,
                      "department": _department,
                      "year": _year,
                      "section": _section,
                      "base64Image": _base64,
                      "password": widget.details["password"]
                    };
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
}
