import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:library_book/screens/books/books.dart';
import 'package:library_book/screens/users/users.dart';
import 'package:page_transition/page_transition.dart';

import '../../../services/routes.dart';

class TopCard extends StatelessWidget {
  final IconData icon;
  final String value, title;
  TopCard({required this.icon ,required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    final Routes _routes = new Routes();

    Color _color = Color.fromARGB(
      255,
      math.Random().nextInt(256),
      math.Random().nextInt(256),
      math.Random().nextInt(256),
    );

    return Expanded(
      child: Container(
        margin: EdgeInsetsGeometry.symmetric(vertical: 30),
        padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(color: _color)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 0),
              blurRadius: 9,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _color.withOpacity(0.2)
                      ),
                      child: Icon(icon, color: _color, size: 18,),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${value}',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(title,style: TextStyle(fontFamily: "AppFontStyle"),)
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 0),
                    blurRadius: 9,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: (){
                  if(title == "Total Books" || title == "Borrowed Books" || title == "Reserved Books" || title == "Overdue Books"){
                    _routes.navigator_push(context, Books(isInventory: true, type: title.toUpperCase(),), transitionType: PageTransitionType.fade);
                  }else{
                    _routes.navigator_push(context, Users(isInventory: true,), transitionType: PageTransitionType.fade);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
