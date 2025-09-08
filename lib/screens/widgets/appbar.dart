import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;

class Appbar extends StatefulWidget {
  final String title;
  final bool isBook, hasAddButton;
  final Color color,toggleColor;
  final ValueChanged<String> onchange;
  final Function(bool)? toggleBook;
  final Function onAdd;
  Appbar({required this.title, required this.onchange, this.isBook = false, this.hasAddButton = false, required this.color, required this.toggleColor, this.toggleBook, required this.onAdd});
  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  bool _isBooks = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.jms().format(_currentTime);
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            IgnorePointer(
              ignoring: !widget.isBook,
              child: InkWell(
                onTap: (){
                  widget.toggleBook!(true);
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(widget.title,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: widget.color),),
                      if(widget.isBook || widget.hasAddButton)...{
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: SizedBox(
                            width: 23,
                            height: 23,
                            child: CircleAvatar(
                              backgroundColor: widget.color,
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
                    widget.toggleBook!(false);
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: Text("BORROWERS",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold,fontSize: 15,color: widget.toggleColor),)),
                  )
              ),
            },
            Spacer(),
            SizedBox(
              width: 500,
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
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(formattedTime,style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.bold),),
                Text(DateFormat("yyyy/MM/dd").format(DateTime.now()),style: TextStyle(fontFamily: "OpenSans",fontSize: 11),),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            VerticalDivider(color: Colors.grey.shade200,),
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/9193/9193832.png"),
            ),
            SizedBox(
              width: 5,
            ),
            Text("Admin"),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
