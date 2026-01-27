import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_book/models/notifications.dart';
import 'package:library_book/models/page_navigators.dart';
import 'package:library_book/services/apis/admin.dart';
import 'package:library_book/services/routes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../credentials/login.dart';
import '../../models/users.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import 'button.dart';
import 'dart:typed_data';


class Appbar extends StatefulWidget {
  final String title;
  final bool isBook, isReservation, hasAddButton;
  final ValueChanged<String> onchange;
  final Function(String)? selected;
  final Function onAdd, onPrint;
  final Widget? filterWidget, datePicker;
  Appbar({required this.title, required this.onchange, this.isBook = false, this.isReservation = false, this.filterWidget, this.datePicker,  this.hasAddButton = false, this.selected, required this.onAdd, required this.onPrint});
  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _age = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _phone = new TextEditingController();
  final Materialbutton _materialbutton = new Materialbutton();
  final AdminApis _adminApis = new AdminApis();
  String _gender = "";
  // Uint8List? _pickedImageBytes;
  final Routes _routes = new Routes();
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  String _selected = "book";
  String _base64 = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    _fname.text = usersModel.loggedUser.value["fname"];
    _lname.text = usersModel.loggedUser.value["lname"];
    _age.text = usersModel.loggedUser.value["age"];
    _email.text = usersModel.loggedUser.value["email"];
    _phone.text = usersModel.loggedUser.value["phone"];
    _gender = usersModel.loggedUser.value["gender"];
    // if(usersModel.loggedUser.value["base64Image"] != ""){
      uploadPict.update(data: base64Decode(usersModel.loggedUser.value["base64Image"] ?? null));
    // }else{}
    // _pickedImageBytes = usersModel.loggedUser.value["base64Image"] != "" ? base64Decode(usersModel.loggedUser.value["base64Image"]) : null;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.jms().format(_currentTime);
    return StreamBuilder(
        stream: usersModel.loggedUser,
        builder: (context, snapshot) {
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                if(pageNavigatorsModel.value)...{
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: (){
                            pageNavigatorsModel.update(data: false);
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text("NOTIFICATIONS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: colors.umber),),
                      ],
                    ),
                  ),
                }else...{
                  IgnorePointer(
                    ignoring: !widget.isBook,
                    child: InkWell(
                        onTap: (){
                          widget.selected!("book");
                          setState(() {
                            _selected = "book";
                          });
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(widget.title,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "book" ? colors.umber : Colors.grey,),),
                              if(widget.isBook || widget.hasAddButton)...{
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: CircleAvatar(
                                      backgroundColor: _selected == "book" ? colors.umber : Colors.grey,
                                      child: Center(
                                        child: Icon(Icons.add,color: Colors.white,size: 20,),
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    widget.onAdd();
                                  },
                                )
                              },
                            ],
                          ),
                        )
                    ),
                  ),
                  if(widget.isBook)...{
                    VerticalDivider(color: colors.umber.withOpacity(0.1),),
                  },
                  if(widget.isBook)...{
                    InkWell(
                        onTap: (){
                          widget.selected!("borrower");
                          setState(() {
                            _selected = "borrower";
                          });
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(child: Text("BORROWERS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "borrower" ? colors.umber : Colors.grey,),)),
                        )
                    ),
                  },
                  if(widget.isReservation)...{
                    VerticalDivider(color: colors.umber.withOpacity(0.1),),
                  },
                  if(widget.isReservation)...{
                    InkWell(
                        onTap: (){
                          widget.selected!("reservation");
                          setState(() {
                            _selected = "reservation";
                          });
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(child: Text("RESERVATIONS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: _selected == "reservation" ? colors.umber : Colors.grey,),)),
                        )
                    ),
                  },
                },
                Spacer(),
                widget.datePicker ?? SizedBox(),
                SizedBox(
                  width: 20,
                ),
                widget.filterWidget ?? SizedBox(),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: Icon(Icons.print, size: 27, color: colors.umber,),
                  onPressed: (){
                    widget.onPrint();
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                StreamBuilder(
                  stream: notificationModel.subject,
                  builder: (context, snapshot) {
                    return !snapshot.hasData ?
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: colors.umber, strokeWidth: 3,),
                    ) :
                    IconButton(
                      icon: Badge(
                        label: Text("${snapshot.data!.where((s) => s["is_read"] == "0").toList().length}"),
                        child: Icon(Icons.notifications_none,size: 27, color: colors.umber,),
                      ),
                      onPressed: (){
                        pageNavigatorsModel.update(data: !pageNavigatorsModel.value);
                      },
                    );
                  }
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 350,
                  child: TextField(
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(fontFamily: "OpenSans"),
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
                      widget.onchange(text);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formattedTime,style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.bold),),
                    Text(DateFormat("MMM dd, yyyy").format(DateTime.now()),style: TextStyle(fontFamily: "OpenSans",fontSize: 11),),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: (){
                      _showRightToLeftModal(context, user: snapshot.data!);
                    },
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: CircleAvatar(
                        child: usersModel.loggedUser.value["base64Image"]!= "" ?
                        Image.memory(
                          base64Decode(usersModel.loggedUser.value["base64Image"]),
                          width: 35,
                          height: 55,
                          fit: BoxFit.fill,
                        ) :
                        Image(
                          image: AssetImage("assets/icons/book.png"),
                          width: 50,
                          height: 50,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  void _showRightToLeftModal(BuildContext context,{required Map user}) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Background color
      barrierDismissible: true, // Dismissible by tapping the barrier
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight, // Aligns the modal to the right
          child: Material(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
              color: Colors.white,
              width: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: uploadPict.subject,
                    builder: (context, snapshot) {
                      return Center(
                        child: CircleAvatar(
                            minRadius: 45,
                            maxRadius: 65,
                            child: !snapshot.hasData ?
                            CircularProgressIndicator() :
                            Stack(
                              children: [
                                Center(
                                  child: snapshot.data!.isNotEmpty ?
                                  Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.fill,
                                  ) : Image(
                                    image: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () async{
                                        _convertBase64();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey.shade200,
                                        child: Icon(Icons.edit,color: colors.umber,),
                                      ),
                                    )
                                ),
                              ],
                            )
                        ),
                      );
                    }
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _fname,
                    style: TextStyle(fontFamily: "OpenSans"),
                    decoration: InputDecoration(
                      hintText: 'Firstname',
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
                    decoration: InputDecoration(
                      hintText: 'Age',
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
                    decoration: InputDecoration(
                      hintText: 'Email address',
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
                    decoration: InputDecoration(
                      hintText: 'Phone number',
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
                  Spacer(),
                  _materialbutton.materialButton("Update", ()async{
                    Map _payload = {
                      "fname": _fname .text,
                      "lname": _lname.text,
                      "age": _age.text,
                      "email": _email.text,
                      "phone": _phone.text,
                      "base64Image": _base64,
                      "admin_id": usersModel.loggedUser.value["admin_id"],
                      "gender": usersModel.loggedUser.value["gender"],
                      "subject": usersModel.loggedUser.value["subject"],
                      "phone": usersModel.loggedUser.value["phone"],
                      "email": usersModel.loggedUser.value["email"],
                      "pass": usersModel.loggedUser.value["pass"],
                    };
                    print(usersModel.loggedUser.value["admin_id"]);
                    _adminApis.editAdmin(admin_id: usersModel.loggedUser.value["admin_id"], payload: _payload);
                    Navigator.of(context).pop(null);
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    child: Center(child: Text("Logout",style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),)),
                    onPressed: ()async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      usersModel.updateUser(data: {});
                      _routes.navigator_pushreplacement(context, Login());
                    },
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // This handles the slide animation
        return SlideTransition(
          // Tween begins at Offset(1, 0) (right side) and ends at Offset(0, 0) (original position)
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
  Future<String?> _convertBase64() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        setState(() {
          _base64 = base64Encode(fileBytes);
          uploadPict.update(data: result.files.first.bytes!);
          // _pickedImageBytes = result.files.first.bytes;
          // print("GET IMAGE BYTE $_pickedImageBytes");
        });
      }
    }
    return null;
  }
}

class UploadPict{
  BehaviorSubject<Uint8List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  Uint8List get current => subject.value;

  update({required Uint8List data}){
    subject.add(data);
  }
}
final UploadPict uploadPict = new UploadPict();
